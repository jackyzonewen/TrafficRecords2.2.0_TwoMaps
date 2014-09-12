//
//  BindingCarService.m
//  TrafficRecords
//
//  Created by 张小桥 on 13-12-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "BindingCarService.h"
#import "CarInfo.h"

@implementation BindingCarService

@synthesize carTimeStamp;
@synthesize toBindingCars;

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceBindingCars;
	}
    return self;
}

-(void) binding:(NSString *) userId withCars:(NSString *) cars{
    self.toBindingCars = cars;
    NSString * url = [NSString stringWithFormat:@"%@ashx/AddCarsBindUser.ashx?user_id=%@&vehicle_ids=%@", KServerHost, userId, self.toBindingCars];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    self.carTimeStamp = [result objectForKey:@"carstimestamp"];
    return YES;
}
@end
