//
//  WBBaiduMapView.m
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "WBBaiduMapView.h"

@implementation WBBaiduMapView
{
    BMKMapView* mapView;
    BMKPoiSearch* poiSearcher;
    BMKLocationService* locationManager;
    CLLocationCoordinate2D lastCoordinate;
}

-(void)tearDown
{
    [mapView viewWillDisappear];
    mapView.showsUserLocation=NO;
    mapView.mapType=BMKMapTypeStandard;
    self.delegate=nil;
    mapView.delegate=nil;
    poiSearcher.delegate=nil;
    self.mapView=nil;
    self.poiSearcher=nil;
}
-(void)configWith:(CGRect)aFrame
{
    mapView=[[BMKMapView alloc] initWithFrame:aFrame];
    mapView.delegate=self;
    [self insertSubview:mapView atIndex:0];
    [mapView viewWillAppear];
    poiSearcher=[[BMKPoiSearch alloc] init];
    poiSearcher.delegate=self;
    mapView.showsUserLocation=YES;
    lastCoordinate=CLLocationCoordinate2DMake(0.0, 0.0);
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configWith:frame];
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self configWith:self.frame];
    }
    return self;
}
-(WBMapType)mapType
{
    return mapView.mapType;
}
-(void)setMapType:(WBMapType)mapType
{
    mapView.mapType=mapType;
}
-(BOOL)showsUserLocation
{
    return mapView.showsUserLocation;
}
-(void)setShowsUserLocation:(BOOL)showsUserLocation
{
    mapView.showsUserLocation=showsUserLocation;
    if(!locationManager)
    {
        locationManager=[[BMKLocationService alloc] init];
        locationManager.delegate=self;
    }
    if(showsUserLocation)
        [locationManager startUserLocationService];
    else
        [locationManager stopUserLocationService];
}
-(BOOL)showsCompass
{
    return CGRectContainsPoint(mapView.frame, mapView.compassPosition);
}
-(void)setShowsCompass:(BOOL)showsCompass
{
    mapView.compassPosition=showsCompass?CGPointMake(40, 100):CGPointMake(-100, -100);
}
-(BOOL)showsScaleBar
{
    return mapView.showMapScaleBar;
}
-(void)setShowsScaleBar:(BOOL)showsScaleBar
{
    mapView.showMapScaleBar=showsScaleBar;
}
-(BOOL)isZoomEnabled
{
    return mapView.zoomEnabled;
}
-(void)setZoomEnabled:(BOOL)zoomEnabled
{
    mapView.zoomEnabled=zoomEnabled;
}
-(BOOL)isScrollEnabled
{
    return mapView.isScrollEnabled;
}
-(CGFloat)zoomLevel
{
    return mapView.zoomLevel;
}
-(void)setZoomLevel:(CGFloat)zoomLevel
{
    mapView.zoomLevel=zoomLevel;
}
-(CGFloat)minZoomLevel
{
    return mapView.minZoomLevel;
}
-(CGFloat)maxZoomLevel
{
    return mapView.maxZoomLevel;
}
-(CLLocationCoordinate2D)centerCoordinate
{
    return mapView.centerCoordinate;
}
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
{
    mapView.centerCoordinate=centerCoordinate;
}
-(WBUserLocation*)userLocation
{
    return (WBUserLocation*)locationManager.userLocation;
}
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)ani
{
    [mapView setCenterCoordinate:centerCoordinate animated:ani];
}
-(WBCoordinateRegion)region
{
    return coordinateRegionConvertToLocalFromBaidu(mapView.region);
}
-(void)setRegion:(WBCoordinateRegion)aRegion animated:(BOOL)isAnimated
{
    [mapView setRegion:coordinateRegionConvertToBaidu(aRegion) animated:isAnimated];
}
-(BOOL)showsTraffic
{
    return ((mapView.mapType==BMKMapTypeTrafficOn)||(mapView.mapType==BMKMapTypeTrafficAndSatellite))?YES:NO;
}
-(void)setShowsTraffic:(BOOL)showsTraffic
{
    if(mapView.mapType==BMKMapTypeStandard||mapView.mapType==BMKMapTypeTrafficOn)
    {
        mapView.mapType=showsTraffic?BMKMapTypeTrafficOn:BMKMapTypeStandard;
    }
    else
    {
         mapView.mapType=showsTraffic?BMKMapTypeTrafficAndSatellite:BMKMapTypeSatellite;
    }
}
#pragma mark - POI search
-(void)poiSearchWithRequest:(id)aRequest
{
    [poiSearcher poiSearchNearBy:(BMKNearbySearchOption*)aRequest];
}
#pragma mark - POI search delegate
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{

    if(errorCode)
    {
        if([self.delegate respondsToSelector:@selector(poiSearch:error:)])
            [self.delegate poiSearch:searcher error:ERROR_STRING(errorCode)];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(poiSearch:didFinishedSearchWithResult:)])
            [self.delegate poiSearch:searcher didFinishedSearchWithResult:[self convertToWBPoiResultWith:poiResult]];
    }
}
-(WBPoiResult*)convertToWBPoiResultWith:(BMKPoiResult*)poiResult
{
    WBPoiResult * result=[[WBPoiResult alloc] init];
    NSMutableArray * poiItems=[[NSMutableArray alloc] init];
    for(BMKPoiInfo * info in [poiResult poiInfoList])
    {
        WBPoiResultItem* item=[[WBPoiResultItem alloc] init];
        item.name=info.name;
        item.uid=info.uid;
        item.address=info.address;
        item.city=info.city;
        item.phone=info.phone;
        item.postCode=info.postcode;
        item.location=info.pt;
        [poiItems addObject:item];
    }
    
    result.poiItems=poiItems;
    return result;
}
#pragma mark - annotation
-(id)dequeueReusableAnnotationViewWithIdentifier:(NSString *)aID
{
   return  [mapView dequeueReusableAnnotationViewWithIdentifier:aID];
}
-(NSArray*)annotations
{
    return mapView.annotations;
}
-(void)addAnnotation:(id)aAnnotation
{
    [mapView addAnnotation:aAnnotation];
}
-(void)removeAnnotation:(id)aAnnotation
{
    [mapView removeAnnotation:aAnnotation];
}
- (void)addAnnotations:(NSArray *)annotations
{
    [mapView addAnnotations:annotations];
}
- (void)removeAnnotations:(NSArray *)annotations
{
    [mapView removeAnnotations:annotations];
}
- (void)selectAnnotation:(id)annotation animated:(BOOL)animated
{
    [mapView selectAnnotation:annotation animated:animated];
}
- (void)deselectAnnotation:(id)annotation animated:(BOOL)animated
{
    [mapView deselectAnnotation:annotation animated:animated];
}
#pragma mark - annotation delegate
-(BMKAnnotationView*)mapView:(BMKMapView *)aMapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if([self.delegate respondsToSelector:@selector(mapView:viewForAnnotation:)])
    {
       return  (BMKAnnotationView*)[self.delegate mapView:(WBMapView*)aMapView viewForAnnotation:annotation];
    }
    return nil;
}
-(void)mapView:(BMKMapView *)aMapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if([self.delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)])
        [self.delegate mapView:(WBMapView*)aMapView didSelectAnnotationView:view];
}
-(void)mapView:(BMKMapView *)aMapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if([self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)])
        [self.delegate mapView:(WBMapView*)aMapView didDeselectAnnotationView:view];
}
#pragma mark - locationManager
-(void)startLocate
{
    [locationManager startUserLocationService];
}
-(void)stopLocate
{
    [locationManager stopUserLocationService];
}
#pragma mark - locationManager delegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading:%@",userLocation);
}
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D newCoordinate=userLocation.location.coordinate;
    double deltx=newCoordinate.latitude-lastCoordinate.latitude;
    double delty=newCoordinate.longitude-lastCoordinate.longitude;
    //超过一定的距离才更新
    double distence=sqrt(deltx*deltx+delty*delty);
    NSLog(@"distence:%lf",distence);
    if (distence > 0.0001)
    {
        lastCoordinate = userLocation.location.coordinate;
        [mapView updateLocationData:userLocation];
        if([self.delegate respondsToSelector:@selector(mapView:didUpdateToLocation:)])
            [self.delegate mapView:(WBMapView*)mapView didUpdateToLocation:(WBUserLocation*)userLocation];
    }
    
    
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
    if([self.delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)])
        [self.delegate mapView:(WBMapView*)mapView didFailToLocateUserWithError:error];
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
