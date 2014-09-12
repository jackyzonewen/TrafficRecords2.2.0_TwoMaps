//
//  WeatherModule.m
//  TrafficRecords
//
//  Created by qiao on 13-9-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "WeatherModule.h"

@implementation WeatherModule

@synthesize dateIndex;
@synthesize date;
@synthesize weatherType;
@synthesize weatherText;
@synthesize lowTemper;
@synthesize highTemper;
@synthesize air;
@synthesize airText;
@synthesize xicheZhishu;

-(UIImage *) weatherIcon{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *str = [NSString stringWithFormat:@"mw%d.png", weatherType];
    if (currentDateStr.intValue >= 18) {
        str = [NSString stringWithFormat:@"nmw%d.png", weatherType];
    }
   
    return TRImage(str);
}

@end
