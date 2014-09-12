//
//  Brand.m
//  UsedCar2
//
//  Created by harry on 12-12-10.
//  Copyright (c) 2012年 che168. All rights reserved.
//

#import "Brand.h"

/*!
 @class
 @abstract 品牌实体实现类
 */
@implementation Brand
@synthesize brandId;
@synthesize name;
@synthesize firstLetter;
@synthesize brandImg;
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.brandId = [[dic objectForKey:@"brandId"] integerValue];
        self.name = [dic objectForKey:@"name"];
        self.firstLetter = [dic objectForKey:@"firstLetter"];
        self.brandImg = [dic objectForKey:@"brandImg"];
    }
    return self;
}

@end

/*!
 @class
 @abstract 车系实体实现类
 */
@implementation Series
@synthesize seriesId;
@synthesize name;
@synthesize firstLetter;
@synthesize brandId;

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.seriesId = [[dic objectForKey:@"brandId"] integerValue];
        self.name = [dic objectForKey:@"name"];
        self.firstLetter = [dic objectForKey:@"firstLetter"];
        self.brandId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    return self;
}

@end

/*!
 @class
 @abstract 车系年份实体实现类
 */
@implementation CarYear
@synthesize yearId;
@synthesize name;

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.yearId = [[dic objectForKey:@"yearId"] integerValue];
        self.name = [dic objectForKey:@"name"];
    }
    return self;
}

@end

/*!
 @class
 @abstract 车型实体实现类
 */
@implementation CarType
@synthesize typeId;
@synthesize name;
@synthesize yearId;

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.typeId = [[dic objectForKey:@"typeId"] integerValue];
        self.name = [dic objectForKey:@"name"];
        self.yearId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    return self;
}

@end


