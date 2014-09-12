//
//  ReportLocErrService.m
//  TrafficRecords
//
//  Created by qiao on 14-3-20.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "ReportLocErrService.h"

@implementation ReportLocErrService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceReportLocErr;
        self.isShowNetHint = NO;
	}
    return self;
}

-(void) reportErrMsg:(NSDictionary *)errDic{
    NSString * url = [NSString stringWithFormat:@"%@ashx/updateviolation.ashx?", KServerHost];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithDictionary:errDic] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
//    NSDictionary * result = [strJSON objectForKey:@"result"];
//    if (result == nil) {
//        return NO;
//    }
    return YES;
}

@end
