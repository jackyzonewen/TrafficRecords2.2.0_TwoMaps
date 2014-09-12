//
//  QueryTrafRecordService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-10.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "QueryTrafRecordService.h"
#import "CarInfo.h"
#import "JSON.h"
#import "TrafficRecord.h"

@implementation QueryTrafRecordService

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isShowNetHint = NO;
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceGetTrafficRecord;
        needSucessCount = 1;
		return self;
	}
	else
    {
		return nil;
	}
}

-(void) queryTrafRecord:(NSArray *) cars{
//    if (cars.count == 0) {
//        return;
//    }
    NSMutableArray * jsonArray = [NSMutableArray array];
    for (CarInfo *carInfo in cars) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:carInfo.carid forKey:@"carid"];
        NSMutableArray *citys = [NSMutableArray array];
        [dic setObject:citys forKey:@"citys"];
        for (CityOfCar * city in carInfo.citys) {
            NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                     city.timestamp.length == 0 ? @"":city.timestamp, @"timestamp",
                                     @"", @"authcode",
                                     nil];
            [citys addObject:cityDic];
        }
        if (citys.count == 0) {
            NSLog(@"error happened, no city!");
        }
        [jsonArray addObject:dic];
    }
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonArray forKey:@"carinfo"];
    NSString * text = [postDic JSONRepresentation];
    NSLog(@"%@", text);
    NSString * carTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey: KCarsTimestamp];
    if (carTimestamp == nil) {
        carTimestamp = @"";
    }
    NSString * url = [NSString stringWithFormat:@"%@ashx/GetViolation.ashx?carstimestamp=%@&userid=%d&frompush=0&net=%@", KServerHost, carTimestamp, [TRAppDelegate appDelegate].userId, [TRUtility getNetworkType]];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithObject:text forKey:@"carinfo"] ImageArray:nil];
}

-(void) queryTrafRecordFromPush:(NSArray *) cars{
    NSMutableArray * jsonArray = [NSMutableArray array];
    for (CarInfo *carInfo in cars) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:carInfo.carid forKey:@"carid"];
        NSMutableArray *citys = [NSMutableArray array];
        [dic setObject:citys forKey:@"citys"];
        for (CityOfCar * city in carInfo.citys) {
            NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                     city.timestamp.length == 0 ? @"":city.timestamp, @"timestamp",
                                     @"", @"authcode",
                                     nil];
            [citys addObject:cityDic];
        }
        if (citys.count == 0) {
            NSLog(@"error happen, no city!");
        }
        [jsonArray addObject:dic];
    }
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonArray forKey:@"carinfo"];
    NSString * text = [postDic JSONRepresentation];
    NSLog(@"%@", text);
    NSString * carTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey: KCarsTimestamp];
    if (carTimestamp == nil) {
        carTimestamp = @"";
    }
    NSString * url = [NSString stringWithFormat:@"%@ashx/GetViolation.ashx?carstimestamp=%@&userid=%d&frompush=1&net=%@", KServerHost, carTimestamp, [TRAppDelegate appDelegate].userId,[TRUtility getNetworkType]];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithObject:text forKey:@"carinfo"] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    NSString * carTimestamp = [result objectForKey:@"carstimestamp"];
    NSString * oldcarTimestamp = [[NSUserDefaults standardUserDefaults] objectForKey: KCarsTimestamp];
    [[NSUserDefaults standardUserDefaults] setObject:carTimestamp forKey:KCarsTimestamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //车辆信息发生变更,此情况只发生于已登录账户
    if (![oldcarTimestamp isEqualToString:carTimestamp] && [TRAppDelegate appDelegate].userId != 0 && carTimestamp.length >0) {
        NSArray *caritems = [result objectForKey:@"caritems"];
        //删除前保存所有时间戳和图片url
        NSMutableDictionary *timestampSave = [NSMutableDictionary dictionary];
        NSMutableArray *allCars = [CarInfo globCarInfo];
        for (CarInfo *car in allCars) {
            for (CityOfCar * city in car.citys) {
                [timestampSave setObject:city.timestamp forKey:[NSString stringWithFormat:@"%@_%@", car.carid, city.cityid]];
            }
        }
        [CarInfo deleteAllCars];
        for (int i = 0; i < caritems.count; i++) {
            NSDictionary *dic = [caritems objectAtIndex:i];
            CarInfo *car = [[CarInfo alloc] init];
            car.carid = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"carid"] intValue]];
            
            NSString *cityText = [dic objectForKey:@"querycitysid"];
            NSArray *citys = [cityText componentsSeparatedByString:@","];
            for (NSString *cityId in citys) {
                CityOfCar *city = [[CityOfCar alloc] init];
                city.cityid = cityId;
                city.carid = car.carid;
                //将之前存储的时间戳赋值给城市
                NSString *key = [NSString stringWithFormat:@"%@_%@", car.carid, city.cityid];
                city.timestamp = [timestampSave objectForKey:key];
                [car addCity:city];
            }
            car.carname = [dic objectForKey:@"carname"];
            car.carBrandId = [[dic objectForKey:@"carbrand"] integerValue];
            car.carSeriesId = [[dic objectForKey:@"carseries"] integerValue];
            car.cartypeId = [[dic objectForKey:@"carspecid"] integerValue];
            car.carnumber =[dic objectForKey:@"carnumber"];
            car.enginenumber =[dic objectForKey:@"enginenumber"];
            car.framenumber =[dic objectForKey:@"framenumber"];
            car.sortIndex = i;
            car.picUrl = [dic objectForKey:@"pic"];
            //1.4.0
            car.userName = [dic objectForKey:@"username"];
            car.passWord = [dic objectForKey:@"userpwd"];
            car.registernumber = [dic objectForKey:@"registernumber"];
            [CarInfo insertCar:car];
        }
    }
    NSArray *taskItems = [result objectForKey:@"taskitems"];
    if (taskItems.count > 0) {
        taskList = [NSMutableArray array];
        for (NSDictionary *taskDic in taskItems) {
            TRProxyTask *task = [TRProxyTask taskWithNSDictionary:taskDic];
            if (task) {
                [taskList addObject:task];
            }
        }
    }
    
    NSArray *items = [result objectForKey:@"items"];
    for (NSDictionary * carInfoDic in items) {
        NSString *carid = [NSString  stringWithFormat:@"%ld", (long)[[carInfoDic objectForKey:@"carid"] integerValue]];
        CarInfo *carM = nil;
        for (CarInfo * car in [CarInfo globCarInfo]) {
            if ([car.carid isEqualToString:carid]) {
                carM = car;
                break;
            }
        }
        if (carM == nil) {
            [iConsole warn:@"获取到本地不存在的carid=%@,该数据集被程序忽略", carid];
            continue;
        }
        carM.status = [[carInfoDic objectForKey:@"carreturncode"] intValue];
        carM.statusMsg = [carInfoDic objectForKey:@"returnmessage"];
        carM.totalMoney = 0;
        carM.totalNew = 0;
        carM.totalScore = 0;
        BOOL unknownMoney = YES;
        BOOL unknownScore = YES;
        
        NSArray *citys = [carInfoDic objectForKey:@"citys"];
        for (NSDictionary * cityDic in citys) {
            NSString *cityId = [cityDic objectForKey:@"cityid"];
            if ([cityId isKindOfClass:[NSNumber class]]) {
                cityId = [NSString stringWithFormat:@"%ld",[[cityDic objectForKey:@"cityid"] longValue]];
            }
            NSString *timeStamp = [cityDic objectForKey:@"timestamp"];
            if ([timeStamp isKindOfClass:[NSNumber class]]) {
                timeStamp = [NSString stringWithFormat:@"%lld",[[cityDic objectForKey:@"timestamp"] longLongValue]];
            }
            CityOfCar *cityM = [carM getCityById:cityId];
            if (cityM == nil) {
                [iConsole warn:@"获取到本地不存在的cityId=%@,该数据集被程序忽略", cityId];
                continue;
            }
            cityM.authInfoMsg = [cityDic objectForKey:@"authinfo"];
            NSString *imageUrl = [cityDic objectForKey:@"authimage"];
            BOOL needAuth = YES;
            //如果authimage值为null，则无需验证码
            if ([imageUrl isKindOfClass:[NSNull class]]) {
                needAuth = NO;
            } else {
                //
                if (imageUrl == nil || imageUrl.length == 0) {
                    needAuth = NO;
                }
            }
            //需要输入验证码
            if (needAuth) {
                cityM.authurl = imageUrl;
                NSDate *overTime = [NSDate dateWithTimeIntervalSinceNow:KTimeStampOverTime];
                NSTimeInterval time = [overTime timeIntervalSince1970];
                cityM.authovertime = [NSString stringWithFormat:@"%lf", time];
            }else{
                cityM.authurl = nil;
                cityM.authovertime = nil;
            }
            //如果时间戳不一致
            if (![cityM.timestamp isEqualToString:timeStamp] && !needAuth) {
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
    }
    
    return YES;
}
@end
