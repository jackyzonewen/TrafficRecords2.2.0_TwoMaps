//
//  CarInfo.m
//  TrafficRecords
//
//  Created by qiao on 13-9-10.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "CarInfo.h"
#import "DBAbstraction.h"
#import "TrafficRecord.h"
#import "BrandManager.h"
#import "Des.h"

static NSMutableArray *allCarInfo = nil;

@implementation CarInfo

@synthesize carid;
@synthesize citys;
@synthesize carname;
@synthesize cartypeId;
@synthesize carnumber;
@synthesize enginenumber;
@synthesize framenumber;
@synthesize trafficRecods;
@synthesize sortIndex;
@synthesize totalNew;
@synthesize totalMoney;
@synthesize totalScore;
@synthesize picUrl;
@synthesize brandImageUrl;
@synthesize unknownMoney;
@synthesize unknownScore;
@synthesize carBrandId;
@synthesize carSeriesId;
@synthesize status;
@synthesize statusMsg;

@synthesize userName;
@synthesize passWord;
@synthesize registernumber;

-(CarInfo *) copyCar{
    CarInfo *newObj = [[CarInfo alloc] init];
    newObj.carid = self.carid;
    newObj.carname = self.carname;
    newObj.carBrandId = self.carBrandId;
    newObj.carSeriesId = self.carSeriesId;
    newObj.cartypeId = self.cartypeId;
    newObj.carnumber = self.carnumber;
    newObj.enginenumber = self.enginenumber;
    newObj.framenumber = self.framenumber;
    newObj.trafficRecods = [NSMutableArray arrayWithArray:self.trafficRecods];
    newObj.sortIndex = self.sortIndex;
    newObj.totalNew = self.totalNew;
    newObj.totalMoney = self.totalMoney;
    newObj.totalScore = self.totalScore;
    newObj.picUrl = self.picUrl;
    newObj.statusMsg = self.statusMsg;
    newObj.status = self.status;
    //1.4.0
    newObj.userName = self.userName;
    newObj.passWord = self.passWord;
    newObj.registernumber = self.registernumber;
    newObj.citys = [NSMutableArray arrayWithArray:self.citys];
    return newObj;
}

-(void)setCartypeId:(NSInteger)aCartypeId{
    cartypeId = aCartypeId;
    if (aCartypeId != 0) {
        NSArray * array = [BrandManager getAllInfoBySpec:aCartypeId];
        for (NSObject *obj in array) {
            if ([obj isKindOfClass:[Brand class]]) {
                carBrandId = [(Brand*)obj brandId];
            } else if([obj isKindOfClass:[Series class]]){
                carSeriesId = [(Series*)obj seriesId];
            }
        }
    }
    self.brandImageUrl = nil;
}

-(void) setCarSeriesId:(NSInteger)acarSeriesId{
    carSeriesId = acarSeriesId;
    self.brandImageUrl = nil;
}

-(NSString *) brandImageUrl{
    if (brandImageUrl == nil) {
        if (cartypeId == 0) {
            Series *series = [BrandManager getSeriesWithId:carSeriesId];
            Brand *brand = [BrandManager getBrandById:series.brandId];
            brandImageUrl = brand.brandImg;
        } else {
            Brand *brand = [BrandManager getBrandBySpec:cartypeId];
            brandImageUrl = brand.brandImg;
        }
    }
    return brandImageUrl;
}

-(id) init{
    self = [super init];
    if (self) {
        self.trafficRecods = [NSMutableArray array];
        self.citys = [NSMutableArray array];
    }
    return self;
}

//-(void) setUserName:(NSString *) myuserName{
//    if (myuserName.length > 0) {
//        NSRange r = [myuserName rangeOfString:@"00wzcx_"];
//        if (r.length == 0) {//未经des加密
//            NSString *key = [[TRUtility getAppKey] substringToIndex:8];
//            userName = [Des doCipher2:myuserName key:key iv:nil context:kCCEncrypt];
//            userName = [NSString stringWithFormat:@"00wzcx_%@", userName];
//        } else {
//            userName = myuserName;
//        }
//    }
//    userName = myuserName;
//}
//
//-(void) setPassWord:(NSString *) mypwd{
//    if (mypwd.length > 0) {
//        NSRange r = [mypwd rangeOfString:@"00wzcx_"];
//        if (r.length == 0) {//未经des加密
//            NSString *key = [[TRUtility getAppKey] substringToIndex:8];
//            passWord = [Des doCipher2:mypwd key:key iv:nil context:kCCEncrypt];
//            passWord = [NSString stringWithFormat:@"00wzcx_%@", passWord];
//        } else {
//            passWord = mypwd;
//        }
//    }
//    passWord = mypwd;
//}


-(void) reloadLocalUndealRecods{
    if (self.trafficRecods == nil) {
        self.trafficRecods = [NSMutableArray array];
    }
    [self.trafficRecods removeAllObjects];
    for (CityOfCar *city in citys) {
        NSArray * array = [TrafficRecord getUnDealRecordsBy:self.carid with:city.cityid];
        [self.trafficRecods addObjectsFromArray:array];
    }
    //所有城市结果处理完成，将结果集按time排序
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSArray *sortArray = [self.trafficRecods sortedArrayUsingComparator: ^NSComparisonResult(id a, id b){
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
    self.trafficRecods = [NSMutableArray arrayWithArray:sortArray];
    
    self.totalNew = 0;
    self.totalMoney = 0;
    self.totalScore = 0;
    BOOL aunknownMoney = YES;
    BOOL aunknownScore = YES;
    for (TrafficRecord * record in self.trafficRecods) {
        if (record.score >= 0) {
            self.totalScore += record.score;
            aunknownMoney = NO;
        }
        if (record.money >= 0) {
            self.totalMoney += record.money;
            aunknownScore = NO;
        }
    }
    if (self.trafficRecods.count > 0 ) {
        self.unknownMoney = aunknownMoney;
        self.unknownScore = aunknownScore;
    } else {
        self.unknownScore = NO;
        self.unknownScore = NO;
    }
}

-(void) removeRecordsOfCity:(NSString *) cityid{
    for (NSInteger i = self.trafficRecods.count - 1; i >= 0; i--) {
        TrafficRecord *record = [self.trafficRecods objectAtIndex:i];
        if ([record.cityid isEqualToString:cityid]) {
            [self.trafficRecods removeObjectAtIndex:i];
        }
    }
}

-(NSArray *)recordsOfCity:(NSString *) cityid{
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = self.trafficRecods.count - 1; i >= 0; i--) {
        TrafficRecord *record = [self.trafficRecods objectAtIndex:i];
        if ([record.cityid isEqualToString:cityid]) {
            [result addObject:record];
        }
    }
    return result;
}

-(CityOfCar *) getCityById:(NSString *) cityid{
    for (CityOfCar * city in self.citys) {
        if ([city.cityid isEqualToString:cityid]) {
            return city;
        }
    }
    return nil;
}

-(void) addCity:(CityOfCar *) city{
    if (self.citys == nil) {
        self.citys = [NSMutableArray array];
    }
    city.carid = carid;
    [self.citys addObject: city];
    NSString *sql = [NSString stringWithFormat:@"insert into cityinfo(cityid, carid, timestamp, authovertime, authurl) values('%@', '%@', '%@', '%@', '%@')", city.cityid, carid, city.timestamp.length > 0 ? city.timestamp : @"", city.authovertime.length>0 ? city.authovertime : @"", city.authurl.length > 0 ? city.authurl : @""];
    [[DBAbstraction productionDBAbstraction] excuteUpdate:sql];
}

-(void) deleteCity:(CityOfCar *) city{
    if ([self.citys containsObject:city]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from cityinfo where carid=%@ and cityid=%@", self.carid, city.cityid];
        NSString *deleteSql2 = [NSString stringWithFormat:@"delete from trafficrecord where carid=%@ and cityid=%@", self.carid, city.cityid];
        [[DBAbstraction productionDBAbstraction] excuteUpdate:deleteSql];
        [[DBAbstraction productionDBAbstraction] excuteUpdate:deleteSql2];
        [self.citys removeObject:city];
    }
}

-(void) updateCity:(CityOfCar *) city{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from cityinfo where carid=%@ and cityid=%@", self.carid, city.cityid];
    NSString *sql = [NSString stringWithFormat:@"insert into cityinfo(cityid, carid, timestamp, authovertime, authurl) values('%@', '%@', '%@', '%@', '%@')", city.cityid, carid, city.timestamp.length > 0 ? city.timestamp : @"", city.authovertime.length>0 ? city.authovertime : @"", city.authurl.length > 0 ? city.authurl : @""];
    [[DBAbstraction productionDBAbstraction] excuteUpdates:[NSArray arrayWithObjects:deleteSql, sql, nil]];
}


+(void) resetAllCars{
    [allCarInfo removeAllObjects];
    allCarInfo = nil;
}

//删除当前用户所有车辆
+ (void) deleteAllCars{
    for (CarInfo *car in allCarInfo) {
        [CarInfo deleteCar:car.carid];
    }
    [allCarInfo removeAllObjects];
    allCarInfo = nil;
}

+ (NSArray *)getAllCars{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM carinfo where userid=%d order by sortindex", [TRAppDelegate appDelegate].userId];
    NSMutableArray * array = [[DBAbstraction productionDBAbstraction] excuteQuery:sql];
    NSMutableArray *rest = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        CarInfo *car = [[CarInfo alloc] init];
        car.carid = [dic objectForKey:@"carid"];
        
        car.citys = [NSMutableArray array];
        NSString *sql2 = [NSString stringWithFormat:@"SELECT * FROM cityinfo where carid = '%@' ", car.carid];
        NSArray * citysArray =  [[DBAbstraction productionDBAbstraction] excuteQuery:sql2];
        for (NSDictionary *dic in citysArray) {
            CityOfCar *city = [CityOfCar createByDic:dic];
            [car.citys addObject:city];
        }
        car.carname = [dic objectForKey:@"carname"];
        car.carBrandId = [[dic objectForKey:@"carbrandid"] integerValue];
        car.carSeriesId = [[dic objectForKey:@"carseriesid"] integerValue];
        car.cartypeId = [[dic objectForKey:@"cartypeId"] integerValue];
        car.status = [[dic objectForKey:@"carstatus"] integerValue];
        car.statusMsg = [dic objectForKey:@"statusmsg"];
        
        car.carnumber = [dic objectForKey:@"carnumber"];
        car.enginenumber = [dic objectForKey:@"enginenumber"];
        car.framenumber = [dic objectForKey:@"framenumber"];
        car.picUrl = [dic objectForKey:@"pic"];
        car.sortIndex = [[dic objectForKey:@"sortindex"] integerValue];
        
        //1.4.0新增字段
        if ([[dic objectForKey:@"username"] length] > 0) {
            car.userName = [dic objectForKey:@"username"];
        }
        if ([[dic objectForKey:@"password"] length] > 0) {
            car.passWord = [dic objectForKey:@"password"];
        }
        if ([dic objectForKey:@"registernumber"]) {
            car.registernumber = [dic objectForKey:@"registernumber"];
        }
        
        [rest addObject:car];
    }
    return rest;
}

+ (void) deleteCar:(NSString *) carid{
    int userId = [TRAppDelegate appDelegate].userId;
    NSString *deleteSql1 = [NSString stringWithFormat:@"delete from carinfo where carid=%@ and userid=%d", carid, userId];
    NSString *deleteSql2 = [NSString stringWithFormat:@"delete from cityinfo where carid=%@", carid];
//    NSString *deleteSql3 = [NSString stringWithFormat:@"delete from trafficrecord where carid=%@", carid];
    [[DBAbstraction productionDBAbstraction] excuteUpdate:deleteSql1];
    [[DBAbstraction productionDBAbstraction] excuteUpdate:deleteSql2];
//    [[DBAbstraction productionDBAbstraction] excuteUpdate:deleteSql3];
}

+ (void) insertCar:(CarInfo *) carInfo{
    //1.4.0新增字段
//    car.userName = [dic objectForKey:@"username"];
//    car.passWord = [dic objectForKey:@"password"];
//    car.registernumber = [dic objectForKey:@"registernumber"];
    NSString *insertSql = [NSString stringWithFormat:@"insert into carinfo(carid, carname, cartypeId, carnumber, enginenumber, framenumber, sortindex, userid, pic, carseriesid, carbrandid, carstatus, statusmsg, username, password, registernumber) values('%@', '%@', '%ld', '%@', '%@', '%@' ,'%ld' , '%d', '%@', '%ld', '%ld', '%ld', '%@', '%@', '%@', '%@')", carInfo.carid,  carInfo.carname, (long)carInfo.cartypeId, carInfo.carnumber, carInfo.enginenumber.length > 0 ? carInfo.enginenumber : @"", carInfo.framenumber, (long)carInfo.sortIndex, [TRAppDelegate appDelegate].userId, carInfo.picUrl.length > 0 ? carInfo.picUrl : @"", (long)carInfo.carSeriesId, (long)carInfo.carBrandId, (long)carInfo.status, carInfo.statusMsg.length > 0 ? carInfo.statusMsg : @"", carInfo.userName.length > 0 ? carInfo.userName : @"", carInfo.passWord.length > 0 ? carInfo.passWord : @"", carInfo.registernumber.length > 0 ? carInfo.registernumber : @""];
    [[DBAbstraction productionDBAbstraction] excuteUpdate:insertSql];
}

+ (NSMutableArray *)globCarInfo{
    if (allCarInfo == nil) {
        allCarInfo = [NSMutableArray arrayWithArray:[CarInfo getAllCars]];
        for (CarInfo *car in allCarInfo) {
            [car reloadLocalUndealRecods];
        }
    }
    return allCarInfo;
}

+ (void) updateCarSortIndex:(CarInfo *) car{
    int userId = [TRAppDelegate appDelegate].userId;
    NSString * sql = [NSString stringWithFormat:@"UPDATE carinfo SET sortindex = '%d' WHERE carid= '%@' and userid = '%d'", car.sortIndex, car.carid, userId];
    [[DBAbstraction productionDBAbstraction] excuteUpdate:sql];
}

+ (void) bingAllcarsToUser{
    int userId = [TRAppDelegate appDelegate].userId;
    for (CarInfo *car in allCarInfo) {
        NSString * sql = [NSString stringWithFormat:@"UPDATE carinfo SET userid = '%d' WHERE carid= '%@' and userid = '0'", userId, car.carid];
        [[DBAbstraction productionDBAbstraction] excuteUpdate:sql];
    }
    [allCarInfo removeAllObjects];
    allCarInfo = nil;
}

@end
