//
//  POISearchService.h
//  TrafficRecords
//
//  Created by qiao on 14-7-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface POISearchService : AHServiceBase

-(void) getPOIByType:(NSInteger) type City:(NSInteger) cityID;
-(void) get4SPOIByCity:(NSInteger) cityID;

@end
