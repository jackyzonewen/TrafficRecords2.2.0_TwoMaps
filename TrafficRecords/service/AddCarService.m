//
//  AddCarService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-21.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AddCarService.h"

@implementation AddCarService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceAddCar;
		return self;
	}
	else
    {
		return nil;
	}
}

-(void) addCarWithJson:(NSString *) jsonText{
    NSString * url = [NSString stringWithFormat:@"%@ashx/AddCar.ashx?", KServerHost];
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

- (void)notifyNetServiceError:(AHServiceRequestTag) tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (errorCode == -50) {
        [self.delegate netServiceError:tag errorCode:errorCode errorMessage:errorMessage];
    } else {
        [super notifyNetServiceError:tag errorCode:errorCode errorMessage:errorMessage];
    }
}

@end
