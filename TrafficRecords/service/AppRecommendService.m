//
//  AppRecommadService.m
//  TrafficRecords
//
//  Created by qiao on 14-4-24.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AppRecommendService.h"

@implementation AppRecommendService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.reqTag = EServiceGetAppRecommdList;
		
	}
	return self;
}

-(void) getRecommendList{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getapprecommend.ashx?", KServerHost];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString *responseText = self.request.responseString;
    [TRUtility writecontent:responseText toFile:KAPPRecommadListFileName];
    return YES;
}

@end
