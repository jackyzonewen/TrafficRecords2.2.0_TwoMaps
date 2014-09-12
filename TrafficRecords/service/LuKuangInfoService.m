//
//  LuKuangInfoService.m
//  TrafficRecords
//
//  Created by qiao on 14-4-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "LuKuangInfoService.h"

@implementation LuKuangInfoService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.reqTag = EServiceLuKuangInfo;
		
	}
	return self;
}

-(void) getLuKuangInfo{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getroadmap.ashx?", KServerHost];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString *responseText = self.request.responseString;
    [TRUtility writecontent:responseText toFile:KLuKuangSaveFileName];
    return YES;
}

@end
