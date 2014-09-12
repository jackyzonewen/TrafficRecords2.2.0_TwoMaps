//
//  AreaDBManager.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"

@interface AreaDBManager : NSObject

/*!
 @method
 @abstract 获取所有省份
 @result 省份实体数组
 */
+ (NSArray *)getAllProvinces;

/*!
 @method
 @abstract 获取某一省份下所有城市
 @param brandId NSInteger 省份id
 @result 城市实体数组
 */
+ (NSArray *)getCitysInProvince:(NSInteger)provinceId;

/*!
 @method
 @abstract 根据省份的主键查询省份
 @param provinceId 省份主键
 @result 省份
 */
+ (Province *)getProvince:(NSInteger)provinceId;

/*!
 @method
 @abstract 根据省份的主键查询省份
 @param provinceId 省份主键
 @result 省份
 */
+ (Province *)getProvinceByCityId:(NSInteger)cityID;


/*!
 @method
 @abstract 根据城市的主键查询城市
 @param provinceId 城市主键
 @result 城市
 */
+ (City *)getCityByCityId:(NSInteger)cityId;

+ (City *)getCityByKeyWord:(NSString *)keyWord;
@end
