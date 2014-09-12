//
//  CityViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "AHThirdSelectView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SupportCityManager.h"

@protocol AreaDelegate <NSObject>

@optional
- (void) selectedCitys:(NSArray *)array;
@end

@interface CityViewController : TRBaseViewController<AHThirdSelectViewDelegate, AHThirdSelectViewDataSource, CLLocationManagerDelegate>{
    NSMutableArray       *firstLetterArray;
    NSMutableDictionary  *provinceDic;
    NSMutableArray       *cityArray;
    NSMutableArray       *selectCitys;
    AHThirdSelectView    *thirdView;
    
    CLGeocoder  *geoCoder;
    CLLocationManager *locationMgr;
    
    int             selectCityType;//1选择了广西的某个城市；2选择了天津的某个城市；0选择其他的
    
    UIImageView         *selectCellBg1;
    UIImageView         *selectCellBg2;
}

-(void) setSelectCitys:(NSArray *) citys;

@property(nonatomic, strong)  UIScrollView *selContainerView;
@property(nonatomic, strong)  UILabel *holdLabel;
//1为定位，2为城市选择
@property(nonatomic, assign)int controllerType;
@property(nonatomic, weak) id<AreaDelegate> areaDelegate;

@end
