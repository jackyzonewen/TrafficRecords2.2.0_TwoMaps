//
//  DeleteCarService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-26.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "DeleteCarService.h"

@implementation DeleteCarService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.reqTag = EServiceDeleteCar;
        self.isShowNetHint = NO;
		return self;
	}
    return nil;
}

-(void) deleteCarWithJson:(NSDictionary *) deleteDic{
    NSString * url = [NSString stringWithFormat:@"%@ashx/deleteCar.ashx?", KServerHost];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithDictionary:deleteDic] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString * carTimestamp = [result objectForKey:@"carstimestamp"];
    [[NSUserDefaults standardUserDefaults] setObject:carTimestamp forKey:KCarsTimestamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}


@end
