//
//  GaoFaDiService.m
//  TrafficRecords
//
//  Created by qiao on 14-8-12.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GaoFaDiService.h"

@implementation GaoFaDiService
@synthesize points;
- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
        self.isSafeTranfer = YES;
        self.reqTag = EServiceGaofadi;
		self.isShowNetHint = YES;
	}
	return self;
}

-(void) GaofadiAtlat:(double) lat lng:(double) lng{
    NSString * url = [NSString stringWithFormat:@"%@ashx/hvlocation.ashx?lat=%f&lng=%f", KServerHost, lat, lng];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    self.points = [result objectForKey:@"points"];
    return YES;
}
@end
