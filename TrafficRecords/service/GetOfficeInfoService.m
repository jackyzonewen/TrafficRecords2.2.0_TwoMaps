//
//  GetOfficeInfoService.m
//  TrafficRecords
//
//  Created by qiao on 14-3-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GetOfficeInfoService.h"
#import "JSON.h"

@implementation GetOfficeInfoService

@synthesize items;
- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = NO;
        self.isAddCache = YES;
        self.isShowNetHint = YES;
        self.reqTag = EServiceGetOfficeInfo;
        self.cacheTime = 31536000;//一年
	}
    return self;
}

-(void) getOfficeInfoByCity:(int) cityId
{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getaddress.ashx?cityid=%d", KServerHost, cityId];
    self.cacheKey = [TRUtility md5Value:url];
    [self getData:url];
}

-(NSArray *) getCacheItemsByCity:(int) cityId
{
    NSString *url = [NSString stringWithFormat:@"%@ashx/getaddress.ashx?cityid=%d", KServerHost, cityId];
    NSString *acacheKey =[TRUtility md5Value:url];
    NSString *ret = [[EGOCache globalCache] stringForKey:acacheKey];
    if (ret.length > 0) {
        NSDictionary * result = [ret JSONValue];
        result = [result objectForKey:@"result"];
        return [result objectForKey:@"items"];
    }
    return nil;
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    self.items = [result objectForKey:@"items"];
    return YES;
}

@end
