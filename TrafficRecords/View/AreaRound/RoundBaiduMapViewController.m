//
//  RoundMapViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-7-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "RoundBaiduMapViewController.h"
#import "TRMAAnnotation.h"
#import "PlaceAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationView3.h"
#import "CalloutMapAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "GardLineChooseViewController.h"
#import "TRReachability.h"
#import "BaiduAnnotation.h"

@interface RoundBaiduMapViewController (){
    BaiduAnnotation   *selectAnnotation;
}

@end

@implementation RoundBaiduMapViewController

@synthesize search;
@synthesize searchType;
@synthesize typetitle;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.view removeGestureRecognizer:recognizer];
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, self.view.height - KHeightReduce)];
    } else {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        [_mapView removeFromSuperview];
    }
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
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
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    [self showLoadingAnimated:YES];
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


//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userlocation == nil)
    {
        userlocation = userLocation;
        [_mapView updateLocationData:userLocation];
        if (currentCity == nil)
        {
            if (EAreaRoundTrafficPolice == searchType || EAreaRound4sShop == searchType || EAreaRoundWashCar == searchType || searchType == EAreaRoundMeiRong ||
                searchType == EAreaRoundZhuangshi || searchType == EAreaRoundGaizhuang || searchType == EAreaRoundRepair)
            {
                CLLocationCoordinate2D pt = userlocation.location.coordinate;
                if (geoSearch == nil)
                {
                    geoSearch = [[BMKGeoCodeSearch alloc] init];
                    geoSearch.delegate = self;
                }
                BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
                reverseGeoCodeSearchOption.reverseGeoPoint = pt;
                [geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
            } else
            {
                [self searchPlaceByAround];
            }
        } else
        {
            [self searchPlaceByAround];
        }
    } else
    {
        double dis = ABS(userlocation.location.coordinate.latitude - userLocation.location.coordinate.latitude) +
            ABS(userlocation.location.coordinate.longitude - userLocation.location.coordinate.longitude);
        if (dis > 0.0001)
        {
            userlocation = userLocation;
            [_mapView updateLocationData:userLocation];
        }
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    [self hideLoadingViewAnimated:YES];
    if (hasShow == NO && error.code == kCLErrorDenied) {
        hasShow = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请打开系统设置中“隐私→定位服务”，允许“违章查询助手”使用您的位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (BMK_SEARCH_NO_ERROR == error) {
        NSString *city = result.addressDetail.city;
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        currentCity = [AreaDBManager getCityByKeyWord:city];
        [self searchPlaceByAround];
    } else {
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:userlocation.location.coordinate.latitude longitude:userlocation.location.coordinate.longitude];
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
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
     _mapView.showsUserLocation = YES;
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    

    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _locService = nil;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    self.search.delegate = nil;
    self.search = nil;
    
    geoSearch.delegate = nil;
    geoSearch = nil;
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

//- (void)openBaiduAppToNavi
//{
//    //初始化调启导航时的参数管理类
//    BMKNaviPara* para = [[BMKNaviPara alloc]init];
//    
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    start.pt = userlocation.location.coordinate;
//    //指定终点名称
//    start.cityName = currentCity.name;
//    start.name = @"起点";
//    para.startPoint = start;
//    
//    //指定导航类型
//    para.naviType = BMK_NAVI_TYPE_WEB;
//    
//    //初始化终点节点
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.pt = selectAnnotation.coordinate;
//    //指定终点名称
//    end.cityName = currentCity.name;
//    end.name = selectAnnotation.title;
//    //指定终点
//    para.endPoint = end;
//    
//    //指定返回自定义scheme，具体定义方法请参考常见问题
//    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
//    //调启百度地图客户端导航
//    [BMKNavigation openBaiduMapNavigation:para];
//}


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


#pragma mark -
#pragma mark search POI Methods
-(void) searchAutohomePOI{
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

-(void) searchPolicePOI{
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

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
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
        BaiduAnnotation *min = nil;
        for (NSDictionary *dic in array) {
            BaiduAnnotation *  annotation=[[BaiduAnnotation alloc] init];
            if (searchType == EAreaRound4sShop) {
                annotation.title = [dic objectForKey:@"vendorname"];
                annotation.subtitle = [dic objectForKey:@"address"];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latbaidu"] doubleValue], [[dic objectForKey:@"lngbaidu"] doubleValue]);
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
        BaiduAnnotation *min = nil;
        if (array.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到附近的兴趣点。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        for (NSDictionary *dic in array) {
            BaiduAnnotation *  annotation=[[BaiduAnnotation alloc] init];
            NSLog(@"dict:%@",dic);
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
            annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latbaidu"] doubleValue], [[dic objectForKey:@"lngbaidu"] doubleValue]);
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

- (void)searchPlaceByAround
{
    if([TRReachability reachabilityForInternetConnection].currentReachabilityStatus == kNotReachable){
        [self hideLoadingViewAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前的网络尚未打开，请在设置中打开wifi或移动网络。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (self.search == nil) {
        self.search = [[BMKPoiSearch alloc] init];
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
    
    self.search.delegate = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.radius = 100000;
    option.location = userlocation.location.coordinate;
    option.keyword = keyWord;
    BOOL flag = [search poiSearchNearBy:option];
    if(!flag)
    {
        NSLog(@"周边检索发送失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
//    NSLog(@"%f,%f", _mapView.region.span.latitudeDelta, _mapView.region.span.longitudeDelta);
    [self hideLoadingViewAnimated:YES];
    if (error == BMK_SEARCH_NO_ERROR) {
        int count = 1;
        float avgLat = userlocation.location.coordinate.latitude;
        float avglng = userlocation.location.coordinate.longitude;
        float minLat =999999;
        float maxLat = 0;
        float minLng = 999999;
        float maxlng = 0;
        for (BMKPoiInfo *poi in poiResultList.poiInfoList) {
            BaiduAnnotation *  annotation=[[BaiduAnnotation alloc] init];
            annotation.title = poi.name;
            annotation.subtitle = poi.address;
            annotation.coordinate = poi.pt;
            avgLat += poi.pt.latitude;
            avglng += poi.pt.longitude;
            if (poi.pt.latitude < minLat) {
                minLat =  poi.pt.latitude;
            }
            if (poi.pt.latitude > maxLat) {
                maxLat = poi.pt.latitude;
            }
            if (poi.pt.longitude < minLng) {
                minLng = poi.pt.longitude;
            }
            if (poi.pt.longitude > maxlng) {
                maxlng = poi.pt.longitude;
            }
            count++;
            [_mapView addAnnotation:annotation];
            
            if ([poiResultList.poiInfoList indexOfObject:poi] == 0) {
                [_mapView selectAnnotation:annotation animated:NO];
            }
            
        }
        avgLat = avgLat/count;
        avglng = avglng/count;
        [_mapView setRegion:BMKCoordinateRegionMake(CLLocationCoordinate2DMake(avgLat, avglng), BMKCoordinateSpanMake(maxLat - minLat, maxlng - minLng)) animated:YES];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"起始点有歧义" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(BMK_SEARCH_RESULT_NOT_FOUND == error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到附近的兴趣点。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询周边服务失败，请稍后重试。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if (selectAnnotation == nil) {
        selectAnnotation = (BaiduAnnotation*)view.annotation;
    } else {
        selectAnnotation = (BaiduAnnotation*)view.annotation;
        [_mapView setCenterCoordinate:selectAnnotation.coordinate animated:YES];
    }
    view.image = TRImage(@"pin.png");
    [self showInfoMsgView];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    view.image = TRImage(@"pin2.png");
    [self hideInfoMsgView];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"BaiduCustomAnnotation"];
    if (annotationView == nil) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BaiduCustomAnnotation"];
        annotationView.image = [UIImage imageNamed:@"pin2.png"];
        CallOutAnnotationView3 *custom = [[CallOutAnnotationView3 alloc] initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:@"CalloutView2"];
        [custom setTitle:annotation.title Address:annotation.subtitle];
        if (custom.height > 90) {
            annotationView.calloutOffset = CGPointMake(0, -8);
        } else {
            annotationView.calloutOffset = CGPointMake(0, -10);
        }
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:custom];
    }
    return annotationView;
}
@end
