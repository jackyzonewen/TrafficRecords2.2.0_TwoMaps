//
//  TRDetailViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-13.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "AreaDBManager.h"

#define KDefaultMapZoomLevel 16

@interface TRDetailViewController ()

@end

@implementation TRDetailViewController

@synthesize detailRecord;
@synthesize center;
-(NSString *) naviTitle{
    return @"违章详情";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KDefaultStartY, 320, mapheight)];
    mapView.zoomLevel = KDefaultMapZoomLevel;
    [self.view addSubview:mapView];
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, mapView.bottom, size.width, size.height)];
    placeLabel.numberOfLines = 0;
    [placeLabel setFont:font];
    [placeLabel setBackgroundColor:[UIColor clearColor]];
    [placeLabel setTextColor:[TRSkinManager textColorDark]];
    [self.view addSubview:placeLabel];
    placeLabel.text = place;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (detailRecord.latitude > 0 && detailRecord.longitude > 0) {
        self.center = CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude);
        mapView.zoomLevel = KDefaultMapZoomLevel;
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude) animated:NO];
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude);
        item.title = detailRecord.content;
        [mapView addAnnotation:item];
    } else {
        [self startSearch];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    if(detailRecord.latitude > 0 && detailRecord.longitude > 0){
        [mapView setCenterCoordinate:CLLocationCoordinate2DMake(detailRecord.latitude, detailRecord.longitude) animated:NO];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MASearchDelegate methods

- (void)startSearch
{
    search.delegate = nil;
    search = nil;
    search = [[BMKSearch alloc]init];
    search.delegate = self;
    
    //发起POI检索
    NSRange range = [detailRecord.location rangeOfString:@"市"];
    NSString *cityName = nil;
    if (range.length > 0) {
        cityName = [detailRecord.location substringToIndex:range.location];
    } else {
        City *city = [AreaDBManager getCityByCityId: [detailRecord.cityid integerValue]];
        cityName = city.name;
    }
    
    int index = detailRecord.location.length - lenRemoved;
    if (index <= 1) {
        return;
    }
    NSString *searchName = [detailRecord.location substringToIndex:index];
    [search poiSearchInCity:cityName withKey:searchName pageIndex:0];
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    if (error == BMKErrorOk) {
        BMKPoiResult* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = detailRecord.content;
            [mapView addAnnotation:item];
            self.center = poi.pt;
            [mapView setCenterCoordinate:poi.pt animated:YES];
            search.delegate = nil;
            search = nil;
            return;
        }
    } else {
        lenRemoved ++;
        [self performSelector:@selector(startSearch) withObject:nil afterDelay:0];
    }
}


@end
