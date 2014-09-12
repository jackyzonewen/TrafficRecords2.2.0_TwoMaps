//
//  TRDetailViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-13.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "TrafficRecord.h"
#import "BMapKit.h"

@interface TRDetailViewController : TRBaseViewController<BMKMapViewDelegate, BMKSearchDelegate>{
    BMKMapView           *mapView;
    BMKSearch            *search; 
    int                 lenRemoved;
}

@property (nonatomic, strong) TrafficRecord *detailRecord;
@property (nonatomic, assign) CLLocationCoordinate2D center;

@end
