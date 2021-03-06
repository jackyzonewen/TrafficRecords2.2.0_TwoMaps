//
//  LuKuangViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-2-26.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//
#include "TRBaseViewController.h"
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "LuKuangCity.h"
#import "BMapKit.h"
#import <AMapSearchKit/AMapSearchAPI.h>

#if USE_BaiduMap
#import "WBBaiduMapView.h"
#else
#import "WBGaodeMapView.h"
#endif

@interface LuKuangViewController   : TRBaseViewController<CLLocationManagerDelegate, AMapSearchDelegate,WBMapViewDelegate>
{


    WBMapView              *mapView;

    LuKuangCity            *lastCity;
    LuKuangCity            *currentCity;
    
    CLGeocoder  *geoCoder;
    CLLocationManager *locationMgr;
    int                     locationState;//-1未定位,0定位失败，1定位成功且城市支持，2定位成功但不支持城市
    BOOL                    inLoading;
}

//@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray *cityArray;

@end
