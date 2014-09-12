//
//  TRProxyTask.h
//  TrafficRecords
//
//  Created by qiao on 14-8-6.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "AHTaskService.h"

@class TRProxyTask;
@class TRAutherAlertView;

typedef enum : NSUInteger {
    ETaskScoketConnecting = 1000,
    ETaskScoketSending,
    ETaskScoketFinshed,
    ETaskScoketErr,
    ETaskHttpTransfer,
    ETaskHttpErr
} TaskState;


@protocol TRProxyTaskDelegate <NSObject>
@optional
-(void) onTaskFinshed:(TRProxyTask *)task withErr:(NSError *)error;
-(void) onTaskShowAuth:(TRProxyTask *)task;
@end

@interface TRProxyTask : NSObject<AsyncSocketDelegate, AHServiceDelegate>
{
    AsyncSocket         *cleint;
    AHTaskService       *taskHttpService;
    int                 trycount;
    TRAutherAlertView   *currentAlertView;
}
@property(nonatomic, strong) NSString *taskID;
@property(nonatomic, strong) NSString *carID;
@property(nonatomic, strong) NSString *cityId;
@property(nonatomic, strong) NSString *step;
@property(nonatomic, strong) NSString *taskHost;
@property(nonatomic, strong) NSString *taskPort;
@property(nonatomic, strong) NSData *taskData;
@property(nonatomic, strong) UIImage *authimage;
@property(nonatomic, strong) NSString *authInfo;

@property(nonatomic, readonly, strong) NSMutableData *responseData;
@property(nonatomic, assign) TaskState state;
@property(nonatomic, weak) id<TRProxyTaskDelegate> taskDelegate;
-(void) startTask;

+(TRProxyTask *) taskWithNSDictionary:(NSDictionary *) dic;

@end
