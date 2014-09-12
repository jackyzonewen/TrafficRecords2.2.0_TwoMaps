//
//  AddAuthCodeServices.h
//  TrafficRecords
//
//  Created by qiao on 13-10-18.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRTaskBaseService.h"

@interface AddAuthCodeServices : AHServiceBase

-(void) queryTrafRecord:(NSString *) jsonText;

@end
