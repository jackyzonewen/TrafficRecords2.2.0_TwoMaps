//
//  WBMapView.m
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "WBMapView.h"

@implementation WBMapView
@synthesize mapView;
@synthesize poiSearcher;
@synthesize delegate;
@synthesize mapType;
@synthesize showsUserLocation,showsTraffic,showsCompass,showsScaleBar;
@synthesize zoomLevel,minZoomLevel,maxZoomLevel;
@synthesize centerCoordinate;
@synthesize userLocation;
@synthesize scrollEnabled,zoomEnabled;
-(void)dealloc
{
    NSLog(@"%s:",__func__);
}
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)ani
{
    
}
-(WBCoordinateRegion)region
{
    return WBCoordinateRegionMake(((CLLocationCoordinate2D){0,0}),((WBCoordinateSpan){0,0}));
}
-(void)setRegion:(WBCoordinateRegion)aRegion animated:(BOOL)isAnimated
{
    
}
-(void)poiSearchWithRequest:(id)aRequest
{
    
}
-(NSArray*)annotations
{
    return nil;
}
-(void)addAnnotation:(id)aAnnotation
{
    
}
-(void)removeAnnotation:(id)aAnnotation
{
    
}
- (void)addAnnotations:(NSArray *)annotations
{
    
}
- (void)removeAnnotations:(NSArray *)annotations
{
    
}
- (void)selectAnnotation:(id)annotation animated:(BOOL)animated
{
    
}
- (void)deselectAnnotation:(id)annotation animated:(BOOL)animated
{
    
}
-(id)dequeueReusableAnnotationViewWithIdentifier:(NSString *)aID
{
    return nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)startLocate
{
    
}
-(void)stopLocate
{
    
}
-(void)tearDown
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
