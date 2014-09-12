//
//  CityOfCar.m
//  TrafficRecords
//
//  Created by qiao on 13-9-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "CityOfCar.h"

@implementation CityOfCar

@synthesize cityid;
@synthesize carid;
@synthesize timestamp;
@synthesize authovertime;
@synthesize authurl;
@synthesize authImage;
@synthesize authInfoMsg;


+(CityOfCar *) createByDic:(NSDictionary *) dic{
    CityOfCar * city = [[CityOfCar alloc] init];
    city.cityid = [dic objectForKey:@"cityid"];
    city.carid = [dic objectForKey:@"carid"];
    city.timestamp = [dic objectForKey:@"timestamp"];
    city.authovertime = [dic objectForKey:@"authovertime"];
    city.authurl = [dic objectForKey:@"authurl"];
    return city;
}

@end
