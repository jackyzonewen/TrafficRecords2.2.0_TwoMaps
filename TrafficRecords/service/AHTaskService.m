//
//  AHTaskService.m
//  TrafficRecords
//
//  Created by qiao on 14-8-6.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AHTaskService.h"

@implementation AHTaskService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isAddCache = NO;
//        self.isSafeTranfer = YES;
        self.reqTag = EServiceProxyTask;
		self.isShowNetHint = NO;
	}
	return self;
}

-(void) task:(NSString *)taskId uploaddata:(NSData *) data car:(NSString *) carid city:(NSString *) cityid step:(NSString *) step{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getviolationbyagent.ashx?carid=%@&cityid=%@&step=%@&taskid=%@", KServerHost, carid, cityid, step, taskId];
    url = [AHServiceBase addPublicPara:url];
    NSURL *_url =[NSURL URLWithString:url];
	self.request = [[ASIFormDataRequest alloc] initWithURL:_url];
    [self.request appendPostData:data];
    NSString *utf8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",utf8);
    [self.request addRequestHeader:@"USER_AGENT" value:KUserAgent];
    self.request.timeOutSeconds = 30;
    [self.request setShouldAttemptPersistentConnection:NO];
	[self.request setDelegate:self];
	[self.request setRequestMethod:@"POST"];
    [self.request startAsynchronous];
}

-(void) task:(NSString *)taskId uploadAuthcode:(NSString *) Auth car:(NSString *) carid city:(NSString *) cityid step:(NSString *) step{
    NSString * url = [NSString stringWithFormat:@"%@ashx/getviolationbyagent.ashx?carid=%@&cityid=%@&step=%@&taskid=%@&authcode=%@", KServerHost, carid, cityid, step, taskId, [TRUtility URLEncodedString:Auth]];
    [self getData:url];
    
//    url = [AHServiceBase addPublicPara:url];
//    NSURL *_url =[NSURL URLWithString:url];
//	self.request = [[ASIFormDataRequest alloc] initWithURL:_url];
////    [self.request appendPostData:data];
////    NSString *utf8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////    NSLog(@"%@",utf8);
//    [self.request addRequestHeader:@"USER_AGENT" value:KUserAgent];
//    self.request.timeOutSeconds = 30;
//    [self.request setShouldAttemptPersistentConnection:NO];
//	[self.request setDelegate:self];
//	[self.request setRequestMethod:@"POST"];
//    [self.request startAsynchronous];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    return YES;
}
@end
