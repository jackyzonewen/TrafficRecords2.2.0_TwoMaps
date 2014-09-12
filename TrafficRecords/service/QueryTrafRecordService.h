//
//  QueryTrafRecordService.h
//  TrafficRecords
//
//  Created by qiao on 13-9-10.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRTaskBaseService.h"

@interface QueryTrafRecordService : TRTaskBaseService

-(void) queryTrafRecord:(NSArray *) cars;
-(void) queryTrafRecordFromPush:(NSArray *) cars;
@end
