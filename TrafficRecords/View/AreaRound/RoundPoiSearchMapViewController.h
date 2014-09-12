//
//  RoundPoiSearchMapViewController.h
//  TrafficRecords
//
//  Created by Peter on 14-9-10.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "AreaDBManager.h"
#import "TRReachability.h"
#import "POISearchService.h"
#import "GetOfficeInfoService.h"
#import <MapKit/MKMapItem.h>
#if USE_BaiduMap
#import "WBBaiduMapView.h"
#else
#import "WBGaodeMapView.h"
#endif

static City *currentCity = nil;
@interface RoundPoiSearchMapViewController : TRBaseViewController<WBMapViewDelegate,UIActionSheetDelegate>
@property (nonatomic, assign) EAreaRoundSearchType      searchType;
@property (nonatomic, strong) NSString                  *typetitle;
@end
