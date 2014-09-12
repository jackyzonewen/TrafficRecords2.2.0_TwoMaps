//
//  GaoFadiViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-8-11.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "BMapKit.h"
#import "GaoFaDiService.h"
#import "UMSocial.h"

@interface GaoFadiViewController : TRBaseViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, UMSocialUIDelegate>
{
    BMKMapView              *_mapView;
    BMKLocationService      *_locService;
    BMKUserLocation         *userlocation;
    
    GaoFaDiService          *searchService;
    
    
    UIView                  *infoView;
    UIButton                *locationBtn;
    BOOL                     hasShow;
}

@end
