//
//  LuKuangCity.h
//  TrafficRecords
//
//  Created by qiao on 14-4-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "Area.h"
#import <MapKit/MapKit.h>

@interface LuKuangCity : City

@property (nonatomic, assign) CLLocationCoordinate2D centerCoord;
@property (nonatomic, assign) float                  zoomLevel;
@property (nonatomic, assign) BOOL                   supportLuKuang;

-(NSString *) toJsonString;
-(id) initWithJsonStr:(NSString *) json;

+(LuKuangCity *) getLuKuangCityById:(int) cityId;
+(LuKuangCity *) getLuKuangCityByKeyWord:(NSString*) cityName;
+(void) releaseShareDic;
@end
