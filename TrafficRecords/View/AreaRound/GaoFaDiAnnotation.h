//
//  GaoFaDiAnnotation.h
//  TrafficRecords
//
//  Created by qiao on 14-8-12.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface GaoFaDiAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, assign) BOOL     isHigh;

@property(nonatomic, strong) NSString *location;
@property(nonatomic, assign) int wz_count;
@property(nonatomic, strong) NSArray *contents;

@end
