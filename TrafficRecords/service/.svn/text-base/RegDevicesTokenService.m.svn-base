//
//  RegDevicesTokenService.m
//  TrafficRecords
//
//  Created by qiao on 14-3-7.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "RegDevicesTokenService.h"
#import "TRUtility.h"
#import "OpenUDID.h"
#import "AreaDBManager.h"

@implementation RegDevicesTokenService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceRegToken;
        self.isShowNetHint = NO;
        self.isUserKnow = NO;
	}
    return self;
}

-(void) regDevicesToken:(NSString *) token UID:(NSString *) userId{
    NSString *deviceName = [NSString stringWithFormat:@"%@\t%@\t%@\t%@",[UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion, @"weizhang", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleVersionKey]];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setObject:deviceName forKey:@"deviceName"];

    [mutableDic setObject:@"1" forKey:@"deviceType"];
    NSString *str =[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleIdentifierKey];
    int formal = 0;
    //企业开发者证书
    if ([str isEqualToString:@"com.TrafficRecords"]) {
        formal = 1;
    }
    [mutableDic setObject:token forKey:@"deviceToken"];
    [mutableDic setObject:userId.length > 0 ? userId : @"" forKey:@"userId"];
    [mutableDic setObject:[NSNumber numberWithInt:formal] forKey:@"formal"];
    [mutableDic setObject:[OpenUDID value] forKey:@"deviceid"];
    [mutableDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KGUIDKey] forKey:@"deviceStamp"];
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId == 0) {
        cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
    }
    [mutableDic setObject:[NSNumber numberWithInt:cityId] forKey:@"Cityid"];
    NSString * url = [NSString stringWithFormat:@"%@ashx/push/user/reg.ashx?", KServerHost];
    [self sendPost:url Dictinary:mutableDic ImageArray:nil];
    NSLog(@"%@", mutableDic);
//    deviceName = [TRUtility URLEncodedString:deviceName];
//    NSString *str =[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleIdentifierKey];
//    int formal = 0;
//    //企业开发者证书
//    if ([str isEqualToString:@"com.TrafficRecords"]) {
//        formal = 1;
//    }
//    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
//    if (cityId == 0) {
//        cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
//    }
//    NSString * url = [NSString stringWithFormat:@"%@ashx/push/user/reg.ashx?deviceType=1&deviceToken=%@&deviceName=%@&userId=%@&formal=%d&deviceid=%@&deviceStamp=%@&Cityid=%d", KServerHost, token, deviceName, userId.length > 0 ? userId:@"",formal, [OpenUDID value], [[NSUserDefaults standardUserDefaults] objectForKey:KGUIDKey], cityId];
//    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    return YES;
}

@end
