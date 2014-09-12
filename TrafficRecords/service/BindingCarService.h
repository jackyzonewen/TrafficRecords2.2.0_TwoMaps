//
//  BindingCarService.h
//  TrafficRecords
//
//  Created by 张小桥 on 13-12-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface BindingCarService : AHServiceBase

@property(nonatomic, strong) NSString * toBindingCars;
@property(nonatomic, strong) NSString * carTimeStamp;

-(void) binding:(NSString *) userId withCars:(NSString *) cars;

@end
