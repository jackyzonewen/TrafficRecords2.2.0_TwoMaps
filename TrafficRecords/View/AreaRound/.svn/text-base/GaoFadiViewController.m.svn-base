//
//  GaoFadiViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-8-11.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GaoFadiViewController.h"
#import "TRPercentView.h"
#import "GaoFaDiAnnotation.h"
#import <MapKit/MapKit.h>
#import "CallOutAnnotationView3.h"
#import "GaofadiItemView.h"
#import "UMSocial.h"

@interface GaoFadiViewController (){
    GaoFaDiAnnotation   *selectAnnotation;
}

@end

@implementation GaoFadiViewController


-(NSString *) naviTitle{
    return @"违章高发地";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) naviRightIcon{
    return @"share.png";
}

- (void) naviRightClick:(id) sender{

    NSString *url = [NSString stringWithFormat:@"http://wz.qichecdn.com/ashx/weixinshare.ashx?lat=%lf&lng=%lf",
                     userlocation.location.coordinate.latitude, userlocation.location.coordinate.longitude];
    NSString *title = @"违章查询助手";
    NSString *shareText = @"#违章查询助手#向罚单say bye。附近违章高发地图带您轻松驾车，远离违章。";
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:KUMengAppKey
                                      shareText:shareText
                                     shareImage:TRImage(@"icon.png")
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina]
                                       delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if ([UMShareToSina isEqualToString:platformName]) {
        [MobClick event:@"gaofadi_share_wb"];
        UIImage *mapImg = [_mapView takeSnapshot];
        if (infoView.top < _mapView.bottom) {
            UIImage *image = [TRUtility imageOfView:infoView];
            mapImg = [TRUtility addImage:image toImage:mapImg atPos:CGPointMake(0, mapImg.size.height - image.size.height)];
        }
        socialData.shareImage = mapImg;
        NSString *url = [TRAppDelegate appDelegate].appInfo.updateUrl;
        if (url.length == 0) {
            url = @"https://itunes.apple.com/us/app/wei-zhang-cha-xun-zhu-shou/id708985992?ls=1&mt=8";
        }
        socialData.title = @"违章查询助手";
        socialData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
        NSString *text = [NSString stringWithFormat:@"#违章查询助手#向罚单say bye。附近违章高发地图带您轻松驾车，远离违章。%@", url];
        socialData.shareText = text;
    } else if ([UMShareToWechatSession isEqualToString:platformName]){
        [MobClick event:@"gaofadi_share_wx"];
    } else if ([UMShareToWechatTimeline isEqualToString:platformName]){
        [MobClick event:@"gaofadi_share_wxline"];
    } else if ([UMShareToQzone isEqualToString:platformName]){
        [MobClick event:@"gaofadi_share_qq"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view removeGestureRecognizer:recognizer];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, self.view.height - KHeightReduce)];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UIImage *image = TRImage(@"userLocation.png");
    locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setBackgroundImage:image forState:UIControlStateNormal];
    [locationBtn setBackgroundImage:TRImage(@"userLocationHL.png") forState:UIControlStateHighlighted];
    locationBtn.frame = CGRectMake(15, _mapView.bottom  - 20  - image.size.height, image.size.width, image.size.height);
    [locationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.hidden = YES;
    [self.view addSubview:locationBtn];
}

-(void) btnClick:(UIButton *) btn{
    if (userlocation) {
        [_mapView setCenterCoordinate:userlocation.location.coordinate animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
    }
    [_locService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _locService = nil;
}



#pragma mark -
#pragma mark User Location Methods
//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    locationBtn.hidden = NO;
    if (userlocation == nil) {
        userlocation = userLocation;
        [_mapView updateLocationData:userLocation];
        
        if (searchService == nil) {
            searchService = [[GaoFaDiService alloc] init];
            searchService.delegate = self;
        }
        [self showLoadingAnimated:YES];
        [searchService GaofadiAtlat:userlocation.location.coordinate.latitude lng:userlocation.location.coordinate.longitude];
    }else {
        double dis = ABS(userlocation.location.coordinate.latitude - userLocation.location.coordinate.latitude) +
        ABS(userlocation.location.coordinate.longitude - userLocation.location.coordinate.longitude);
        if (dis > 0.0001) {
            userlocation = userLocation;
            [_mapView updateLocationData:userLocation];
        }
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        if (hasShow == NO) {
            hasShow = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请打开系统设置中“隐私→定位服务”，允许“违章查询助手”使用您的位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark -
#pragma mark Http Delegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    if (tag == EServiceGaofadi) {
        if (searchService.points.count > 0) {
            float avgLat = userlocation.location.coordinate.latitude;
            float avglng = userlocation.location.coordinate.longitude;
            float minLat =999999;
            float maxLat = 0;
            float minLng = 999999;
            float maxlng = 0;
            int count = 1;
            GaoFaDiAnnotation *maxannotation = nil;
            for (NSDictionary * dic in searchService.points) {
                GaoFaDiAnnotation *annotation = [[GaoFaDiAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] doubleValue], [[dic objectForKey:@"lng"] doubleValue]);
                annotation.title = [dic objectForKey:@"location"];
                annotation.isHigh = [[dic objectForKey:@"high"] integerValue];
                annotation.subtitle = @"违章次数";
                annotation.location = [dic objectForKey:@"location"];
                annotation.wz_count = [[dic objectForKey:@"wz_count"] intValue];
                if (annotation.wz_count > maxannotation.wz_count) {
                    maxannotation = annotation;
                }
                annotation.contents = [dic objectForKey:@"contents"];
                [_mapView addAnnotation:annotation];
                
                if (count <= 6) {
                    avgLat += annotation.coordinate.latitude;
                    avglng += annotation.coordinate.longitude;
                    if (annotation.coordinate.latitude < minLat) {
                        minLat = annotation.coordinate.latitude;
                    }
                    if (annotation.coordinate.latitude > maxLat) {
                        maxLat = annotation.coordinate.latitude;
                    }
                    if (annotation.coordinate.longitude < minLng) {
                        minLng = annotation.coordinate.longitude;
                    }
                    if (annotation.coordinate.longitude > maxlng) {
                        maxlng = annotation.coordinate.longitude;
                    }
                    count++;
                }
            }
            avgLat = avgLat/count;
            avglng = avglng/count;
            [_mapView setRegion:BMKCoordinateRegionMake(CLLocationCoordinate2DMake(avgLat, avglng), BMKCoordinateSpanMake(maxLat - minLat, maxlng - minLng)) animated:NO];
            //        if (maxannotation) {
            //            [_mapView selectAnnotation:maxannotation animated:NO];
            //        }
        } else {
            [self showInfoView:@"恭喜您，方圆两公里内属于违章低发地段，请您放心、安全驾驶。"];
        }
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
}

#pragma mark -
#pragma mark BMKAnnotationView Methods
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    BOOL changed = NO;
    if (selectAnnotation != view.annotation) {
        changed = YES;
    }
    if (selectAnnotation == nil) {
        selectAnnotation = (GaoFaDiAnnotation*)view.annotation;
    } else {
        selectAnnotation = (GaoFaDiAnnotation*)view.annotation;
    }
    [_mapView setCenterCoordinate:selectAnnotation.coordinate animated:YES];
    [self showInfoMsgView:changed];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    [self hideInfoMsgView];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    BMKAnnotationView *annotationView  = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BaiduCustomAnnotation"];
        GaoFaDiAnnotation *gaofadi = annotation;
        CallOutAnnotationView3 *custom = [[CallOutAnnotationView3 alloc] initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:@"CalloutView2"];
        [custom setTitle:annotation.title Address:annotation.subtitle];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(custom.addresslabel.right + 2, custom.addresslabel.top, 40, custom.addresslabel.height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%d", gaofadi.wz_count];
        label.numberOfLines = 0;
        label.textColor = [self naviColor];
        label.font = [UIFont systemFontOfSize:14];
        [custom addSubview:label];
        
        
        if (gaofadi.isHigh) {
            annotationView.image = [UIImage imageNamed:@"pin3.png"];
        } else {
            annotationView.image = [UIImage imageNamed:@"pin4.png"];
        }
        if (custom.height > 90) {
            annotationView.calloutOffset = CGPointMake(0, -8);
        } else {
            annotationView.calloutOffset = CGPointMake(0, -10);
        }
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:custom];
    return annotationView;
}


#pragma mark -
#pragma mark infoView Methods
-(void) showInfoMsgView:(BOOL) changed{
    float maxH = 192;
    if (infoView == nil) {
        infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - maxH, self.view.width, maxH)];
        infoView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:infoView];
        UIImage *shadow = TRImage(@"shadow.png");
        shadow = [TRUtility image:shadow rotation:UIImageOrientationDown];
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, infoView.width, 2)];
        shadowView.image = shadow;
        [infoView addSubview:shadowView];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, shadowView.height, infoView.width, infoView.height - shadowView.height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [infoView addSubview:scrollView];
        scrollView.tag = 211;
    }
    if (changed) {
        UIScrollView *scrollView = (UIScrollView *)[infoView viewWithTag:211];
        for (UIView *view in scrollView.subviews) {
            [view removeFromSuperview];
        }
        float contentH = 0;
        for (NSDictionary *dic in selectAnnotation.contents) {
            float percent = ((float)[[dic objectForKey:@"proportion"] integerValue] )/ 100.0;
            GaofadiItemView *itemView = [[GaofadiItemView alloc] initWithDic:dic];
            [itemView setTop:contentH];
            [scrollView addSubview:itemView];
            [itemView setPercent:percent];
            if (percent < 0.5) {
                [itemView PercentView].bgColor = [TRSkinManager colorWithInt:0xf09609];
            }
            contentH += itemView.height;
        }
        contentH+=20;
        [scrollView setContentSize:CGSizeMake(scrollView.width, contentH)];
        if(contentH < 190){
            [infoView setHeight:contentH + 2];
            [scrollView setHeight:contentH];
        }else {
            [infoView setHeight:192];
            [scrollView setHeight:190];
        }
        scrollView.contentOffset= CGPointMake(0, 0);
    }
    [UIView animateWithDuration:0.2 animations:^{
        infoView.frame = CGRectMake(0, self.view.height - infoView.height, self.view.width, infoView.height);
    }];
    [locationBtn setTop:infoView.top - 20 - locationBtn.height];
}

-(void) hideInfoMsgView{
    [UIView animateWithDuration:0.2 animations:^{
        infoView.frame = CGRectMake(0, self.view.height, self.view.width, infoView.height);
    }];
    [locationBtn setTop:infoView.top - 20 - locationBtn.height];
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
@end
