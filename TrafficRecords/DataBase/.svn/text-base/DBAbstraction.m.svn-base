//
//  DBAbstraction.m
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "DBAbstraction.h"
#import "DBImplementor.h"

static DBAbstraction * globDBInstance = nil;
static DBAbstraction * productionDBInstance = nil;

@implementation DBAbstraction

@synthesize implementor;

-(BOOL) excuteUpdate:(NSString *) sqlUpdate{
    if (implementor) {
        return [implementor excuteUpdate:sqlUpdate];
    }
    [iConsole warn:@"执行%@失败,请初始化implementor实例", sqlUpdate];
    return NO;
}

-(void) excuteUpdates:(NSArray *) sqlUpdates{
    if (implementor) {
        [implementor excuteUpdates:sqlUpdates];
    }
}

//同步批量更新数据库
-(void) synExcuteUpdates:(NSArray *) sqlUpdates{
    if (implementor) {
        [implementor synExcuteUpdates:sqlUpdates];
    }
}

-(NSMutableArray *) excuteQuery: (NSString *) sqlQuery{
    if (implementor) {
        return [implementor excuteQuery:sqlQuery];
    }
    [iConsole warn:@"执行%@失败,请初始化implementor实例", sqlQuery];
    return nil;
}

//将数据库中的tables所有的数据导成sql语句
-(NSArray *)getAllDataAsSql:(NSArray *) tables{
    if (implementor) {
        return [implementor getAllDataAsSql:tables];
    }
    return nil;
}

+(DBAbstraction *) sharedDBAbstraction {
    if (globDBInstance == nil) {
        globDBInstance = [[DBAbstraction alloc] init];
    }
    return globDBInstance;
}

+(DBAbstraction *) productionDBAbstraction{
    if (productionDBInstance == nil) {
        productionDBInstance = [[DBAbstraction alloc] init];
    }
    return productionDBInstance;
}

@end
