//
//  RoundBaiduMapViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-7-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"
#import "POISearchService.h"
#import "AreaDBManager.h"
#import "GetOfficeInfoService.h"

static City *currentCity = nil;

@interface RoundBaiduMapViewController : TRBaseViewController<BMKPoiSearchDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, UIActionSheetDelegate, BMKGeoCodeSearchDelegate>{
    BMKMapView              *_mapView;
    BMKUserLocation         *userlocation;
    UIView                  *infoView;
    
    BMKLocationService      *_locService;
    POISearchService        *poiSearchService;
    BMKGeoCodeSearch        *geoSearch;
    
    GetOfficeInfoService    *service;
    BOOL                     hasShow;
}

@property (nonatomic, strong) BMKPoiSearch             *search;
@property (nonatomic, assign) EAreaRoundSearchType      searchType;
@property (nonatomic, strong) NSString                  *typetitle;
@end
