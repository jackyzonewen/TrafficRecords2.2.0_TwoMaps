//
//  FAQService.m
//  TrafficRecords
//
//  Created by qiao on 14-6-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "FAQService.h"

@implementation FAQService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isShowNetHint = NO;
        self.isUserKnow = NO;
        self.isAddCache = NO;
        self.isSafeTranfer = YES;
        self.reqTag = EServiceGetFAQList;
		
	}
	return self;
}

-(void) getFaqListData{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getwztips.ashx?", KServerHost];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString *responseText = self.request.responseString;
    [TRUtility writecontent:responseText toFile:KFAQSaveFileName];
    return YES;
}

@end
