//
//  WBMapView.h
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMapViewTypes.h"
#import "WBPoiResult.h"
#import "WBPoiResultItem.h"


typedef NS_ENUM(NSUInteger,WBMapType)
{
    //百度
    kWBMapTypeStandard_baidu=1<<0,
    kWBMapTypeTrafficOn_baidu=1<<1,
    kWBMapTypeSatellite_baidu=1<<2,
    kWBMapTypeTrafficAndSatellite_baidu=1<<3,
    //高德
    kWBMapTypeStandard_gaode=0,
    kWBMapTypeSatellite_gaode=1<<0,
    kWBMapTypeStandardNight_gaode=1<<1
    
};

@class WBMapView;
//WBMapView protocol
@protocol WBMapViewDelegate <NSObject>
//POI
-(void)poiSearch:(id)aPoiSearch error:(NSString*)errorString;
-(void)poiSearch:(id)aPoiSearch didFinishedSearchWithResult:(WBPoiResult*)aResults;
//annotation
-(id)mapView:(WBMapView *)mapView viewForAnnotation:(id)annotation;
- (void)mapView:(WBMapView *)mapView didSelectAnnotationView:(WBAnnotationView *)view;
- (void)mapView:(WBMapView *)mapView didDeselectAnnotationView:(WBAnnotationView *)view;
//location
-(void)mapView:(WBMapView*)aMapView didUpdateToLocation:(WBUserLocation*)aUserLocation;
-(void)mapView:(WBMapView*)aMapView didFailToLocateUserWithError:(NSError *)error;

@end




@interface WBMapView : UIView
@property(nonatomic,strong)  WBMapView* mapView;
@property(nonatomic,strong)  WBPoiSearcher* poiSearcher;
@property(nonatomic,weak) id<WBMapViewDelegate> delegate;
@property(nonatomic) WBMapType mapType;
@property(nonatomic) BOOL showsUserLocation,showsTraffic,showsCompass,showsScaleBar;
@property(nonatomic) CGFloat zoomLevel;
@property(nonatomic,readonly) CGFloat minZoomLevel,maxZoomLevel;
@property(nonatomic,getter = isScrollEnabled) BOOL scrollEnabled;
@property(nonatomic,getter = isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;
@property(nonatomic,strong,readonly) WBUserLocation* userLocation;
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)ani;
-(WBCoordinateRegion)region;
-(void)setRegion:(WBCoordinateRegion)aRegion animated:(BOOL)isAnimated;

-(void)tearDown;//避免循环引用

//POI
-(void)poiSearchWithRequest:(id)aRequest;
//annotation
-(id)dequeueReusableAnnotationViewWithIdentifier:(NSString*)aID;
-(NSArray*)annotations;
-(void)addAnnotation:(id)aAnnotation;
-(void)removeAnnotation:(id)aAnnotation;
- (void)addAnnotations:(NSArray *)annotations;
- (void)removeAnnotations:(NSArray *)annotations;
- (void)selectAnnotation:(id)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(id)annotation animated:(BOOL)animated;
//location
-(void)startLocate;
-(void)stopLocate;
@end
