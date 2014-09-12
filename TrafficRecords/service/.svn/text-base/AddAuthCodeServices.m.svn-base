//
//  AddAuthCodeServices.m
//  TrafficRecords
//
//  Created by qiao on 13-10-18.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AddAuthCodeServices.h"

@implementation AddAuthCodeServices

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceAddCarAuthCode;
		return self;
	}
    return nil;
}

-(void) queryTrafRecord:(NSString *) jsonText{
    NSString * url = [NSString stringWithFormat:@"%@ashx/AddViolationCaptcha.ashx?", KServerHost];
    NSLog(@"%@", jsonText);
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithObject:jsonText forKey:@"carinfo"] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString * carTimestamp = [result objectForKey:@"carstimestamp"];
    [[NSUserDefaults standardUserDefaults] setObject:carTimestamp forKey:KCarsTimestamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSArray *taskItems = [result objectForKey:@"taskitems"];
//    if (taskItems.count > 0) {
//        needSucessCount = 1;
//        taskList = [NSMutableArray array];
//        for (NSDictionary *taskDic in taskItems) {
//            TRProxyTask *task = [TRProxyTask taskWithNSDictionary:taskDic];
//            [taskList addObject:task];
//        }
//    }
    return YES;
}
@end
