//
//  TRGardMapViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-3-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRGardMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationView2.h"
#import "GardLineChooseViewController.h"

@interface TRGardMapViewController ()
{
    CalloutMapAnnotation *_calloutAnnotation;
}

@end

@implementation TRGardMapViewController

@synthesize officeInfo;
@synthesize center;
@synthesize search;

-(NSString *) naviTitle{
    return @"路线导航";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc{
    self.search.delegate = nil;
    self.search = nil;
    _mapView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= KHeightReduce;
    _mapView = [[MKMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    if (officeInfo.latgaode.length > 0 && officeInfo.lnggaode.length > 0) {
        self.center = CLLocationCoordinate2DMake([officeInfo.latgaode doubleValue], [officeInfo.lnggaode doubleValue]);
        [_mapView setCenterCoordinate:self.center zoomLevel:KDefaultMapZoomLevel animated:YES];
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:[officeInfo.latgaode doubleValue] andLongitude:[officeInfo.lnggaode doubleValue]];
        [_mapView   addAnnotation:annotation];
        
        [_mapView selectAnnotation:annotation animated:NO];
        
    } else {
        [self startSearch];
    }
    
    UIImage *bgImage = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0x49000000] size:CGSizeMake(91, 40)];
    bgImage = [TRUtility image:bgImage withCornerRadius:4];
    UIImage *hbgImage = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0x33000000] size:CGSizeMake(91, 40)];
    hbgImage = [TRUtility image:hbgImage withCornerRadius:4];
    
    UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(_mapView.right - 110 , _mapView.bottom - 60, 91, 40);
    bgBtn.adjustsImageWhenHighlighted = YES;
//    [bgBtn setShowsTouchWhenHighlighted:YES];
    [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [bgBtn setBackgroundImage:hbgImage forState:UIControlStateHighlighted];
    [bgBtn setTitle:@"查看导航" forState:UIControlStateNormal];
    [bgBtn.titleLabel setFont:[TRSkinManager mediumFont2]];
    [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
    [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgBtn];
}

-(void) btnClick:(id) sender
{
    GardLineChooseViewController *lineChooseView = [[GardLineChooseViewController alloc] initWithNibName:@"GardLineChooseViewController" bundle:nil];
    lineChooseView.officeInfo = self.officeInfo;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lineChooseView];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)startSearch
{
    if (self.search == nil) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey:KGaoDeMapKey Delegate:self];
    }
    
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    unsigned long index = officeInfo.address.length - lenRemoved;
    if (index <= 1) {
        return;
    }
    poiRequest.keywords = [officeInfo.address substringToIndex:index];
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch: poiRequest];
}

#pragma mark -
#pragma mark MASearchDelegate Methods

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSArray* poiArray = response.pois;
    if (poiArray.count == 0) {
        lenRemoved += 1;
        [self startSearch];
        return;
    }
    for (int i=0;i<[poiArray count]; i++) {
        AMapPOI* poi = [poiArray objectAtIndex:i];
        if (i == 0 && _mapView) {
            self.center = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:poi.location.latitude andLongitude:poi.location.longitude];
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:NO];
            [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) zoomLevel:KDefaultMapZoomLevel animated:YES];
            lenRemoved = 0;
            break;
        }
        
    }
    
}

- (void)search:(id)searchRequest error:(NSString*)errInfo{
    lenRemoved += 1;
    [self startSearch];
}

#pragma mark -
#pragma mark MKAnnotationView Methods
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[CalloutMapAnnotation alloc]
                              initWithLatitude:view.annotation.coordinate.latitude
                              andLongitude:view.annotation.coordinate.longitude];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else{
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationView2 class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CallOutAnnotationView2 *annotationView = (CallOutAnnotationView2 *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView2 alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            [annotationView setTitle:officeInfo.name Address:officeInfo.address];
            annotationView.enabled = NO;
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        MKAnnotationView *annotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
		
		return annotationView;
    }
	return nil;
}

@end
