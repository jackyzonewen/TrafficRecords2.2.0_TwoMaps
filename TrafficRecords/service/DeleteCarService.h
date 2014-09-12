//
//  DeleteCarService.h
//  TrafficRecords
//
//  Created by qiao on 13-9-26.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface DeleteCarService : AHServiceBase

-(void) deleteCarWithJson:(NSDictionary *) deleteDic;
@end
