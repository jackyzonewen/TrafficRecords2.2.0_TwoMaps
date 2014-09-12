//
//  ChangAuthCodeService.m
//  TrafficRecords
//
//  Created by qiao on 13-12-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "ChangAuthCodeService.h"

@implementation ChangAuthCodeService

@synthesize authCode;
@synthesize authinfo;

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceChangeAuthCode;
		return self;
	}
    return nil;
}

-(void) changeService:(NSString *)carId city:(NSString *)cityId{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getcaptcha.ashx?carid=%@&cityid=%@", KServerHost, carId, cityId];
    [self getData:url];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSData *data = [TRUtility dataWithBase64EncodedString:[result objectForKey:@"authimage"]];
    self.authCode = [UIImage imageWithData:data];
    self.authinfo = [result objectForKey:@"authinfo"];
    
    return YES;
}

@end
