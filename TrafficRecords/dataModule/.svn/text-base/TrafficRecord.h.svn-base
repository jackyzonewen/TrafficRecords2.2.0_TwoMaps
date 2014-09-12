//
//  TrafficRecord.h
//  TrafficRecords
//
//  Created by qiao on 13-9-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficRecord : NSObject

@property (nonatomic, strong) NSString *recordid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) int   money;
@property (nonatomic, assign) int   processstatus;
@property (nonatomic, strong) NSString *processstatusText;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *carid;
@property (nonatomic, strong) NSString *cityid;
@property (nonatomic, assign) BOOL   isNew;
//经度
@property (nonatomic, assign) double  longitude;
//纬度
@property (nonatomic, assign) double   latitude;

+(TrafficRecord *) parseFromJson:(NSDictionary *) dic;
+(TrafficRecord *) recordFromDic:(NSDictionary *)dic;
+(NSMutableArray *) getUnDealRecordsBy:(NSString *)carid with:(NSString *) cityid;
+(void) replaceAllRecords:(NSArray *) records;
+(void) replacecar:(NSString *)carid withCity:(NSString *)cityId inserRecords:(NSArray *) records;
@end
