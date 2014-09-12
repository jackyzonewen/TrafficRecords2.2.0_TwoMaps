//
//  ManuaLocationViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-3-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "ManuaLocationViewController.h"
#import "CallOutAnnotationView.h"
#import "MKMapView+ZoomLevel.h"

@interface ManuaLocationViewController ()

@end

@implementation ManuaLocationViewController

@synthesize center;
@synthesize delegate;

-(NSString *) naviTitle{
    return @"手动定位";
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
    _mapView = nil;
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
    if (self.center.latitude > 0 && self.center.longitude > 0) {
        [_mapView setCenterCoordinate:self.center zoomLevel:15 animated:YES];
    }
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mTapPress:)];
    [_mapView addGestureRecognizer:mTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击地图事件
- (void)mTapPress:(UIGestureRecognizer*)gestureRecognizer {
//    return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
    
    
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    if (locationPoint == nil) {
        locationPoint = [[MKPointAnnotation alloc] init];
        locationPoint.coordinate = touchMapCoordinate;
        [_mapView addAnnotation:locationPoint];
    } else {
        double change = ABS(touchMapCoordinate.latitude - locationPoint.coordinate.latitude) + ABS(touchMapCoordinate.longitude - locationPoint.coordinate.longitude);
        if (change < 0.0004) {
            if (delegate && [delegate respondsToSelector:@selector(locationBeLocated:)]) {
                [delegate locationBeLocated:locationPoint.coordinate];
            }
            [self naviLeftClick:nil];
            return;
        }
        locationPoint.coordinate = touchMapCoordinate;
    }
//    [_mapView addAnnotation:locationPoint];
}

- (void)mTapPress2:(UIGestureRecognizer*)gestureRecognizer {
    if (delegate && [delegate respondsToSelector:@selector(locationBeLocated:)]) {
        [delegate locationBeLocated:locationPoint.coordinate];
    }
    [self naviLeftClick:nil];
}

#pragma mark -
#pragma mark MKAnnotationView Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
    if (!annotationView) {
        annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
        [annotationView setContenText:@"再次点击即可选择此点"];
        annotationView.enabled = NO;
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mTapPress2:)];
        [annotationView addGestureRecognizer:mTap];
    }
    return annotationView;
}

@end
