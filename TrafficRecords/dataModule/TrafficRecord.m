//
//  TrafficRecord.m
//  TrafficRecords
//
//  Created by qiao on 13-9-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TrafficRecord.h"
#import "DBAbstraction.h"

@implementation TrafficRecord

@synthesize recordid;
@synthesize content;
@synthesize location;
@synthesize money;
@synthesize processstatus;
@synthesize processstatusText;
@synthesize score;
@synthesize time;
@synthesize carid;
@synthesize cityid;
@synthesize isNew;

+(TrafficRecord *) parseFromJson:(NSDictionary *) dic{
    TrafficRecord *record = [[TrafficRecord alloc] init];
    record.recordid = [dic objectForKey:@"recordid"];
    if ([record.recordid isKindOfClass:[NSNumber class]] ) {
        record.recordid = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"recordid"] longValue]];
    }
    record.content = [dic objectForKey:@"content"];
    record.location = [dic objectForKey:@"location"];
    record.money = [[dic objectForKey:@"pay"] intValue];
    record.processstatus = [[dic objectForKey:@"processstatus"] intValue];
    record.processstatusText = [dic objectForKey:@"processstatustext"];
    record.score = [[dic objectForKey:@"score"] intValue];
    record.time = [dic objectForKey:@"time"];
    record.latitude = [[dic objectForKey:@"lat"] doubleValue];
    record.longitude = [[dic objectForKey:@"lng"] doubleValue];
    
    if ([record.location isKindOfClass:[NSNull class]]) {
        record.location = @"";
    }
    if ([record.content isKindOfClass:[NSNull class]]) {
        record.content = @"";
    }
    if ([record.time isKindOfClass:[NSNull class]]) {
        record.time = @"";
    }
    if ([record.processstatusText isKindOfClass:[NSNull class]]) {
        record.processstatusText = @"";
    }
    
    return record;
}

+(TrafficRecord *) recordFromDic:(NSDictionary *)dic{
    TrafficRecord *record = [[TrafficRecord alloc] init];
    record.recordid = [dic objectForKey:@"recordid"];
    record.content = [dic objectForKey:@"content"];
    record.location = [dic objectForKey:@"location"];
    record.money = [[dic objectForKey:@"money"] intValue];
    record.processstatus = [[dic objectForKey:@"processstatus"] intValue];
    record.processstatusText = [dic objectForKey:@"processstatusText"];
    record.score = [[dic objectForKey:@"score"] intValue];
    record.time = [dic objectForKey:@"time"];
    record.carid = [dic objectForKey:@"carid"];
    record.cityid = [dic objectForKey:@"cityid"];
    record.latitude = [[dic objectForKey:@"latitude"] doubleValue];
    record.longitude = [[dic objectForKey:@"longitude"] doubleValue];
    return record;
}

+(NSMutableArray *) getUnDealRecordsBy:(NSString *)carid with:(NSString *) cityid{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM trafficrecord where cityid=%@ and carid=%@ and processstatus=1", cityid, carid];
    NSArray * query = [[DBAbstraction productionDBAbstraction] excuteQuery:sql];
    NSMutableArray *rest = [NSMutableArray array];
    for (NSDictionary *dic in query) {
        [rest addObject:[TrafficRecord recordFromDic:dic]];
    }
    return rest;
}

+(void) replaceAllRecords:(NSArray *) records{
    NSMutableArray * sqls = [NSMutableArray array];
    for (TrafficRecord * rcd in records) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from trafficrecord where recordid=%@", rcd.recordid];
        NSString *sql = [NSString stringWithFormat:@"insert into trafficrecord(recordid, content, location, money, processstatus, processstatusText, score, time, carid, cityid, latitude, longitude) values('%@', '%@', '%@', '%d', '%d', '%@','%d', '%@','%@','%@', '%f', '%f')", rcd.recordid, rcd.content, rcd.location, rcd.money, rcd.processstatus, rcd.processstatusText, rcd.score, rcd.time, rcd.carid, rcd.cityid, rcd.latitude, rcd.longitude];
        [sqls addObject:deleteSql];
        [sqls addObject:sql];
    }
    [[DBAbstraction productionDBAbstraction] excuteUpdates:sqls];
}

+(void) replacecar:(NSString *)carid withCity:(NSString *)cityId inserRecords:(NSArray *) records{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from trafficrecord where cityid='%@' and carid='%@'",cityId ,carid ];
    NSMutableArray * sqls = [NSMutableArray array];
    [sqls addObject:deleteSql];
    for (TrafficRecord * rcd in records) {
        NSString *sql = [NSString stringWithFormat:@"insert into trafficrecord(recordid, content, location, money, processstatus, processstatusText, score, time, carid, cityid, latitude, longitude) values('%@', '%@', '%@', '%d', '%d', '%@','%d', '%@','%@','%@', '%f', '%f')", rcd.recordid, rcd.content, rcd.location, rcd.money, rcd.processstatus, rcd.processstatusText, rcd.score, rcd.time, rcd.carid, rcd.cityid, rcd.latitude, rcd.longitude];
        [sqls addObject:sql];
    }
    [[DBAbstraction productionDBAbstraction] excuteUpdates:sqls];
}
@end
