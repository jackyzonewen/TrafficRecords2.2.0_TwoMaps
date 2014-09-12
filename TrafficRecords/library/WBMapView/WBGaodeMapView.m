//
//  WBGaodeMapView.m
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "WBGaodeMapView.h"

@implementation WBGaodeMapView
{
    MAMapView* mapView;
    AMapSearchAPI* poiSearcher;
}
-(void)tearDown
{
    mapView.showsUserLocation=NO;
    mapView.showTraffic=NO;
    self.delegate=nil;
    mapView.delegate=nil;
    poiSearcher.delegate=nil;
    self.mapView=nil;
    self.poiSearcher=nil;
}
-(void)configWith:(CGRect)aFrame
{
    mapView=[[MAMapView alloc] initWithFrame:aFrame];
    mapView.delegate=self;
    [self insertSubview:mapView atIndex:0];
    poiSearcher=[[AMapSearchAPI alloc] initWithSearchKey:Gaode_API_Key Delegate:self];
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
}
-(BOOL)showsCompass
{
    return mapView.showsCompass;
}
-(void)setShowsCompass:(BOOL)showsCompass
{
    
    mapView.showsCompass=showsCompass;
}
-(BOOL)showsScaleBar
{
    return mapView.showsScale;
}
-(void)setShowsScaleBar:(BOOL)showsScaleBar
{
    mapView.showsScale=showsScaleBar;
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
    [mapView setZoomLevel:zoomLevel animated:YES];
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
    return (WBUserLocation *)mapView.userLocation;
}
-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate animated:(BOOL)ani
{
    [mapView setCenterCoordinate:centerCoordinate animated:ani];
}
-(WBCoordinateRegion)region
{
    return coordinateRegionConvertToLocalFromGaode(mapView.region);
}
-(void)setRegion:(WBCoordinateRegion)aRegion animated:(BOOL)isAnimated
{
    [mapView setRegion:coordinateRegionConvertToGaode(aRegion) animated:isAnimated];
}
-(BOOL)showsTraffic
{
    return mapView.showTraffic;
}
-(void)setShowsTraffic:(BOOL)showsTraffic
{
    mapView.showTraffic=showsTraffic;
}
#pragma mark - POI search
-(void)poiSearchWithRequest:(id)aRequest
{
    [poiSearcher AMapPlaceSearch:(AMapPlaceSearchRequest*)aRequest];
}
#pragma mark - POI search delegate
- (void)search:(id)searchRequest error:(NSString*)errInfo
{
    NSLog(@"errinfo:%@",errInfo);
    if([self.delegate respondsToSelector:@selector(poiSearch:error:)])
        [self.delegate poiSearch:poiSearcher error:errInfo];
}
-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSLog(@"response:%@",response);
    if([self.delegate respondsToSelector:@selector(poiSearch:didFinishedSearchWithResult:)])
        [self.delegate poiSearch:poiSearcher didFinishedSearchWithResult:[self convertToWBPoiResultWith:response]];
}
-(WBPoiResult*)convertToWBPoiResultWith:(AMapPlaceSearchResponse*)aResponse
{
    WBPoiResult * result=[[WBPoiResult alloc] init];
    NSMutableArray * poiItems=[[NSMutableArray alloc] init];
    for(AMapPOI* info in [aResponse pois])
    {
        WBPoiResultItem* item=[[WBPoiResultItem alloc] init];
        item.name=info.name;
        item.uid=info.uid;
        item.address=info.address;
        item.city=info.city;
        item.phone=info.tel;
        item.postCode=info.postcode;
        item.location=CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
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
-(MAAnnotationView*)mapView:(MAMapView *)aMapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([self.delegate respondsToSelector:@selector(mapView:viewForAnnotation:)])
    {
        return  (MAAnnotationView*)[self.delegate mapView:(WBMapView*)aMapView viewForAnnotation:annotation];
    }
    return nil;
}
-(void)mapView:(MAMapView *)aMapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if([self.delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)])
        [self.delegate mapView:(WBMapView*)aMapView didSelectAnnotationView:view];
}
-(void)mapView:(MAMapView *)aMapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if([self.delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)])
        [self.delegate mapView:(WBMapView*)aMapView didDeselectAnnotationView:view];
}
#pragma mark - userLocation
-(void)startLocate
{
    mapView.showsUserLocation=YES;
}
-(void)stopLocate
{
    //mapView.showsUserLocation=NO;
}
#pragma mark - userLocation delegate
-(void)mapViewWillStartLocatingUser:(MAMapView *)mapView
{
    //NSLog(@"will start locating user location");
}
-(void)mapViewDidStopLocatingUser:(MAMapView *)mapView
{
    //NSLog(@"did stop locating user location");
}
- (void)mapView:(MAMapView *)aMapView didFailToLocateUserWithError:(NSError *)error
{
    //NSLog(@"did faild to locate user location");
    if([self.delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)])
        [self.delegate mapView:(WBMapView*)aMapView didFailToLocateUserWithError:error];
}
-(void)mapView:(MAMapView *)aMapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    if([self.delegate respondsToSelector:@selector(mapView:didUpdateToLocation:)])
        [self.delegate mapView:(WBMapView*)aMapView didUpdateToLocation:(WBUserLocation*)userLocation];
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
