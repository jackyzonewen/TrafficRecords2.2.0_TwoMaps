//
//  FMDBImplementor.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "DBImplementor.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface FMDBImplementor : DBImplementor{
    FMDatabaseQueue             *dbQueue;
}

-(id) initWithPath:(NSString *) path;

@end
