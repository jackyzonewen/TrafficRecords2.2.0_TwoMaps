//
//  AreaDBManager.m
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AreaDBManager.h"
#import "DBAbstraction.h"

@implementation AreaDBManager

/*!
 @method
 @abstract 获取所有省份
 @result 省份实体数组
 */
+ (NSArray *)getAllProvinces{
    NSString *sql = @"SELECT * FROM Area WHERE `Parent` = '0' ORDER BY AreaId";
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    NSMutableArray *rest = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [rest addObject:[Province entityWithWebDictionary:dic]];
    }
    return rest;
}

/*!
 @method
 @abstract 获取某一省份下所有城市
 @param brandId NSInteger 省份id
 @result 城市实体数组
 */
+ (NSArray *)getCitysInProvince:(NSInteger)provinceId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Area WHERE `Parent` = '%ld' ORDER BY AreaId ", (long)provinceId];
    NSMutableArray *cityArray = [NSMutableArray array];
    
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array){
        [cityArray addObject:[City entityWithWebDictionary:dic]];
    }
    
    return cityArray;
}

/*!
 @method
 @abstract 根据省份的主键查询省份
 @param provinceId 省份主键
 @result 省份
 */
+ (Province *)getProvince:(NSInteger)provinceId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Area WHERE `AreaId` = '%ld' ", (long)provinceId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array) {
        return [Province entityWithWebDictionary:dic];
    }
    return nil;
}

/*!
 @method
 @abstract 根据省份的主键查询省份
 @param provinceId 省份主键
 @result 省份
 */
+ (Province *)getProvinceByCityId:(NSInteger)cityID{
    City *city = [AreaDBManager getCityByCityId:cityID];
    Province * p = [AreaDBManager getProvince:city.parentId];
    return p;
}

/*!
 @method
 @abstract 根据城市的主键查询城市
 @param provinceId 城市主键
 @result 城市
 */
+ (City *)getCityByCityId:(NSInteger)cityId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Area WHERE `AreaId` = '%ld' ", (long)cityId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array) {
        return [City entityWithWebDictionary:dic];
    }
    return nil;
}

+ (City *)getCityByKeyWord:(NSString *)keyWord{
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Area WHERE `Name` LIKE '%%%@%%' ", keyWord];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"Parent"] intValue] != 0) {
            return [City entityWithWebDictionary:dic];
        }
    }
    return nil;
}

@end
