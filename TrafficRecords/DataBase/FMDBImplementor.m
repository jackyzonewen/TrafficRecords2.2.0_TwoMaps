//
//  FMDBImplementor.m
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "FMDBImplementor.h"

@implementation FMDBImplementor

-(id) initWithPath:(NSString *) path{
    if (self = [super init]) {
        dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    }
    return self;
}

-(BOOL) excuteUpdate:(NSString *) sqlUpdate{
    __block BOOL rest = NO;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
         rest = [db executeUpdate:sqlUpdate];
    }];
    if (!rest) {
        NSLog(@"数据库执行失败：%@", sqlUpdate);
    }
    return rest;
}

//将数据库中的tables所有的数据导成sql语句
-(NSArray *)getAllDataAsSql:(NSArray *) tables{
    __block NSMutableArray * rest = [NSMutableArray array];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString * tableName in tables) {
            @autoreleasepool {
//            @"insert into cityinfo(cityid, carid, timestamp, authovertime, authurl) values('%@', '%@', '%@', '%@', '%@')"
                NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
                FMResultSet *set = [db executeQuery:sql];
                while ([set next]) {
                    NSDictionary *dic = [set resultDictionary];
                    NSMutableString * str1 = [NSMutableString stringWithString:@"("];
                    NSMutableString * str2 = [NSMutableString stringWithString:@"("];
                    for (NSString * key in [dic allKeys]) {
                        
                        NSObject *obj = [dic objectForKey:key];
                        [str1 appendString:key];
                        [str2 appendFormat:@"'%@'", [obj isKindOfClass:[NSNull class]] ? @"":obj];
                        if ([dic allKeys].lastObject == key) {
                            [str1 appendString:@")"];
                            [str2 appendString:@")"];
                        } else {
                            [str1 appendString:@","];
                            [str2 appendString:@","];
                        }
                    }
                    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ %@ values %@", tableName, str1, str2];
                    [rest addObject:insertSql];
                }
            }
        }
    }];
    return rest;
}

-(void) excuteUpdates:(NSArray *) sqlUpdates{
    //异步执行更新
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (NSString * sql in sqlUpdates) {
                BOOL reslt = [db executeUpdate:sql];
                if (!reslt) {
                    NSLog(@"数据库执行失败：%@", sql);
                }
            }
        }];
    });
}

//同步批量更新数据库
-(void) synExcuteUpdates:(NSArray *) sqlUpdates{
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString * sql in sqlUpdates) {
            BOOL reslt = [db executeUpdate:sql];
            if (!reslt) {
                NSLog(@"数据库执行失败：%@", sql);
            }
        }
    }];
}

-(NSMutableArray *) excuteQuery: (NSString *) sqlQuery{
    __block NSMutableArray * rest = [NSMutableArray array];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *set = [db executeQuery:sqlQuery];
        while ([set next]) {
            [rest addObject:[set resultDictionary]];
        }
    }];
    return rest;
}

-(BOOL) isTransactionInProgress{
    FMDatabase *db = [dbQueue getDB];
    NSLog(@"[db isInUse] = %d", [db isInUse]);
    if ([db isInUse]) {
        return YES;
    } else {
        return NO;
    }
}
@end
