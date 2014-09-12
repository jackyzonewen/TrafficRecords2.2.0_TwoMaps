//
//  DBAbstraction.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBImplementor;

@interface DBAbstraction : NSObject

@property(nonatomic, strong) DBImplementor *implementor;

-(BOOL) excuteUpdate:(NSString *) sqlUpdate;
-(NSMutableArray *) excuteQuery: (NSString *) sqlQuery;
//异步批量更新数据库
-(void) excuteUpdates:(NSArray *) sqlUpdates;
//同步批量更新数据库
-(void) synExcuteUpdates:(NSArray *) sqlUpdates;


//将数据库中的tables所有的数据导成sql语句
-(NSArray *)getAllDataAsSql:(NSArray *) tables;

+(DBAbstraction *) sharedDBAbstraction;
+(DBAbstraction *) productionDBAbstraction;
@end
