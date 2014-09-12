//
//  CarInfo.h
//  TrafficRecords
//
//  Created by qiao on 13-9-10.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityOfCar.h"

@interface CarInfo : NSObject

@property (nonatomic, strong) NSString *carid;
@property (nonatomic, strong) NSMutableArray *citys;
@property (nonatomic, strong) NSString *carname;
@property (nonatomic, assign) NSInteger cartypeId;
@property (nonatomic, strong) NSString *carnumber;
@property (nonatomic, strong) NSString *enginenumber;
@property (nonatomic, strong) NSString *framenumber;
@property (nonatomic, strong) NSMutableArray *trafficRecods;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *brandImageUrl;
@property (nonatomic, assign) NSInteger carSeriesId;
@property (nonatomic, assign) NSInteger carBrandId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *statusMsg;
//1.4.0新增
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *registernumber;

@property (nonatomic, assign) NSInteger totalNew;
@property (nonatomic, assign) NSInteger totalMoney;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, assign) BOOL unknownMoney;
@property (nonatomic, assign) BOOL unknownScore;

-(CarInfo *) copyCar;
-(void) reloadLocalUndealRecods;
-(void) removeRecordsOfCity:(NSString *) cityid;
-(NSArray *)recordsOfCity:(NSString *) cityid;
-(CityOfCar *) getCityById:(NSString *) cityid;

-(void) addCity:(CityOfCar *) city;
-(void) deleteCity:(CityOfCar *) city;
-(void) updateCity:(CityOfCar *) city;

+(void) resetAllCars;
//删除当前用户所有车辆
+ (void) deleteAllCars;
//获取当前用户所有车辆
+ (NSArray *)getAllCars;
//+ (CarInfo *)getCarById:(NSString *) carid;
//插入新的carinfo记录
+ (void) insertCar:(CarInfo *) carInfo;
//删除掉carid相关的carinfo，cityinfo表记录
+ (void) deleteCar:(NSString *) carid;
+ (NSMutableArray *)globCarInfo;
+ (void) bingAllcarsToUser;
//更新数据库中car对象的sortindex
+ (void) updateCarSortIndex:(CarInfo *) car;
@end
