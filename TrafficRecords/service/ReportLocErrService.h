//
//  ReportLocErrService.h
//  TrafficRecords
//
//  Created by qiao on 14-3-20.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface ReportLocErrService : AHServiceBase
{
}

-(void) reportErrMsg:(NSDictionary *)errDic;

@end
