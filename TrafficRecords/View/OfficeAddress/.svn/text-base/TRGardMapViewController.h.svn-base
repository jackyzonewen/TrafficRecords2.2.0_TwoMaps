//
//  TRGardMapViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-3-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "NSOfficInfo.h"
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface TRGardMapViewController : TRBaseViewController<AMapSearchDelegate, MKMapViewDelegate>
{
    MKMapView           *_mapView;
    int                 lenRemoved;
}

@property(nonatomic, strong)NSOfficInfo *officeInfo;
@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, strong)AMapSearchAPI *search;

@end
