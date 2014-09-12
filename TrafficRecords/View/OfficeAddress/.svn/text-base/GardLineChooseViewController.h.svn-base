//
//  GardLineChooseViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-3-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TRBaseViewController.h"
#import "NSOfficInfo.h"
#import "ManuaLocationViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#import "TRLoadingView.h"

@interface GardLineChooseViewController : TRBaseViewController<CLLocationManagerDelegate, ManuaLocationViewControllerDelegate,AMapSearchDelegate,UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MAMapViewDelegate>
{
    MAMapView         *_mapView;
    MKMapView *mapView;
    CLLocationCoordinate2D      startPos;
    UITableView *myTableView;
    BOOL        autoLocal;//是否是自动定位
    BOOL        inAutoLocaling;
}
@property(nonatomic, weak)IBOutlet UIButton *myLocationBtn;
@property(nonatomic, weak)IBOutlet UIButton *targetAddBtn;
@property(nonatomic, weak)IBOutlet UIButton *busBtn;
@property(nonatomic, weak)IBOutlet UIButton *carBtn;
@property(nonatomic, weak)IBOutlet UIButton *walkBtn;

@property(nonatomic, strong)NSOfficInfo *officeInfo;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSArray *busTransits;
@property(nonatomic, strong)NSArray *drivePaths;
@property(nonatomic, strong)NSArray *walkingPaths;
@property(nonatomic, strong)UIView  *footView;
@property(nonatomic, strong)UIView  *notFoundLineView;
@property(nonatomic, strong)TRLoadingView  *loadingNaviView;
@property(nonatomic, strong)UIView  *notLocationView;

-(IBAction) btnClick:(UIButton *)sender;
-(IBAction) locationBtnClick:(UIButton *)sender;
@end
