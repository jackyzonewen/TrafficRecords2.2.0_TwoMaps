//
//  Area.m
//  UsedCar2
//
//  Created by harry on 12-12-11.
//  Copyright (c) 2012年 che168. All rights reserved.
//

#import "Area.h"

/*!
 @class
 @abstract 省份实体类
 */
@implementation Province
@synthesize provinceId;
@synthesize name;
@synthesize firstLetter;
@synthesize citys;


- (id)init
{
    if (self=[super init])
    {
        self.name=@"北京";
        self.provinceId=110000;
    }
    return self;
}

/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.provinceId = [[dic objectForKey:@"AreaId"] integerValue];
        self.name = [dic objectForKey:@"Name"];
        self.firstLetter = [dic objectForKey:@"FirstLetter"];
    }
    return self;
}


/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithWebDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.provinceId = [[dic objectForKey:@"AreaId"] integerValue];
        self.name = [dic objectForKey:@"Name"];
        self.firstLetter = [dic objectForKey:@"FirstLetter"];
        self.citys = [City entityWithWebArray:[dic objectForKey:@"Citys"]];
    }
    return self;
}

/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebDictionary:(NSDictionary *)dic
{
    id newInstance = [[[self class] alloc] initWithWebDictionary:dic];
    return newInstance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:provinceId forKey:@"AreaId"];
    [aCoder encodeObject:name forKey:@"Name"];
    [aCoder encodeObject:firstLetter forKey:@"FirstLetter"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.provinceId= [aDecoder decodeIntegerForKey:@"AreaId"];
        self.name= [aDecoder decodeObjectForKey:@"Name"];
        self.firstLetter = [aDecoder decodeObjectForKey:@"FirstLetter"];
    }
    return self;
}

@end

/*!
 @class
 @abstract 城市实体类
 */
@implementation City
@synthesize cityId;
@synthesize name;
@synthesize parentId;
@synthesize firstLetter;
@synthesize enginelen;
@synthesize framelen;
@synthesize notSupport;
@synthesize supportnum;
@synthesize loginurl;
@synthesize registernumlen;

- (id)init
{
    if (self=[super init])
    {
        self.name=@"";
        self.cityId=0;
    }
    return self;
}


/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.parentId =  [[dic objectForKey:@"Parent"] integerValue];
        self.cityId = [[dic objectForKey:@"AreaId"] integerValue];
        self.name = [dic objectForKey:@"Name"];
        self.firstLetter =  [dic objectForKey:@"FirstLetter"];
    }
    return self;
}

/*!
 @method
 @abstract 根据json字典里生成实体
 @param dic 从web中获取json数据
 @result 实体
 */
- (id)initWithWebDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.parentId =  [[dic objectForKey:@"Parent"] integerValue];
        self.cityId = [[dic objectForKey:@"AreaId"] integerValue];
        self.name = [dic objectForKey:@"Name"];
        self.firstLetter =  [dic objectForKey:@"FirstLetter"];
    }
    return self;
}

/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebDictionary:(NSDictionary *)dic
{
    id newInstance = [[[self class] alloc] initWithWebDictionary:dic];
    return newInstance;
}


/*!
 @method
 @abstract 根据json字典里生成实体。
 @param dic 从web中获取json数据
 @result 实体。autorelease对象
 */
+ (id)entityWithWebArray:(NSArray *)arr
{
    NSMutableArray *entityArray = [NSMutableArray array];
    for (NSDictionary *cityDict in arr) {
        [entityArray addObject:[City entityWithWebDictionary:cityDict]];
    }
    return entityArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:cityId forKey:@"AreaId"];
    [aCoder encodeObject:name forKey:@"Name"];
    [aCoder encodeInteger:parentId forKey:@"Parent"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.cityId= [aDecoder decodeIntegerForKey:@"AreaId"];
        self.name= [aDecoder decodeObjectForKey:@"Name"] ;
        self.parentId= [aDecoder decodeIntegerForKey:@"Parent"] ;
    }
    return self;
}

@end


