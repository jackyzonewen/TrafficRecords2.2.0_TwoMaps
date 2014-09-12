//
//  TRDetailViewController2.h
//  TrafficRecords
//  使用系统自带地图  高德地图数据
//  Created by qiao on 13-11-13.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "TrafficRecord.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ReportLocErrService.h"

@interface TRDetailViewController2 : TRBaseViewController<AMapSearchDelegate, MKMapViewDelegate>{
    MKMapView           *_mapView;
    int                 lenRemoved;
    ReportLocErrService *reportService;
    BOOL                inReporting;
}
@property (nonatomic, strong) TrafficRecord *detailRecord;
@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, strong) AMapSearchAPI *search;

@end
