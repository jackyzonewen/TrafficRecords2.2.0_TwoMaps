//
//  LuKuangViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-2-26.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "LuKuangViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "AreaDBManager.h"
#import "JSON.h"
#import "TRReachability.h"

@interface LuKuangViewController ()

@end

@implementation LuKuangViewController

//@synthesize search;
@synthesize cityArray;

-(NSString *) naviTitle{
    return @"实时路况";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)naviRightIcon{
    return @"refresh.png";
}

-(void) naviRightClick:(id)sender{
    if([TRReachability reachabilityForInternetConnection].currentReachabilityStatus == kNotReachable)
    {
        UIAlertView *globAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前的网络尚未打开，请在设置中打开wifi或移动网络。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [globAlertView show];
        return;
        
    }

    mapView.showsTraffic = NO;
    [mapView performSelector:@selector(setShowsTraffic:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.4];

    if (inLoading == NO) {
        inLoading = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *url = [NSString stringWithFormat:@"%@ashx/getroaderror.ashx?version=%@&platform=%@", KServerHost, [TRUtility clientVersion], KIOSPlatformId];
            NSString *content = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding: NSUTF8StringEncoding error:nil];
            NSDictionary *dic = [content JSONValue];
            if (dic && [[dic objectForKey:@"returncode"] intValue] == 0) {
                NSString *str = [dic objectForKey:@"message"];
                if (str.length > 0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showInfoView:str];
                    });
                }
            }
            inLoading = NO;
        });
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view removeGestureRecognizer:recognizer];
#if USE_BaiduMap
    mapView = [[WBBaiduMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mapView.mapType=kWBMapTypeStandard_baidu;
#else
    mapView = [[WBGaodeMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mapView.mapType=kWBMapTypeStandard_gaode;
#endif
    mapView.delegate=self;
    mapView.showsTraffic=YES;
    mapView.showsUserLocation = YES;
    mapView.showsScaleBar= NO;
    [self.view addSubview:mapView];
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    mapView.showsCompass = NO;
    
    UIImage *image = TRImage(@"roundLK.png");
    UIButton *round = [UIButton buttonWithType:UIButtonTypeCustom];
    [round setBackgroundImage:image forState:UIControlStateNormal];
    [round setTitle:@"周边路况" forState:UIControlStateNormal];
    round.frame = CGRectMake(15, mapView.height - 20 - image.size.height, image.size.width, image.size.height);
    [round addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:round];
    
    image = TRImage(@"reduceZoom.png");
    UIButton *reduce = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduce setBackgroundImage:image forState:UIControlStateNormal];
    reduce.frame = CGRectMake(mapView.width - 15 - image.size.width, mapView.height - 20 - image.size.height, image.size.width, image.size.height);
    [reduce addTarget:self action:@selector(btnClick3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduce];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setBackgroundImage:TRImage(@"addZoom.png") forState:UIControlStateNormal];
    add.frame = CGRectMake(reduce.left, reduce.top - 20 - image.size.height, image.size.width, image.size.height);
    [add addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    
    [self upDateViewState];
    [super viewWillAppear:animated];
}

//
-(void) btnClick:(UIButton *) sender{
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"周边路况"]) {
        [MobClick event:@"round_lukuang_click"];
    } else {
        [MobClick event:@"allcity_lukuang_click"];
    }
    if (locationState == -1) {
        [self showInfoView:@"正在定位中，请稍候再试"];
        return;
    } else if(locationState == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请打开系统设置中“隐私→定位服务”，允许“违章查询助手”使用您的位置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([title isEqualToString:@"周边路况"]) {
        [sender setTitle:@"全城路况" forState:UIControlStateNormal];
       
        [mapView setCenterCoordinate: mapView.userLocation.location.coordinate animated:NO];
         [mapView setZoomLevel:16];
        
    } else {
        [sender setTitle:@"周边路况" forState:UIControlStateNormal];
      
        [mapView setCenterCoordinate:currentCity.centerCoord animated:NO];
          [mapView setZoomLevel:currentCity.zoomLevel];
    }
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [mapView tearDown];
}
-(void) btnClick2:(UIButton *) sender{
    float zoom = mapView.zoomLevel;
    zoom ++;
    [mapView setZoomLevel:zoom];
}

-(void) btnClick3:(UIButton *) sender{
    float zoom = mapView.zoomLevel;
    zoom --;
    [mapView setZoomLevel:zoom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationState = -1;
    [self startLocaltion];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)getNotSupportView{
    UILabel *notSupportView = (UILabel *)[self.view viewWithTag:1001];
    if (notSupportView == nil) {
        notSupportView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mapView.width, 44)];
        notSupportView.backgroundColor = [TRSkinManager colorWithInt:0x77000000];
        notSupportView.textColor = [UIColor whiteColor];
        notSupportView.font = [TRSkinManager mediumFont3];
        notSupportView.textAlignment = NSTextAlignmentCenter;
        notSupportView.userInteractionEnabled = YES;
        [self.view addSubview:notSupportView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = notSupportView.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClick4:) forControlEvents:UIControlEventTouchUpInside];
        [notSupportView addSubview:btn];
        notSupportView.tag = 1001;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback1:)];
//        [notSupportView addGestureRecognizer:tap];

    }
    return notSupportView;
}

-(void)btnClick4:(UIButton *)sender{
    __block UILabel *label = [self getNotSupportView];
    [UIView animateWithDuration:0.2 animations:^{
        [label setTop:-label.height];
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        label = nil;
    }];
}

//更新UI显示
-(void) upDateViewState{
    //-1未定位,0定位失败，1定位成功且城市支持，2定位成功但不支持城市
    BOOL support = NO;
    NSString *text = nil;
    if (currentCity.centerCoord.latitude > 0 && currentCity.centerCoord.longitude > 0) {
        [mapView setCenterCoordinate:currentCity.centerCoord animated:NO];
        [mapView setZoomLevel:currentCity.zoomLevel];
    }
    support = currentCity.supportLuKuang;
    text = [NSString stringWithFormat:@"抱歉，暂不支持%@的实时路况",currentCity.name];
    UILabel *label = [self getNotSupportView];
    if (support) {
        label.hidden = YES;
    } else {
        label.hidden = NO;
        label.text = text;
    }
}

#pragma mark -
#pragma mark CLLocationManager代理
- (void)startLocaltion
{
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    [locationMgr startUpdatingLocation];
    
}
-(void)mapView:(WBMapView *)aMapView didUpdateToLocation:(BMKUserLocation *)aUserLocation
{
    [mapView stopLocate];
    NSLog(@"location update");
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [locationMgr stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;

    if (geoCoder == nil)
    {
        geoCoder = [[CLGeocoder alloc] init];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
    {
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSDictionary *dic = placemark.addressDictionary;
            NSString *city = [dic objectForKey:@"City"];
            if (city.length == 0) {
                city = placemark.administrativeArea;
            }
            city = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            City * cityM = [AreaDBManager getCityByKeyWord:city];
            if (cityM) {
                currentCity = [LuKuangCity getLuKuangCityById:cityM.cityId];
                if (currentCity.supportLuKuang == NO) {
                    //存储定位到的经纬度
                    currentCity.centerCoord = coordinate;
                    locationState = 2;
                    
                } else {
                    //存储当前城市的经纬度
                    locationState = 1;
                }
                currentCity.zoomLevel = USE_BaiduMap?12:11;
                //将定位的城市作为上次访问的城市进行存储
                NSString *text = [currentCity toJsonString];
                [[NSUserDefaults standardUserDefaults] setObject:text forKey:KLuKuangCityInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self upDateViewState];
            } else {
                [self handleLocationFailed];
            }
        }
        else
        {
            NSLog(@"degeocode faild!");
            //优先取上次打开路况信息的城市，没有的话选择首页选取的城市
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KLuKuangCityInfo];
            if (text.length > 0) {
                currentCity = [[LuKuangCity alloc] initWithJsonStr:text];
            }
            if (currentCity == nil) {
                //首次打开路况，选取首页的城市
                NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
                //如果首页也未选取城市，则默认为北京
                if (cityId <= 0) {
                    currentCity = [LuKuangCity getLuKuangCityByKeyWord:@"北京"];
                } else {
                    currentCity = [LuKuangCity getLuKuangCityById: cityId];
                }
            }
            //如果上次的城市经纬度为0，表示首次进入路况界面，且该城市不支持，需要用高德去检索经纬度
            if (currentCity.centerCoord.latitude <= 0 || currentCity.centerCoord.longitude <= 0) {
                [self startSearchCity:currentCity.name];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self handleLocationFailed];
}

- (void)handleLocationFailed{
    locationState = 0;
    [self upDateViewState];
}



//#pragma mark -
//#pragma mark MASearchDelegate Methods

- (void)startSearchCity:(NSString *) cityName
{
#if USE_BaiduMap
    //百度的
    BMKNearbySearchOption *poiRequest = [[BMKNearbySearchOption alloc]init];
    poiRequest.pageIndex = 0;
    poiRequest.pageCapacity = 10;
    //poiRequest.radius = 3000;
    poiRequest.keyword = cityName;
    
#else
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = cityName;
    poiRequest.requireExtension = YES;
   
#endif
    [mapView poiSearchWithRequest: poiRequest];
}
-(void)poiSearch:(id)aPoiSearch didFinishedSearchWithResult:(WBPoiResult *)aResults
{
    NSArray* poiArray = [aResults poiItems];
    for(int i=0;i<poiArray.count;i++)
    {
        WBPoiResultItem* poi = [poiArray objectAtIndex:i];
        if (i == 0 )
        {
            currentCity.centerCoord = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            currentCity.zoomLevel = USE_BaiduMap?12:11;
            currentCity.supportLuKuang = NO;//只有不支持的城市才需要search
            NSString *text = [currentCity toJsonString];
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:KLuKuangCityInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self upDateViewState];
            break;
        }
    }
}
-(void)poiSearch:(id)aPoiSearch error:(NSString *)errorString
{
    NSLog(@"city search error:%@",errorString);
}
@end
