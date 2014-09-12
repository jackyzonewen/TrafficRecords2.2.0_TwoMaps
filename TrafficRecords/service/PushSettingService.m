//
//  PushSettingService.m
//  TrafficRecords
//
//  Created by qiao on 14-5-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "PushSettingService.h"
#import "AreaDBManager.h"

@implementation PushSettingService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.isSafeTranfer = YES;
        self.reqTag = EServicePushSetting;
		self.isShowNetHint = NO;
//        self.isUserKnow = NO;
	}
	return self;
}

-(void) upWzPushSetting:(BOOL) open{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey];
    if (token.length == 0) {
        return;
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId == 0) {
        cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
    }
    NSString * url = [NSString stringWithFormat:@"%@ashx/push/user/clientsetting/vsave.ashx?deviceToken=%@&Cityid=%d&AllowPLimit=%d&StartTime=%@&EndTime=%@", KServerHost, token, cityId, !open, @"", @""];
    [self getData:url];
}

-(void) upLoadPushSetting:(BOOL) open startTime:(NSString *) time1 endTime:(NSString *) time2{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey];
    if (token.length == 0) {
        return;
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId == 0) {
        cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
    }
    NSString * url = [NSString stringWithFormat:@"%@ashx/push/user/clientsetting/save.ashx?deviceToken=%@&Cityid=%d&AllowPLimit=%d&StartTime=%@&EndTime=%@", KServerHost, token, cityId, !open, time1, time2];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
//    NSDictionary * result = [strJSON objectForKey:@"result"];
//    if (result == nil) {
//        return NO;
//    }
    return YES;
}

@end
