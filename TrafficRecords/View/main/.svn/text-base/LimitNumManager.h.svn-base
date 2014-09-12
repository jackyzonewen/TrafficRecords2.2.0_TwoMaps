//
//  LimtNumManager.h
//  TrafficRecords
//
//  Created by qiao on 13-9-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"
#import "LimitCityInfo.h"

@interface LimitNumManager : AHServiceBase

@property (nonatomic, strong) NSMutableDictionary     *contentDic;
@property (nonatomic, strong) NSMutableDictionary     *cityInfoDic;

+(NSString *) getLimitNumByCity:(int) cityId;
+ (NSString *)getTodayDateWeek;
+(void) resetGlobObject;
+(NSString *) getLimitNumByCity:(int) cityId date:(NSDate *) date;
+(NSString *) limitInfo:(NSInteger )cityId ForCar:(NSString *) carNo;
+(LimitCityInfo *) cityInfo:(int) cityId;
@end
