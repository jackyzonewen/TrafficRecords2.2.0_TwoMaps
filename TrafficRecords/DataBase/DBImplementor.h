//
//  DBImplementor.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBImplementor : NSObject

-(BOOL) excuteUpdate:(NSString *) sqlUpdate;
-(NSMutableArray *) excuteQuery: (NSString *) sqlQuery;
-(void) excuteUpdates:(NSArray *) sqlUpdates;
-(BOOL) isTransactionInProgress;
//将数据库中的tables所有的数据导成sql语句
-(NSArray *)getAllDataAsSql:(NSArray *) tables;
//同步批量更新数据库
-(void) synExcuteUpdates:(NSArray *) sqlUpdates;
@end
