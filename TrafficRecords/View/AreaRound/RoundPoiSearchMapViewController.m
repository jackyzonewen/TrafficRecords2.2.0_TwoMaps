//
//  RoundPoiSearchMapViewController.m
//  TrafficRecords
//
//  Created by Peter on 14-9-10.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "RoundPoiSearchMapViewController.h"

@interface RoundPoiSearchMapViewController ()

@end

@implementation RoundPoiSearchMapViewController
{
    WBMapView               *_mapView;
    WBUserLocation          * userlocation;
    UIView                  *infoView;
    
    POISearchService        *poiSearchService;
    GetOfficeInfoService    *service;
    
    WBPointAnnotation       *selectAnnotation;
}
@synthesize searchType;
@synthesize  typetitle;
-(NSString *) naviTitle{
    return typetitle;
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView tearDown];
}
-(UIView*) loadingView {
    UIView * superView = [TRAppDelegate appDelegate].window;
    UIView *view = [superView viewWithTag:99];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:superView.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 99;
        
        CGSize size = CGSizeMake(180, 68);
        UIView * cview = [[UIView alloc] initWithFrame:CGRectMake(superView.width/2 - size.width/2, superView.height/2 - size.height/2, size.width, size.height)];
        cview.backgroundColor = [TRSkinManager colorWithInt:0x44000000];
        cview.layer.cornerRadius = 6;
        [view addSubview:cview];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [TRSkinManager mediumFont2];
        label.text = @"正在搜索...";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        CGSize labelSize = [label.text sizeWithFont:label.font];
        [cview addSubview:label];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        float totalW = labelSize.width + 12 + indicator.width;
        float height = indicator.height > labelSize.height ? indicator.height : labelSize.height;
        indicator.frame = CGRectMake(cview.width/2 - totalW/2, cview.height/2 - indicator.height/2, indicator.width, indicator.height);
        [cview addSubview:indicator];
        [indicator startAnimating];
        label.frame = CGRectMake(indicator.right + 12, cview.height/2 - height/2, labelSize.width, height);
    }
    return view;
}
-(void) btnClick:(UIButton *)btn{
    NSString *title1 = nil;
    NSString *title2 = nil;
    NSString *title3 = nil;
    NSString *gaode = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=wz&backScheme=TRMapScheme:&lat=%f&lon=%f&dev=0&style=2", selectAnnotation.coordinate.latitude, selectAnnotation.coordinate.longitude];
    NSURL *gaodeUrl = [NSURL URLWithString:gaode];
    
    NSMutableString *baidu = [NSMutableString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=", userlocation.location.coordinate.latitude, userlocation.location.coordinate.longitude, selectAnnotation.coordinate.latitude, selectAnnotation.coordinate.longitude];
    [baidu appendString:[TRUtility URLEncodedString:@"TRMapScheme:|TRMapScheme:"]];
    NSURL *baiduUrl = [NSURL URLWithString:baidu];
    
    UIApplication *app =[UIApplication sharedApplication];
    if ([app canOpenURL:baiduUrl]) {
        title1 = @"百度地图(推荐)";
    }
    if ([app canOpenURL:gaodeUrl]) {
        if (title1 == nil) {
            title1 = @"高德地图";
        } else {
            title2 = @"高德地图";
        }
    }
    if (title1 == nil) {
        title1 = @"系统自带地图";
    } else if(title2 == nil){
        title2 = @"系统自带地图";
    } else {
        title3 = @"系统自带地图";
    }
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择导航地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title1,title2,title3,nil];
    sheet.tag = 103;
    [sheet showInView:self.view];
    //    GardLineChooseViewController *lineChooseView = [[GardLineChooseViewController alloc] initWithNibName:@"GardLineChooseViewController" bundle:nil];
    //    NSOfficInfo *officeInfo = [[NSOfficInfo alloc] init];
    //    officeInfo.name = selectAnnotation.title;
    //    officeInfo.address = selectAnnotation.subtitle;
    //    officeInfo.latbaidu = [NSString stringWithFormat:@"%f", selectAnnotation.coordinate.latitude];
    //    officeInfo.lngbaidu = [NSString stringWithFormat:@"%f", selectAnnotation.coordinate.longitude];
    //    officeInfo.latgaode = [NSString stringWithFormat:@"%f", selectAnnotation.coordinate.latitude];
    //    officeInfo.lnggaode = [NSString stringWithFormat:@"%f", selectAnnotation.coordinate.longitude];
    //    lineChooseView.officeInfo = officeInfo;
    //    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lineChooseView];
    //    [self presentViewController:navi animated:YES completion:nil];
}
-(void) openBaiduAppToNavi
{
    NSMutableString *baidu = [NSMutableString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=", userlocation.location.coordinate.latitude, userlocation.location.coordinate.longitude, selectAnnotation.coordinate.latitude, selectAnnotation.coordinate.longitude];
    [baidu appendString:[TRUtility URLEncodedString:@"TRMapScheme:|TRMapScheme:"]];
    
    NSURL *url = [NSURL URLWithString:baidu];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self showInfoView:@"抱歉，在您的设备上没有找到百度地图"];
    }
}
-(void) openGaodeAppToNavi{
    NSString *gaode = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=wz&backScheme=TRMapScheme:&lat=%f&lon=%f&dev=0&style=2", selectAnnotation.coordinate.latitude, selectAnnotation.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:gaode];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void) openSystemMapToNavi{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f) {
        //ios_version为4.0～5.1时 调用谷歌地图客户端
        
        //生成url字符串
        NSString *currentLocation = [NSString stringWithFormat:@"%f,%f",userlocation.location.coordinate.latitude, userlocation.location.coordinate.longitude];
        NSString *desLocation = [NSString stringWithFormat:@"%f,%f",selectAnnotation.coordinate.latitude, selectAnnotation.coordinate.longitude];
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",
                               currentLocation,desLocation];
        //转换为utf8编码
        urlString =  [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        UIApplication *app =[UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //验证url是否可用
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }else{
            //手机客户端不支持此功能 或者 目的地有误
            [self showInfoView:@"无法打开地图进行导航"];
        }
        
    }else{
        //ios_version为 >=6.0时 调用苹果地图客户端
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate = selectAnnotation.coordinate;
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:@"结束"];
            // Set the directions mode to "Walking"
            // Can use MKLaunchOptionsDirectionsModeDriving instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            MKMapItem *currentLocationMapItem = nil;
            if (NO) {
                currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            } else
            {
                MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:userlocation.location.coordinate
                                                                    addressDictionary:nil];
                currentLocationMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
            }
            [currentLocationMapItem setName:@"开始"];
            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }
    }
}


-(void) showInfoMsgView{
    UILabel *label1 = (UILabel *)[infoView viewWithTag:101];
    label1.text = selectAnnotation.title;
    UILabel *label2 = (UILabel *)[infoView viewWithTag:102];
    label2.text = selectAnnotation.subtitle;
    [UIView animateWithDuration:0.2 animations:^{
        infoView.frame = CGRectMake(0, self.view.height - 84, self.view.width, 84);
    }];
}

-(void) hideInfoMsgView{
    [UIView animateWithDuration:0.2 animations:^{
        infoView.frame = CGRectMake(0, self.view.height, self.view.width, 84);
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 103){
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"高德地图"]) {
            [self openGaodeAppToNavi];
        } else if([title isEqualToString:@"百度地图(推荐)"])
        {
            [self openBaiduAppToNavi];
        } else if([title isEqualToString:@"系统自带地图"])
        {
            [self openSystemMapToNavi];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view removeGestureRecognizer:recognizer];
    if (_mapView == nil)
    {
#if USE_BaiduMap
        _mapView = [[WBBaiduMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, self.view.height - KHeightReduce)];
        _mapView.mapType=kWBMapTypeStandard_baidu;
#else
        _mapView = [[WBGaodeMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, self.view.height - KHeightReduce)];
        _mapView.mapType=kWBMapTypeStandard_gaode;
#endif
    } else
    {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        [_mapView removeFromSuperview];
    }
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0, _mapView.bottom, self.view.width, 84)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 18, 200, 26)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [TRSkinManager mediumFont1];
    [infoView addSubview:label];
    label.tag = 101;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(12, 47, 200, 20)];
    label2.textColor = [UIColor grayColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [TRSkinManager smallFont1];
    [infoView addSubview:label2];
    label2.tag = 102;
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"查看导航" forState:UIControlStateNormal];
    [btn setBackgroundImage:TRImage(@"lookInNavi.png") forState:UIControlStateNormal];
    [btn setBackgroundImage:TRImage(@"lookInNaviHL.png") forState:UIControlStateHighlighted];
    [btn setTitleColor:[TRSkinManager colorWithInt:0xf2c2cb] forState:UIControlStateHighlighted];
    [btn setTitleColor:[self naviColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.frame = CGRectMake(infoView.width - 80 - 12, 25, 80, 32);
    [infoView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    NSString* latitudeKey=USE_BaiduMap?Latitude_Baidu_Key:Latitude_Gaode_Key;
    NSString* longitudeKey=USE_BaiduMap?Longitude_Baidu_Key:Longitude_Gaode_Key;
    if (tag == EServicePOISearch) {
        NSArray *array = [poiSearchService.responseDic objectForKey:@"result"];
        if (searchType == EAreaRound4sShop) {
            NSDictionary *dic = [poiSearchService.responseDic objectForKey:@"result"];
            array = [dic objectForKey:@"items"];
        }
        if (array.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到附近的兴趣点。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
     
        WBPointAnnotation *min = nil;
        for (NSDictionary *dic in array) {
            WBPointAnnotation *  annotation=[[WBPointAnnotation alloc] init];
            if (searchType == EAreaRound4sShop) {
                annotation.title = [dic objectForKey:@"vendorname"];
                annotation.subtitle = [dic objectForKey:@"address"];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:latitudeKey] doubleValue], [[dic objectForKey:longitudeKey] doubleValue]);
            }else {
                annotation.title = [dic objectForKey:@"vendorName"];
                annotation.subtitle = [dic objectForKey:@"address"];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longitude"] doubleValue]);
            }
            
            [_mapView addAnnotation:annotation];
            
            if (min == nil || ABS(min.coordinate.latitude - userlocation.location.coordinate.latitude) + ABS(min.coordinate.longitude - userlocation.location.coordinate.longitude) > ABS(annotation.coordinate.latitude - userlocation.location.coordinate.latitude) + ABS(annotation.coordinate.longitude - userlocation.location.coordinate.longitude)) {
                min = annotation;
            }
            [_mapView setCenterCoordinate:userlocation.location.coordinate];
            [_mapView setZoomLevel:13];
            if (min) {
                [_mapView selectAnnotation:min animated:NO];
            }
        }
    } else if(tag == EServiceGetOfficeInfo){
        NSArray *array = service.items;
        WBPointAnnotation *min = nil;
        if (array.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到附近的兴趣点。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        for (NSDictionary *dic in array) {
            WBPointAnnotation *  annotation=[[WBPointAnnotation alloc] init];
            //NSLog(@"dict:%@",dic);
            //            info.name = [temp objectForKey:@"name"];
            //            info.address = [temp objectForKey:@"address"];
            //            info.phoneShow = [temp objectForKey:@"phone_show"];
            //            info.phoneCall = [temp objectForKey:@"phone_call"];
            //            info.latbaidu = [temp objectForKey:@"latbaidu"];
            //            info.lngbaidu = [temp objectForKey:@"lngbaidu"];
            //            info.latgaode = [temp objectForKey:@"latgaode"];
            //            info.lnggaode = [temp objectForKey:@"lnggaode"];
            
            annotation.title = [dic objectForKey:@"name"];
            annotation.subtitle = [dic objectForKey:@"address"];
            annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:latitudeKey] doubleValue], [[dic objectForKey:longitudeKey] doubleValue]);
            [_mapView addAnnotation:annotation];
            
            if (min == nil || ABS(min.coordinate.latitude - userlocation.location.coordinate.latitude) + ABS(min.coordinate.longitude - userlocation.location.coordinate.longitude) > ABS(annotation.coordinate.latitude - userlocation.location.coordinate.latitude) + ABS(annotation.coordinate.longitude - userlocation.location.coordinate.longitude)) {
                min = annotation;
            }
            [_mapView setCenterCoordinate:userlocation.location.coordinate];
            [_mapView setZoomLevel:13];
            if (min) {
                [_mapView selectAnnotation:min animated:NO];
            }
        }
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
    if(tag == EServiceGetOfficeInfo){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取交管局地址信息失败，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    } else if (tag == EServicePOISearch){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询周边服务失败，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)searchPolicePOI
{
    if (currentCity == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法获取您所在区域的城市信息，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (service == nil) {
        service = [[GetOfficeInfoService alloc] init];
        service.delegate = self;
    }
    [service getOfficeInfoByCity:(int)currentCity.cityId];
}
-(void)searchAutohomePOI
{
    if (poiSearchService == nil) {
        poiSearchService = [[POISearchService alloc] init];
        poiSearchService.delegate = self;
    }
    NSInteger type = -1;
    if (searchType == EAreaRoundMeiRong) {
        type = 6;
    } else if(searchType == EAreaRoundZhuangshi){
        type = 37;
    } else if(searchType == EAreaRoundGaizhuang){
        type = 33;
    } else if(searchType == EAreaRoundRepair){
        type = 32;
    }else if(searchType == EAreaRoundWashCar){
        type = 41;
    }
    if (searchType == EAreaRound4sShop) {
        [poiSearchService get4SPOIByCity:currentCity.cityId];
    } else {
        [poiSearchService getPOIByType:type City:currentCity.cityId];
    }
}
-(void)searchPlaceByAround
{
    if([TRReachability reachabilityForInternetConnection].currentReachabilityStatus == kNotReachable)
    {
        [self hideLoadingViewAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前的网络尚未打开，请在设置中打开wifi或移动网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString *keyWord = @"";
    if (searchType == EAreaRoundTrafficPolice) {
        [self searchPolicePOI];
        return;
    } else if (searchType == EAreaRoundBank){
        keyWord = @"银行";
    } else if (searchType == EAreaRoundGasStation){
        keyWord = @"加油站";
    } else if (searchType == EAreaRoundParking){
        keyWord = @"停车场";
    } else if (searchType == EAreaRoundWashCar){
        [self searchAutohomePOI];
        return;
    } else if (searchType == EAreaRoundHotel ){
        keyWord = @"酒店";
    }
    else if (searchType == EAreaRoundMeiRong ||  searchType == EAreaRoundZhuangshi || EAreaRound4sShop == searchType
             || searchType == EAreaRoundGaizhuang || searchType == EAreaRoundRepair){
        [self searchAutohomePOI];
        return;
    }
    //        keyWord = @"汽车美容";
    //    } else if (searchType == EAreaRoundZhuangshi){
    //        keyWord = @"汽车装饰";
    //    } else if (searchType == EAreaRoundGaizhuang){
    //        keyWord = @"汽车改装";
    //    } else if (searchType == EAreaRoundRepair){
    //        keyWord = @"汽车修理";
    //    }
#if USE_BaiduMap
    BMKNearbySearchOption *request = [[BMKNearbySearchOption alloc]init];
    request.pageIndex = 0;
    request.pageCapacity = 10;
    request.radius = 10000;
    request.location = userlocation.location.coordinate;
    request.keyword = keyWord;
#else
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:userlocation.location.coordinate.latitude longitude:userlocation.location.coordinate.longitude];
    request.keywords            = keyWord;
    request.page=0;
    request.offset=10;
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = NO;
#endif
    
    [_mapView poiSearchWithRequest:request];
}
-(void)mapView:(WBMapView *)aMapView didUpdateToLocation:(WBUserLocation *)aUserLocation
{
        userlocation = aUserLocation;
        if (currentCity == nil)
        {
            if (EAreaRoundTrafficPolice == searchType || EAreaRound4sShop == searchType || EAreaRoundWashCar == searchType || searchType == EAreaRoundMeiRong ||
                searchType == EAreaRoundZhuangshi || searchType == EAreaRoundGaizhuang || searchType == EAreaRoundRepair)
            {
                CLLocationCoordinate2D pt = userlocation.location.coordinate;
                CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:pt.latitude longitude:pt.longitude];
                [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
                    if (array.count > 0) {
                        CLPlacemark *placemark = [array objectAtIndex:0];
                        NSDictionary *dic = placemark.addressDictionary;
                        NSString *city = [dic objectForKey:@"City"];
                        if (city.length == 0) {
                            city = placemark.administrativeArea;
                        }
                        city = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
                        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                        currentCity = [AreaDBManager getCityByKeyWord:city];
                        [self searchPlaceByAround];
                    } else {
                        [self hideLoadingViewAnimated:YES];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法获取您所在区域的城市信息，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        return;
                    }
                }];

            } else
            {
                [self searchPlaceByAround];
            }
        } else
        {
            [self searchPlaceByAround];
        }
}
-(void)mapView:(WBMapView *)aMapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法获取您目前的位置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)poiSearch:(id)aPoiSearch didFinishedSearchWithResult:(WBPoiResult *)aResults
{
    int count = 1;
    float avgLat = userlocation.location.coordinate.latitude;
    float avglng = userlocation.location.coordinate.longitude;
    float minLat =999999;
    float maxLat = 0;
    float minLng = 999999;
    float maxlng = 0;
    for (WBPoiResultItem *poi in aResults.poiItems) {
        WBPointAnnotation *  annotation=[[WBPointAnnotation alloc] init];
        annotation.title = poi.name;
        annotation.subtitle = poi.address;
        annotation.coordinate = poi.location;
        avgLat += poi.location.latitude;
        avglng += poi.location.longitude;
        if (poi.location.latitude < minLat) {
            minLat = poi.location.latitude;
        }
        if (poi.location.latitude > maxLat) {
            maxLat = poi.location.latitude;
        }
        if (poi.location.longitude < minLng) {
            minLng = poi.location.longitude;
        }
        if (poi.location.longitude > maxlng) {
            maxlng = poi.location.longitude;
        }
        count++;
        [_mapView addAnnotation:annotation];
        
        if ([aResults.poiItems indexOfObject:poi] == 0) {
            [_mapView selectAnnotation:annotation animated:NO];
        }
        
    }
    avgLat = avgLat/count;
    avglng = avglng/count;
    [_mapView setRegion:WBCoordinateRegionMake(CLLocationCoordinate2DMake(avgLat, avglng), WBCoordinateSpanMake(maxLat - minLat, maxlng - minLng)) animated:YES];
}
-(void)poiSearch:(id)aPoiSearch error:(NSString *)errorString
{
    NSLog(@"poi search error:%@",errorString);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询周边服务失败，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
   
}
#pragma mark - annotation delegate
- (void)mapView:(WBMapView *)mapView didSelectAnnotationView:(WBAnnotationView *)view{
    if (selectAnnotation == nil) {
        selectAnnotation = (WBPointAnnotation*)view.annotation;
    } else {
        selectAnnotation = (WBPointAnnotation*)view.annotation;
        [_mapView setCenterCoordinate:selectAnnotation.coordinate animated:YES];
    }
    view.image = TRImage(@"pin.png");
    [self showInfoMsgView];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    view.image = TRImage(@"pin2.png");
    [self hideInfoMsgView];
}

-(id)mapView:(WBMapView *)mapView viewForAnnotation:(id)annotation
{
    //用户位置的图标
    if([annotation isKindOfClass:[WBUserLocation class]])
        return nil;
    
    //自定义大头针
    WBAnnotationView * annotationView=(WBAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if(annotationView==nil)
    {
        annotationView=[[WBAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"];
    }
    annotationView.image=TRImage(@"pin2.png");
    annotationView.canShowCallout= YES;//NO 不显示 弹出图
    return annotationView;


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
