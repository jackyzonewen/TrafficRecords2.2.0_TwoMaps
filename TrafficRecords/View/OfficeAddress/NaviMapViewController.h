//
//  NaviMapViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-3-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface NaviMapViewController : UIViewController<MAMapViewDelegate>
{
    MAMapView         *_mapView;
    float             infViewHeight;
    CGPoint           lastTouchPos;
    UIButton          *dragBtn;
    
}
@property (nonatomic, strong) AMapTransit       *busLineData;
@property (nonatomic, strong) AMapPath          *pathData;
@property (nonatomic, assign) CLLocationCoordinate2D startPos;
@property (nonatomic, assign) CLLocationCoordinate2D endPos;
@property (nonatomic, assign) int               type;//0为公交，1为自驾车；2为步行
@property (nonatomic, strong) NSString          *mytitle;
@property (nonatomic, strong) NSString          *subtitle;
@property (nonatomic, strong) UIView            *infoView;

@end
