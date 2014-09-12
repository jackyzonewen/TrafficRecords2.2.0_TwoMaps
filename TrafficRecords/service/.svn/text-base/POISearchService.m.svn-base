//
//  POISearchService.m
//  TrafficRecords
//
//  Created by qiao on 14-7-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "POISearchService.h"

@implementation POISearchService


- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.isSafeTranfer = YES;
        self.reqTag = EServicePOISearch;
		self.isShowNetHint = NO;
	}
	return self;
}

-(void) getPOIByType:(NSInteger) type City:(NSInteger) cityID{
//    http://221.192.136.71/getbyservice.txt
    NSString * url = [NSString stringWithFormat:@"http://y.api.autohome.com.cn/api/vendor/getbyservicecateid?serviceCateId=%d&_appid=wz&&cityid=%d", type, cityID];
    [self getData:url];
    
//	self.request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    self.request.responseEncoding = enc;
//    self.request.defaultResponseEncoding = enc;
//    [self.request addRequestHeader:@"USER_AGENT" value:KUserAgent];
//    self.request.timeOutSeconds = 30;
//    [self.request setShouldAttemptPersistentConnection:NO];
//	[self.request setDelegate:self];
//	[self.request setRequestMethod:@"GET"];
//    [self.request startAsynchronous];
}

-(void) get4SPOIByCity:(NSInteger) cityID{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getcitydealerlist.ashx?token=app_token&cityid=%d", KServerHost, cityID];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    return YES;
}

@end
