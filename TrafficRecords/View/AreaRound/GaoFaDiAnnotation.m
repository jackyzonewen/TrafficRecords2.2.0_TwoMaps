//
//  GaoFaDiAnnotation.m
//  TrafficRecords
//
//  Created by qiao on 14-8-12.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GaoFaDiAnnotation.h"

@implementation GaoFaDiAnnotation

@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize isHigh;
@synthesize location;
@synthesize wz_count;
@synthesize contents;

-(NSString *) title{
    return title;
}

-(NSString *) subtitle{
    return subtitle;
}

@end
