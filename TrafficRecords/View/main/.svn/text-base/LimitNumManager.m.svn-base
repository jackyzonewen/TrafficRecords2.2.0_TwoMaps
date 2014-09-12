//
//  LimtNumManager.m
//  TrafficRecords
//
//  Created by qiao on 13-9-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LimitNumManager.h"
#import "TRUtility.h"
#import "JSON.h"
#import "AreaDBManager.h"

static LimitNumManager * limitManager = nil;

@implementation LimitNumManager
@synthesize contentDic;

-(id) init{
    self = [super init];
    if (self) {
        self.contentDic = [[NSMutableDictionary alloc] init];
        self.cityInfoDic = [[NSMutableDictionary alloc] init];
        NSString * json = [TRUtility readcontentFromFile:@"limitNum2.json"];
        NSArray *array = [json JSONValue];
        for (NSDictionary *dic in array) {
            int cityID = [[dic objectForKey:@"cityid"] intValue];
            NSString *city = [NSString stringWithFormat:@"%d", cityID];
            
            LimitCityInfo *cityInfo = [[LimitCityInfo alloc] init];
            cityInfo.cityID = cityID;
            cityInfo.cityName = [dic objectForKey:@"cityname"];
            cityInfo.limittimearea = [dic objectForKey:@"limittimearea"];
            cityInfo.limitinfo = [dic objectForKey:@"limitinfo"];
            cityInfo.limitother = [dic objectForKey:@"limitother"] ;
            
//            cityInfo.limittimearea = [[dic objectForKey:@"limittimearea"] stringByReplacingOccurrencesOfString:KChangeLine withString:@"\n"];
            cityInfo.limitpush = [dic objectForKey:@"limitpush"];
//            cityInfo.limitinfo = [[dic objectForKey:@"limitinfo"] stringByReplacingOccurrencesOfString:KChangeLine withString:@"\n"];
//            cityInfo.limitother = [[dic objectForKey:@"limitother"] stringByReplacingOccurrencesOfString:KChangeLine withString:@"\n"];
            cityInfo.limitPicUrl = [dic objectForKey:@"limitareaimg"];
            cityInfo.isout = [[dic objectForKey:@"isout"] integerValue];
            cityInfo.limitplatenum = [dic objectForKey:@"limitplatenum"];
            cityInfo.transformletter = [dic objectForKey:@"transformletter"];
            [self.cityInfoDic setObject:cityInfo forKey:city];
            
            
            NSMutableArray *limits = [contentDic objectForKey:city];
            if (limits == nil) {
                limits = [NSMutableArray array];
                [contentDic setObject:limits forKey:city];
            }
            NSArray * limit = [dic objectForKey:@"limit"];
            [limits addObjectsFromArray:limit];
        }
    }
    return self;
}

+ (NSString *)getTodayDateWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM/dd cccc"];
    //用[NSDate date]可以获取系统当前时间
    NSMutableString *currentDateStr =  [NSMutableString stringWithString:[dateFormatter stringFromDate:[NSDate date]]];
//    NSRange r = [currentDateStr rangeOfString:@"星期"];
//    if (r.length > 0) {
//        [currentDateStr replaceCharactersInRange:r withString:@"周"];
//    }
    
    return currentDateStr;
}

+(LimitCityInfo *) cityInfo:(int) cityId{
    if (cityId == 0)
    {
        return nil;
    }
    NSString *city = [NSString stringWithFormat:@"%d", cityId];
    if (limitManager == nil) {
        limitManager = [[LimitNumManager alloc] init];
    }
    return [limitManager.cityInfoDic objectForKey:city];
}

+(NSString *) limitInfo:(NSInteger )cityId ForCar:(NSString *) carNo {
    if (cityId == 0)
    {
        return @"";
    }
    NSString *city = [NSString stringWithFormat:@"%d", cityId];
    if (limitManager == nil) {
        limitManager = [[LimitNumManager alloc] init];
    }
    NSArray * array = [limitManager.contentDic objectForKey:city];
    if (array == nil ) {
        return @"";
    }
    
    LimitCityInfo *cityInfo = [[limitManager cityInfoDic] objectForKey:city];
    NSString *localCarNORule = cityInfo.limitplatenum;
    NSArray *carNumArray = [localCarNORule componentsSeparatedByString:@","];
    BOOL islocal = NO;
    for (NSString *car in carNumArray) {
        NSRange r = [carNo rangeOfString:car];
        if (r.length != 0 && r.location == 0) {
            islocal = YES;
            break;
        }
    }
    //首字母不匹配
    if (islocal == NO ) {
        //0：不限制外地车 1：外地车和本地车一样限行  2：外地车每天都限制
        if (cityInfo.isout == 0) {
            return @"";
        } else if(cityInfo.isout == 2){
            return @"今日限行";
        }
    }

    NSString *weihao = [carNo substringFromIndex:carNo.length - 1];
    NSString *nums = @"0123456789";
    NSRange r = [nums rangeOfString:weihao];
    //transformletter为a时，取最后一位数字做尾号
    if ([cityInfo.transformletter isEqualToString:@"a"] || [cityInfo.transformletter isEqualToString:@"A"]) {
        int index = carNo.length - 1;
        while (r.length == 0 && index > 0) {
            index--;
            weihao = [carNo substringWithRange:NSMakeRange(index, 1)];
            r = [nums rangeOfString:weihao];
        }
    } else {
        if (r.length == 0) {
            weihao = cityInfo.transformletter;
            if ([cityInfo.transformletter isKindOfClass:[NSNumber class]]) {
                weihao = [NSString stringWithFormat:@"%d", [cityInfo.transformletter intValue]];
            }
        }
    }

    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:now];
    NSArray *resltArray1 = nil;
    for (NSDictionary * dic in array) {
        if ([today isEqualToString:[dic objectForKey:@"date"]]) {
            resltArray1 = [dic objectForKey:@"nums"];
        }
    }
    for (NSString * str in resltArray1) {
        NSString *tmpstr = str;
        if ([tmpstr isKindOfClass:[NSNumber class]]) {
            tmpstr = [NSString stringWithFormat:@"%d", tmpstr.integerValue];
        }
        
        if ([tmpstr isEqualToString:@"单号"]) {
            NSString *text = @"13579";
            NSRange r = [text rangeOfString:weihao];
            if (r.length != 0) {
                return @"今日限行";
            }
        } else if([tmpstr isEqualToString:@"双号"]){
            NSString *text = @"24680";
            NSRange r = [text rangeOfString:weihao];
            if (r.length != 0) {
                return @"今日限行";
            }
        }
        else
        {
            NSRange r = [tmpstr rangeOfString:weihao];
            if (r.length != 0) {
                return @"今日限行";
            }
        }
    }
    
    NSString *tomorrw = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:now]];
    for (NSDictionary * dic in array) {
        if ([tomorrw isEqualToString:[dic objectForKey:@"date"]]) {
            resltArray1 = [dic objectForKey:@"nums"];
        }
    }
    for (NSString * str in resltArray1) {
        NSString *tmpstr = str;
        if ([tmpstr isKindOfClass:[NSNumber class]]) {
            tmpstr = [NSString stringWithFormat:@"%d", tmpstr.integerValue];
        }
        if ([tmpstr isEqualToString:@"单号"]) {
            NSString *text = @"13579";
            NSRange r = [text rangeOfString:weihao];
            if (r.length != 0) {
                return @"明日限行";
            }
        } else if([tmpstr isEqualToString:@"双号"]){
            NSString *text = @"24680";
            NSRange r = [text rangeOfString:weihao];
            if (r.length != 0) {
                return @"明日限行";
            }
        } else
        {
            NSRange r = [tmpstr rangeOfString:weihao];
            if (r.length != 0) {
                return @"明日限行";
            }
        }
    }
    return @"";
}

+(NSString *) getLimitNumByCity:(int) cityId date:(NSDate *) date{
    if (cityId == 0)
    {
        return @"";
    }
    NSString *city = [NSString stringWithFormat:@"%d", cityId];
    if (limitManager == nil) {
        limitManager = [[LimitNumManager alloc] init];
    }
    NSArray * array = [limitManager.contentDic objectForKey:city];
    if (array == nil ) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:date];
    NSArray *resltArray1 = nil;
    for (NSDictionary * dic in array) {
        if ([today isEqualToString:[dic objectForKey:@"date"]]) {
            resltArray1 = [dic objectForKey:@"nums"];
        }
    }
    //未找到  GetAppInfoService重新请求
    if (resltArray1 == nil) {
        [[TRAppDelegate appDelegate].appInfo getAppInfo];
        return @"不限行";
    }
    NSMutableString *restSting = [NSMutableString string];
    if(resltArray1.count == 0){
        [restSting appendString:@"不限行"];
    } else {
        for (NSString * str in resltArray1) {
            NSString *tmpstr = str;
            if ([tmpstr isKindOfClass:[NSNumber class]]) {
                tmpstr = [NSString stringWithFormat:@"%d", tmpstr.integerValue];
            }
            //4  9
            if (restSting.length > 0) {
                [restSting appendString:@"/"];
            }
            [restSting appendString:tmpstr];
        }
    }
    return restSting;
}

+(NSString *) getLimitNumByCity:(int) cityId{
    if (cityId == 0)
    {
        return nil;
    }
    NSString *city = [NSString stringWithFormat:@"%d", cityId];
    if (limitManager == nil) {
        limitManager = [[LimitNumManager alloc] init];
    }
    NSArray * array = [limitManager.contentDic objectForKey:city];
    if (array == nil ) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSString *today = [dateFormatter stringFromDate:now];
    NSArray *resltArray1 = nil;
    for (NSDictionary * dic in array) {
        if ([today isEqualToString:[dic objectForKey:@"date"]]) {
            resltArray1 = [dic objectForKey:@"nums"];
        }
    }
    //未找到  
    if (resltArray1 == nil) {
        return @"不限行";
    }
    NSMutableString *restSting = [NSMutableString string];
    if(resltArray1.count == 0){
        [restSting appendString:@"不限行"];
    } else {
        for (NSString * str in resltArray1) {
            NSString *tmpstr = str;
            if ([tmpstr isKindOfClass:[NSNumber class]]) {
                tmpstr = [NSString stringWithFormat:@"%d", tmpstr.integerValue];
            }
            //4  9
            if (restSting.length > 0) {
                [restSting appendString:@"  "];
            }
            [restSting appendString:tmpstr];
        }
    }
    return restSting;
}

+(void) resetGlobObject{
    limitManager = nil;
}

@end
