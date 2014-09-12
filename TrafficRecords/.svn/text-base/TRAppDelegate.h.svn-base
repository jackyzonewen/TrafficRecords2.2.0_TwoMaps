//
//  TRAppDelegate.h
//  TrafficRecords
//
//  Created by qiao on 13-8-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRUtility.h"
#import "AHNetDelegate.h"
#import "GetAppInfoService.h"
#import "GetSupportCityService.h"
#import "MMDrawerController.h"
#import "RegDevicesTokenService.h"
#import "LuKuangInfoService.h"
#import "BMapKit.h"

@class TRMainViewController;
@class BMKMapManager;

@interface TRAppDelegate : UIResponder <UIApplicationDelegate, AHServiceDelegate>{
//    BMKMapManager* _mapManager;
    RegDevicesTokenService *regDeviceTokenService;
    NSDate                 *enterForegroundTime;
    NSDictionary           *pushInfo;
    BMKMapManager          *_mapManager;
    BOOL                    tokenBeSended;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TRMainViewController *viewController;
@property (nonatomic, strong) GetAppInfoService     *appInfo;
@property (nonatomic, strong) GetSupportCityService *supportCitys;
@property (nonatomic, strong) LuKuangInfoService    *luKuangService;
@property (nonatomic, assign) int                    userId;
@property (nonatomic, strong) NSString               *userName;
@property (nonatomic, strong) NSString               *password;

+(TRAppDelegate *) appDelegate;
-(void) getAppInfo;
+(MMDrawerController *)mmDrawerController;
-(void) sendToken;
@end

