//
//  AHTaskService.h
//  TrafficRecords
//
//  Created by qiao on 14-8-6.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface AHTaskService : AHServiceBase

-(void) task:(NSString *)taskId uploaddata:(NSData *) data car:(NSString *) carid city:(NSString *) cityid step:(NSString *) step;
-(void) task:(NSString *)taskId uploadAuthcode:(NSString *) Auth car:(NSString *) carid city:(NSString *) cityid step:(NSString *) step;

@end
