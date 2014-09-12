//
//  ManuaLocationViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-3-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import <MapKit/MapKit.h>

@protocol ManuaLocationViewControllerDelegate <NSObject>

-(void) locationBeLocated:(CLLocationCoordinate2D) locatedPos;

@end

@interface ManuaLocationViewController : TRBaseViewController<MKMapViewDelegate>
{
    MKMapView           *_mapView;
    MKPointAnnotation *locationPoint;
    CGPoint             lastPoint;
}

@property (nonatomic,assign) CLLocationCoordinate2D center;
@property (nonatomic, weak) id<ManuaLocationViewControllerDelegate>     delegate;

@end
