//
//  WeatherService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "WeatherService.h"
#import "WeatherModule.h"
#import "JSON.h"

@implementation WeatherService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.reqTag = EServiceGetWeather;
	}
	return self;
}

-(void) getWeatherInfo: (int) cityId{
    //优先从缓存中读取，读取失败则联网
    NSString * url = [NSString stringWithFormat:@"%@ashx/GetWeather.ashx?cityid=%d", KServerHost, cityId];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSArray *items = [result objectForKey:@"items"];
    weather = nil;
    weather = [NSMutableArray array];
    for (NSDictionary * dic in items) {
        WeatherModule * module = [[WeatherModule alloc] init];
        module.dateIndex = [[dic objectForKey:@"index"] intValue];
        module.date = [dic objectForKey:@"date"];
        module.weatherType = [[dic objectForKey:@"weathertype"] intValue];
        module.weatherText = [dic objectForKey:@"weathertext"];
        module.lowTemper = [[dic objectForKey:@"lowtemperature"] intValue];
        module.highTemper = [[dic objectForKey:@"hightemperature"] intValue];
        module.air = [[dic objectForKey:@"air"] intValue];
        module.airText = [dic objectForKey:@"airtext"];
        module.xicheZhishu = [dic objectForKey:@"xiche"];
        [weather addObject:module];
    }
    return YES;
}

-(NSMutableArray *) weatherArray{
    return weather;
}

@end
