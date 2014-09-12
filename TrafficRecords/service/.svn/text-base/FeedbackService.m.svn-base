//
//  FeedbackService.m
//  TrafficRecords
//
//  Created by qiao on 14-5-5.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "FeedbackService.h"
#import "OpenUDID.h"
#import "CarInfo.h"
#import "AreaDBManager.h"
#import "TRReachability.h"
#import "JSON.h"

@implementation FeedbackService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.isSafeTranfer = YES;
        self.reqTag = EServiceFeedBackGet;
		
	}
	return self;
}

-(void) getFeedbackList{
    NSString * url = [NSString stringWithFormat:@"%@ashx/FeedBackList.ashx?deviceId=%@", KServerHost, [OpenUDID value]];
    [self getData:url];
}



-(void) postFeedback:(NSString *) content contacts:(NSString *) contacts{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[NSNumber numberWithInteger:feedbackId] forKey:@"questionid"];
    [dic setObject:[NSNumber numberWithInteger:[TRAppDelegate appDelegate].userId] forKey:@"userid"];
    [dic setObject:[OpenUDID value] forKey:@"deviceid"];
    NSArray *cars = [CarInfo globCarInfo];
    NSMutableString *str = [NSMutableString string];
    for (CarInfo *info in cars) {
        if (str.length > 0) {
            [str appendString:@","];
        }
        [str appendString:info.carid];
    }
    [dic setObject:str forKey:@"vehicleid"];
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    City * city = [AreaDBManager getCityByCityId:cityId];
    if (city && city.name.length > 0) {
        [dic setObject:city.name forKey:@"belongscityname"];
    } else {
        [dic setObject:@"" forKey:@"belongscityname"];
    }
    [dic setObject:[TRUtility getMobileModle] forKey:@"deviceinfo"];
    [dic setObject:[TRUtility getOsInfo] forKey:@"deviceos"];
    if (contacts.length > 0) {
        [dic setObject:contacts forKey:@"contacts"];
    } else {
        [dic setObject:@"" forKey:@"contacts"];
    }
    
    [dic setObject:content forKey:@"questioncontent"];
    NetworkStatus status = [TRReachability reachabilityForInternetConnection].currentReachabilityStatus;
    NSString *mobileNetworkOperators = [TRUtility getMobileNetworkOperators];
    if(status == ReachableViaWiFi){
        [dic setObject:@"wifi" forKey:@"network"];
        [dic setObject:@"" forKey:@"nettype"];
    } else if(status == kReachableViaWWAN){
        int netype = [TRUtility dataNetworkTypeFromStatusBar];
        if (mobileNetworkOperators == nil) {
            [dic setObject:@"未知运营商" forKey:@"nettype"];
        } else {
            [dic setObject:mobileNetworkOperators forKey:@"nettype"];
        }
        NSString *type = [NSString stringWithFormat:@"unKonw%d", netype];
        //1为2G,2为3G，3为4G，4为LTE，5为wifi
        if (netype == 1) {
            type = @"2G";
        }else if (netype == 2) {
            type = @"3G";
        } else if(netype == 3){
            type = @"4G";
        } else if(netype == 4){
            type = @"LTE";
        }
        [dic setObject:type forKey:@"network"];
    }
    [dic setObject:[NSNumber numberWithBool:[TRUtility isJailBreak]] forKey:@"isroot"];
    NSString *jsonText = [dic JSONRepresentation];
    NSString * url = [NSString stringWithFormat:@"%@ashx/Feedback.ashx?", KServerHost];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithObject:jsonText forKey:@"info"] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString *responseText = self.request.responseString;
    [TRUtility writecontent:responseText toFile:KFeedbackFileName];
    return YES;
}

@end
