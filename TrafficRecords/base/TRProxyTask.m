//
//  TRProxyTask.m
//  TrafficRecords
//
//  Created by qiao on 14-8-6.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRProxyTask.h"
#import "CarInfo.h"
#import "TrafficRecord.h"
#import "TRAutherAlertView.h"

@implementation TRProxyTask

@synthesize taskID;
@synthesize carID;
@synthesize cityId;
@synthesize taskHost;
@synthesize taskPort;
@synthesize taskData;
@synthesize responseData;
@synthesize state;
@synthesize taskDelegate;
@synthesize step;
@synthesize authimage;
@synthesize authInfo;

+(TRProxyTask *) taskWithNSDictionary:(NSDictionary *) dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    TRProxyTask *task = [[TRProxyTask alloc] init];
    task.taskID = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"taskid"] intValue]];
    task.carID = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"carid"] intValue]];
    task.cityId = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"cityid"] intValue]];
    task.step = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"step"] intValue]];
    task.taskData = [TRUtility dataWithBase64EncodedString:[dic objectForKey:@"postdada"]];
    task.taskHost = [dic objectForKey:@"host"];
    task.taskPort = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"port"] intValue]];
    NSString *imagestr = [dic objectForKey:@"authimage"];
    task.authimage =  [UIImage imageWithData:[TRUtility dataWithBase64EncodedString:imagestr]];
    return task;
}

-(id) init {
    self = [super init];
    if (self) {
        cleint = [[AsyncSocket alloc] initWithDelegate:self];
        [cleint setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        taskHttpService = [[AHTaskService alloc] init];
        taskHttpService.delegate = self;
    }
    return self;
}

-(void) dealloc{
    if (currentAlertView) {
        [currentAlertView endLoading];
        [currentAlertView removeFromSuperview];
        currentAlertView = nil;
    }
    [cleint setDelegate:nil];
    [cleint disconnect];
    cleint=nil;
}

-(void) startTask{
    if (taskHost.length == 0 || taskData.length == 0) {
        return;
    }
    [MobClick event:@"client_proxy" label:cityId];
    NSError *error;
    BOOL connectRes;
    if (taskPort.length == 0) {
        connectRes = [cleint  connectToHost:taskHost onPort:80 withTimeout:30 error:&error ];
    } else {
        connectRes = [cleint  connectToHost:taskHost onPort:taskPort.intValue withTimeout:30 error:&error ];
    }
    state = ETaskScoketConnecting;
    if (error != nil || !connectRes) {
        [cleint disconnect];
        state = ETaskScoketErr;
        if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
            if (error == nil) {
                error = [NSError errorWithDomain:@"connect failed" code:state userInfo:nil];
            }
            [taskDelegate onTaskFinshed:self withErr:error];
        }
    }
}

#pragma mark -
#pragma mark Socket Methods

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    responseData = nil;//清空responseData
    [cleint readDataWithTimeout:-1 tag:0];
    [self sendData];
}

-(void) sendData{
//        NSString *str = @"POST http://api.chexingle.com:3000/querytraffic HTTP/1.1\r\nHost: api.chexingle.com:3000\r\nConnection: keep-alive\r\nContent-Length: 94\r\nOrigin: http://api.chexingle.com:3000\r\nX-Requested-With: XMLHttpRequest\r\nUser-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1\r\nContent-Type: application/x-www-form-urlencoded; charset=UTF-8\r\nAccept: */*\r\nReferer: http://api.chexingle.com:3000/\r\nAccept-Encoding: gzip,deflate,sdch\r\nAccept-Language: zh-CN,zh;q=0.8\r\nAccept-Charset: GBK,utf-8;q=0.7,*;q=0.3\r\n\r\nqueryid=VS&hpzl=02&hphm=%E8%B1%ABA1290W&clsbdh=016377&sfzmhm=&dabh=&xm=&cxlb=0&date_s=&date_e=";
    state = ETaskScoketSending;
    NSString *sendStr = [[NSString alloc] initWithData:taskData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", sendStr);
    [cleint writeData:taskData withTimeout:50 tag:1001];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    if (err != nil) {
        state = ETaskScoketErr;
        if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
            [taskDelegate onTaskFinshed:self withErr:err];
        }
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    if (responseData == nil || state != ETaskScoketSending) {
        state = ETaskScoketErr;
        if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
            [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:@"Disconnect without correct data" code:state userInfo:nil]];
        }
    } else {
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* pageSource = [[NSString alloc] initWithData:responseData encoding:gbkEncoding];
        if (pageSource == nil) {
            pageSource = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@", pageSource);
        state = ETaskScoketFinshed;
        trycount++;
        if (trycount > 10) {
            [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:@"次数超过上限" code:state userInfo:nil]];
        } else {
            [taskHttpService task:self.taskID uploaddata:responseData car:carID city:cityId step:step];
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [cleint readDataWithTimeout:-1 tag:0];
    if (data.length > 0) {
        if (responseData == nil) {
            responseData = [[NSMutableData alloc] init];
        }
        [responseData appendData:data];
    }
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
     shouldTimeoutWriteWithTag:(long)tag
                       elapsed:(NSTimeInterval)elapsed
                     bytesDone:(NSUInteger)length{
    state = ETaskScoketErr;
    if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
        [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:@"Write data time out" code:state userInfo:nil]];
    }
    [cleint disconnect];
    return 0;
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)dealTrafficRecord:(NSDictionary *)carInfoDic {
    CarInfo *carM = nil;
    for (CarInfo * car in [CarInfo globCarInfo]) {
        if ([car.carid isEqualToString:carID]) {
            carM = car;
            break;
        }
    }
    if (carM == nil) {
        [iConsole warn:@"获取到本地不存在的carid=%@,该数据集被程序忽略", carID];
        return;
    }
    carM.status = [[carInfoDic objectForKey:@"carreturncode"] intValue];
    carM.statusMsg = [carInfoDic objectForKey:@"returnmessage"];
    BOOL unknownMoney = YES;
    BOOL unknownScore = YES;
    
    NSArray *citys = [carInfoDic objectForKey:@"citys"];
    if (citys.count > 0) {
        NSDictionary *cityDic =[citys objectAtIndex:0];
        NSString *timeStamp = [cityDic objectForKey:@"timestamp"];
        if ([timeStamp isKindOfClass:[NSNumber class]]) {
            timeStamp = [NSString stringWithFormat:@"%lld",[[cityDic objectForKey:@"timestamp"] longLongValue]];
        }
        CityOfCar *cityM = [carM getCityById:cityId];
        if (cityM == nil) {
            [iConsole warn:@"获取到本地不存在的cityId=%@,该数据集被程序忽略", cityId];
            return;
        }
        //如果时间戳不一致
        if (![cityM.timestamp isEqualToString:timeStamp] ) {
            cityM.timestamp = timeStamp;
            //解析违章数据，其中包括过往的所有已处理，未处理数据
            NSArray *recordArray = [cityDic objectForKey:@"violationdata"];
            if ([recordArray isKindOfClass:[NSNull class]]) {
                recordArray = [NSArray array];
            }
            NSMutableArray *newrecords = [NSMutableArray array];
            for (NSDictionary * recordDic in recordArray) {
                TrafficRecord *record = [TrafficRecord parseFromJson:recordDic];
                record.cityid = cityM.cityid;
                record.carid = carM.carid;
                [newrecords addObject:record];
            }
            //更新数据库中记录
            [TrafficRecord replacecar:carM.carid withCity:cityM.cityid inserRecords:newrecords];
            
            //将新数据同步到carinfo对象中
            NSArray *oldArray = [carM recordsOfCity:cityId];
            //删除掉内存中旧的数据
            [carM removeRecordsOfCity:cityId];
            for (TrafficRecord *record in newrecords) {
                //1为未处理,统计总分和总扣钱数；否则不显示且不统计
                if (record.processstatus == 1) {
                    [carM.trafficRecods addObject:record];
                    if (record.score >= 0) {
                        carM.totalScore += record.score;
                        unknownScore = NO;
                    }
                    if (record.money >= 0) {
                        carM.totalMoney += record.money;
                        unknownMoney = NO;
                    }
                }
                BOOL isNew = YES;
                for (TrafficRecord *oldrecord in oldArray) {
                    if ([oldrecord.recordid isEqualToString:record.recordid]) {
                        //减去旧违章所增加的扣分和罚款
                        if (oldrecord.score >= 0) {
                            carM.totalScore -= oldrecord.score;
                        }
                        if (oldrecord.money >= 0) {
                            carM.totalMoney -= oldrecord.money;
                        }
                        isNew = NO;
                        break;
                    }
                }
                record.isNew = isNew;
                if (isNew) {
                    carM.totalNew ++;
                }
            }
        } else { //时间戳一致,则将所有记录isnew置为no
            for (TrafficRecord *record in carM.trafficRecods) {
                if ([cityId isEqualToString:record.cityid]) {
                    record.isNew = NO;
                    if (record.money >= 0) {
                        carM.totalMoney += record.money;
                        unknownMoney = NO;
                    }
                    if (record.score >= 0) {
                        carM.totalScore += record.score;
                        unknownScore = NO;
                    }
                }
            }
        }
        //更新城市数据库
        [carM updateCity:cityM];
    }
    
    if (carM.trafficRecods.count > 0 ) {
        carM.unknownMoney = unknownMoney;
        carM.unknownScore = unknownScore;
    } else {
        carM.unknownScore = NO;
        carM.unknownScore = NO;
    }
    
    //所有城市结果处理完成，将结果集按time排序
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSArray *sortArray = [carM.trafficRecods sortedArrayUsingComparator: ^NSComparisonResult(id a, id b){
        NSString *str1 =  ((TrafficRecord *) a).time;
        NSString *str2 =  ((TrafficRecord *) b).time;
        NSDate *date1 = [dateFormatter dateFromString:str1];
        NSDate *date2 = [dateFormatter dateFromString:str2];
        if (date1 && date2) {
            return [date2 compare:date1];
        } else {
            return [str2 compare:str1];
        }
    }];
    carM.trafficRecods = [NSMutableArray arrayWithArray:sortArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    NSDictionary *dic = taskHttpService.responseDic;
    dic = [dic objectForKey:@"result"];
    NSArray *items = [dic objectForKey:@"items"];

    NSArray *tasks = [dic objectForKey:@"taskitems"];
    if (tasks.count == 0) { //任务结束 
        if (currentAlertView) {
            [currentAlertView endLoading];
            [currentAlertView removeFromSuperview];
            currentAlertView = nil;
        }
        if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
            [taskDelegate onTaskFinshed:self withErr:nil];
        }
    } else {
        NSDictionary *taskDic = [tasks objectAtIndex:0];
        if (![taskDic isKindOfClass:[NSDictionary class]]) {
            if (currentAlertView) {
                [currentAlertView endLoading];
                [currentAlertView removeFromSuperview];
                currentAlertView = nil;
            }
            if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
                [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:@"错误的网络数据" code:state userInfo:nil]];
            }
            return;
        }
        self.carID = [NSString stringWithFormat:@"%d", [[taskDic objectForKey:@"carid"] intValue]];
        self.cityId = [NSString stringWithFormat:@"%d", [[taskDic objectForKey:@"cityid"] intValue]];
        self.step = [NSString stringWithFormat:@"%d", [[taskDic objectForKey:@"step"] intValue]];
        self.taskData = [TRUtility dataWithBase64EncodedString:[taskDic objectForKey:@"postdada"]];
        self.taskHost = [taskDic objectForKey:@"host"];
        self.taskPort = [NSString stringWithFormat:@"%d", [[taskDic objectForKey:@"port"] intValue]];
        NSString *imagestr = [taskDic objectForKey:@"authimage"];
        self.authInfo = [taskDic objectForKey:@"authinfo"];
        if (imagestr.length > 0) {// 进入验证码输入流程、提交流程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskShowAuth:)]) {
                    [taskDelegate onTaskShowAuth:self];
                }
                if (currentAlertView) {
                    [currentAlertView endLoading];
                    [currentAlertView removeFromSuperview];
                    currentAlertView = nil;
                }
                self.authimage =  [UIImage imageWithData:[TRUtility dataWithBase64EncodedString:imagestr]];
                TRAutherAlertView *alertView = [[TRAutherAlertView alloc] initWithImage:self.authimage];
//                alertView.textField.delegate = self;
//                alertView.carId = authCarId;
//                alertView.cityId = authCityId;
//                alertView.carInfoNew = info;
//                alertView.textField.placeholder = authInfo;
//                if (newCarId != carId) {
//                    alertView.modifyCarId = [NSString stringWithFormat:@"%d", carId];
//                }
                if (authInfo.length > 0) {
                    alertView.textField.placeholder = authInfo;
                }
                currentAlertView = alertView;
                [alertView.okBtn removeTarget:alertView action:nil forControlEvents:UIControlEventTouchUpInside];
                [alertView.okBtn addTarget:self action:@selector(TRAutherAlertViewOKClicked:) forControlEvents:UIControlEventTouchUpInside];
                [alertView.changBtn removeTarget:alertView action:nil forControlEvents:UIControlEventTouchUpInside];
                [alertView.changBtn addTarget:self action:@selector(TRAutherAlertViewchangeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [alertView.cancelBtn addTarget:self action:@selector(TRAutherAlertViewDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                CarInfo *carM = nil;
                for (CarInfo * car in [CarInfo globCarInfo]) {
                    if ([car.carid isEqualToString:carID]) {
                        carM = car;
                        break;
                    }
                }
                alertView.titleView.text = carM.carname.length > 0 ? carM.carname : carM.carnumber;
                [alertView show];
            });
        } else {
            // 进入下一步任务
            [self startTask];
        }
    }
    if (tasks.count == 0) {
        for (NSDictionary * carInfoDic in items) {
            [self dealTrafficRecord:carInfoDic];
        }
    }
    
}

-(void) TRAutherAlertViewOKClicked:(UIButton *) btn{
    NSString *text = currentAlertView.textField.text;
    if (text.length > 0) {
        [taskHttpService task:self.taskID uploadAuthcode:text car:carID city:cityId step:step];
        [currentAlertView startLoading];
    } else {
        [currentAlertView showHintView:@"请输入验证码"];
    }
}

-(void) TRAutherAlertViewchangeClicked:(UIButton *) btn{
    [taskHttpService task:self.taskID uploadAuthcode:@"-1" car:carID city:cityId step:step];
    [currentAlertView startLoading];
}

-(void) TRAutherAlertViewDeleteBtnClicked:(UIButton *) btn{
    currentAlertView = nil;
    if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
        [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:@"取消输入验证码" code:state userInfo:nil]];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    state = ETaskHttpErr;
    if (currentAlertView) {
        [currentAlertView endLoading];
        [currentAlertView removeFromSuperview];
        currentAlertView = nil;
    }
    if (taskDelegate && [taskDelegate respondsToSelector:@selector(onTaskFinshed:withErr:)]) {
        [taskDelegate onTaskFinshed:self withErr:[NSError errorWithDomain:errorMessage code:state userInfo:nil]];
    }
}

@end
