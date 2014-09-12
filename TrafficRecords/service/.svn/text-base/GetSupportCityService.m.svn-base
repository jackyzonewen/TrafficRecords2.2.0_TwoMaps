//
//  GetSupportCityService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "GetSupportCityService.h"
#import "JSON.h"

@implementation GetSupportCityService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.reqTag = EServiceGetSupportCity;
        self.isShowNetHint = NO;
        self.isUserKnow = NO;
		return self;
	}
	else
    {
		return nil;
	}
}

-(void) upDateSupportCitys{
    NSString * url = [NSString stringWithFormat:@"%@ashx/updateallcity.ashx?", KServerHost];
   [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSArray *items = [result objectForKey:@"items"];
    if (items.count > 0) {
        [TRUtility writecontent:[items JSONRepresentation] toFile:@"support.json"];
    }
    return YES;
}

@end
