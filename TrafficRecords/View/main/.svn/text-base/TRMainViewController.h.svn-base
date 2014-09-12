//
//  TRViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-8-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRefreshViewController.h"
#import "DAContextMenuCell.h"
#import "CityViewController.h"
#import "WeatherModule.h"
#import "QueryTrafRecordService.h"
#import "UrlImageView.h"
#import "FMMoveTableView.h"

@class WeatherService;
@class TRNotifyView;
@class ADBannerView;

@interface TRMainViewController : TRRefreshViewController<UITableViewDataSource, UITableViewDelegate, AreaDelegate, CLLocationManagerDelegate, FMMoveTableViewDataSource, FMMoveTableViewDelegate>
{
    WeatherModule            *weatherModule;
    WeatherService           *service;
    BOOL                      weatherLoaded;
    QueryTrafRecordService   *recordService;
    BOOL                      recordLoaded;
    BOOL                      donotLoadRecord;
    BOOL                      fromPush;
    BOOL                       visable;
    NSMutableDictionary       *hiddenDic;
    UILabel                   *noDataLabel;
    TRNotifyView              *notifyView;
    City                      *currentCity;
    
    
    CLGeocoder  *geoCoder;
    CLLocationManager *locationMgr;
    UrlImageView               *bannerView;
    int                         itemCount;
    ADBannerView               *adBanner;
}

@property (nonatomic, strong)FMMoveTableView *myTableView;

@end
