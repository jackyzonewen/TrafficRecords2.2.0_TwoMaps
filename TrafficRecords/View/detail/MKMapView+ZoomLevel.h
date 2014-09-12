//
//  MKMapView+ZoomLevel.h
//  TrafficRecords
//
//  Created by qiao on 13-9-15.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
