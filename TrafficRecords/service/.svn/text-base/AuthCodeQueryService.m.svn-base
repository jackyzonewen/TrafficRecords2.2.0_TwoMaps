//
//  AuthCodeQueryService.m
//  TrafficRecords
//
//  Created by qiao on 13-10-14.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AuthCodeQueryService.h"

@implementation AuthCodeQueryService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceAuthCodeQuery;
		return self;
	}
    return nil;
}

-(void) queryTrafRecord:(NSString *) jsonText{
    NSString * url = [NSString stringWithFormat:@"%@ashx/GetViolationCaptcha.ashx?net=%@", KServerHost, [TRUtility getNetworkType]];
    NSLog(@"%@", jsonText);
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithObject:jsonText forKey:@"carinfo"] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSArray *taskItems = [result objectForKey:@"taskitems"];
    if (taskItems.count > 0) {
        taskList = [NSMutableArray array];
        for (NSDictionary *taskDic in taskItems) {
            TRProxyTask *task = [TRProxyTask taskWithNSDictionary:taskDic];
            [taskList addObject:task];
        }
    }
    return YES;
}

@end
