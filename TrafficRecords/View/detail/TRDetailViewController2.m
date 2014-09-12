//
//  TRDetailViewController2.m
//  TrafficRecords
//
//  Created by qiao on 13-11-13.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRDetailViewController2.h"
#import "PlaceAnnotation.h"
#import "MKMapView+ZoomLevel.h"

#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationView.h"

@interface TRDetailViewController2 (){
    CalloutMapAnnotation *_calloutAnnotation;
}

@end

@implementation TRDetailViewController2

@synthesize detailRecord;
@synthesize center;
@synthesize search;

-(NSString *) naviTitle{
    return @"违章详情";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) dealloc{
    self.search.delegate = nil;
    self.search = nil;
    _mapView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [TRSkinManager bgColorWhite];
    UIFont *font = [TRSkinManager mediumFont2];
    NSString *place = detailRecord.location;
    CGSize size = [place sizeWithFont:font constrainedToSize:CGSizeMake(self.view.width - 20, 1000000)];
    size.height += 20;
    
    float mapheight = self.view.height - KHeightReduce - size.height;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, mapheight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    if (detailRecord.latitude > 0 && detailRecord.longitude > 0 ) {
        self.center = CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude);
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude) zoomLevel:KDefaultMapZoomLevel animated:YES];
        
        
        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:detailRecord.latitude andLongitude:detailRecord.longitude];
        [_mapView   addAnnotation:annotation];
    
        [_mapView selectAnnotation:annotation animated:NO];
        
    } else {
        [self startSearch];
    }
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _mapView.bottom, size.width, size.height)];
    placeLabel.numberOfLines = 0;
    [placeLabel setFont:[UIFont systemFontOfSize:17]];
    [placeLabel setBackgroundColor:[UIColor clearColor]];
    [placeLabel setTextColor:[TRSkinManager textColorDark]];
    [self.view addSubview:placeLabel];
    placeLabel.text = place;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, placeLabel.top - 0.5, _mapView.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0x999999];
    [self.view addSubview:line];
    
//    reportErr@2x.png
    UIImage *report =  TRImage(@"reportErr.png");
    UIButton * locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setBackgroundImage:report forState:UIControlStateNormal];
    [locationBtn setFrame:CGRectMake(15, line.top - 15 - report.size.height, report.size.width, report.size.height)];
    [locationBtn addTarget:self action:@selector(reportErr) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
}

-(void) reportErr{
    if (inReporting) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定提交该定位的报错信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        if (reportService == nil) {
            reportService = [[ReportLocErrService alloc] init];
            reportService.delegate = self;
        }
        inReporting = YES;
        NSDictionary * dic = nil;
        if (detailRecord.latitude > 0 && detailRecord.longitude > 0 ) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:detailRecord.recordid.intValue], @"recordid",
                   [NSString stringWithFormat:@"%f", detailRecord.latitude], @"lat",
                   [NSString stringWithFormat:@"%f", detailRecord.longitude], @"lng",
                   nil];
        } else {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:detailRecord.recordid.intValue], @"recordid",
                   [NSString stringWithFormat:@"%f", center.latitude], @"lat",
                   [NSString stringWithFormat:@"%f", center.latitude], @"lng",
                   nil];
        }
        
        [reportService reportErrMsg:dic];
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    inReporting = NO;
    [self showInfoView:@"我们已收到您的报错，感谢您的支持！"];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    inReporting = NO;
    [self showInfoView:@"我们已收到您的报错，感谢您的支持！"];
}

- (void)startSearch
{
    if (self.search == nil) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey:KGaoDeMapKey Delegate:self];
    }

    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    NSUInteger index = detailRecord.location.length - lenRemoved;
    if (index <= 1) {
        poiRequest.keywords = @"北京市天安门";
    } else {
        poiRequest.keywords = [detailRecord.location substringToIndex:index];
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationView class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            annotationView.contenText = detailRecord.content;
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
