//
//  Area.h
//  UsedCar2
//
//  Created by harry on 12-12-11.
//  Copyright (c) 2012年 che168. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

/*!
 @class
 @abstract 省份实体类
 */
@interface Province : NSObject<NSCoding>
{
    NSInteger provinceId;
    NSString *name;
    NSString *firstLetter;
    NSArray *citys;
}

/*!
 @property
 @abstract 省份主键
 */
@property(nonatomic, assign) NSInteger provinceId;

/*!
 @property
 @abstract 省份名称
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 名称的首字符
 */
@property(nonatomic, copy) NSString *firstLetter;

/*!
 @property
 @abstract 名称的首字符
 */
@property(nonatomic, retain) NSArray *citys;

/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithWebDictionary:(NSDictionary *)dic;

/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebDictionary:(NSDictionary *)dic;

@end

/*!
 @class
 @abstract 城市实体类
 */
@interface City : NSObject<NSCoding>
{
    NSInteger cityId;
    NSString *name;
    NSInteger parentId;
}

/*!
 @property
 @abstract 城市主键
 */
@property(nonatomic, assign) NSInteger cityId;

/*!
 @property
 @abstract 城市名称
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 所在省份id
 */
@property(nonatomic, assign) NSInteger parentId;

/*!
 @property
 @abstract 名称的首字符
 */
@property(nonatomic, copy) NSString *firstLetter;

@property(nonatomic, assign) NSInteger enginelen;
@property(nonatomic, assign) NSInteger framelen;
@property(nonatomic, assign) BOOL       notSupport;
@property(nonatomic, strong) NSString   *supportnum;
@property(nonatomic, strong) NSString   *loginurl;
@property(nonatomic, assign) NSInteger   registernumlen;

/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithWebDictionary:(NSDictionary *)dic;

/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebDictionary:(NSDictionary *)dic;

/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebArray:(NSArray *)arr;

@end








