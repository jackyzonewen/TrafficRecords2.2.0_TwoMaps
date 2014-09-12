//
//  GetOfficeInfoService.h
//  TrafficRecords
//
//  Created by qiao on 14-3-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface GetOfficeInfoService : AHServiceBase
{
}
@property (nonatomic, strong) NSArray *items;

-(void) getOfficeInfoByCity:(int) cityId;
-(NSArray *) getCacheItemsByCity:(int) cityId;
@end
