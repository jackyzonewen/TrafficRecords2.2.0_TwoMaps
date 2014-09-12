//
//  RegDevicesTokenService.h
//  TrafficRecords
//
//  Created by qiao on 14-3-7.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface RegDevicesTokenService : AHServiceBase

-(void) regDevicesToken:(NSString *) token UID:(NSString *) userId;

@end
