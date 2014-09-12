//
//  TRTaskBaseService.m
//  TrafficRecords
//
//  Created by qiao on 14-8-11.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRTaskBaseService.h"
#import "JSON.h"

@implementation TRTaskBaseService

- (void)requestStarted:(ASIHTTPRequest *)request{
    [super requestStarted:request];
    //延长超时时间
    request.timeOutSeconds = 90;
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    @try {
        NSString * response = aRequest.responseString;
        NSLog(@"%@", response);
        NSDictionary *dic = [response JSONValue];
        self.responseDic = dic;
        if (dic == nil)
        {
            //如果不是一个有效的json数据，则认为是出错了
            [self notifyNetServiceError:self.reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
            return;
        }
        
        int successFlag = [[dic valueForKey:@"returncode"] intValue];
        //时间戳超出误差范围
        if (successFlag == -71 && self.isSafeTranfer) {
            if (timeErrCount >= 1) {
                [self notifyNetServiceError:self.reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                timeErrCount++;
                NSString *serverTime = [AHServiceBase getServerTime];
                NSTimeInterval localTime = [[NSDate date] timeIntervalSince1970];
                NSTimeInterval timeDetal = [serverTime floatValue] - localTime;
                if (serverTime.length == 0) {
                    timeDetal = 0;
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (int)timeDetal] forKey:KLocalServerTimeDelta];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [parasDic setObject:[NSString stringWithFormat:@"%d", (int)(timeDetal + localTime)] forKey:@"_timestamp"];
                NSString *md5 = [self md5EncodeParas:parasDic];
                
                NSString *url = aRequest.url.absoluteString;
                NSRange range = [url rangeOfString:@"?"];
                NSString *parastr = [url substringFromIndex:range.location + range.length];
                url = [url substringToIndex:range.location + range.length];
                NSArray *array = [parastr componentsSeparatedByString:@"&"];
                for (NSString *str in array) {
                    if ([str hasPrefix:@"_timestamp"]) {
                        url = [url stringByAppendingFormat:@"&_timestamp=%@", [NSString stringWithFormat:@"%d", (int)(timeDetal + localTime)]];
                    } else if([str hasPrefix:@"_sign"]){
                        url = [url stringByAppendingFormat:@"&_sign=%@", md5];
                    } else {
                        url = [url stringByAppendingFormat:@"&%@", str];
                    }
                }
                [aRequest redirectToURL:[NSURL URLWithString:url]];
            });
            return;
        }
        if (0 != successFlag)
        {
            
            //如果服务器返回错误的代码，则处理为出错
            [self notifyNetServiceError:self.reqTag errorCode:successFlag errorMessage:[dic valueForKey:@"message"]];
            return;
        }
        
        if (self.isAddCache)
        {
            if ([dic isKindOfClass:[NSDictionary class]])
            {
                //添加缓存
                if (self.cacheKey.length > 0) {
                    [[EGOCache globalCache] setString:response forKey:self.cacheKey withTimeoutInterval:self.cacheTime];
                } else {
                    NSString *md5 = [TRUtility md5Value:aRequest.url.absoluteString];
                    [[EGOCache globalCache] setString:response forKey:md5 withTimeoutInterval:self.cacheTime];
                }
            }
        }
        if ([self parseJSON:self.responseDic])
        {
            [self startTasks];
        }
        else
        {
            [self notifyNetServiceError:self.reqTag errorCode:successFlag errorMessage:NETPARSER_BAD];
        }
    }
    @catch (NSException *exception) {
        //解析出错，把错误传递出去
        [self notifyNetServiceError:self.reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
    }
}


-(void) startTasks{
    if (taskList.count == 0) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:)])
        {
            [self.delegate netServiceFinished:self.reqTag];
        }
    } else {
        for (TRProxyTask *task in taskList) {
            task.taskDelegate = self;
            [task startTask];
        }
    }
}


///
-(void) onTaskShowAuth:(TRProxyTask *)task{
    if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceContinueWtihTask:)])
    {
        [self.delegate netServiceContinueWtihTask:self.reqTag];
    }
}

-(void) onTaskFinshed:(TRProxyTask *)task withErr:(NSError *)error{
    if (error) {
        NSLog(@"任务失败：taskid = %@，%@",task.carID, error);
    } else {
        sucessCount++;
    }
    [taskList removeObject:task];
    if (taskList.count == 0) {
        if (sucessCount >= needSucessCount ) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:)])
            {
                [self.delegate netServiceFinished:self.reqTag];
            }
        } else {
            if (self.isShowNetHint){
                [self showHintView:@"网络请求失败，请重试"];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(netServiceError:errorCode:errorMessage:)] ) {
                [self.delegate netServiceError:self.reqTag errorCode:-1 errorMessage:@""];
            }
        }
    }
}

@end
