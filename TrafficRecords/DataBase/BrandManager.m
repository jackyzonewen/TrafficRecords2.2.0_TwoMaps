//
//  BrandManager.m
//  UsedCar2
//
//  Created by harry on 12-12-10.
//  Copyright (c) 2012年 che168. All rights reserved.
//

#import "BrandManager.h"
#import "DBAbstraction.h"

@implementation BrandManager

+ (Brand *) getBrandById:(NSInteger)brandId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcarbrand WHERE brandid = '%ld'", (long)brandId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array) {
        Brand *newBrand = [[Brand alloc] init];
        newBrand.brandId = [[dic objectForKey:@"BrandId"] integerValue];
        newBrand.name = [dic objectForKey:@"Name"];
        newBrand.firstLetter = [dic objectForKey:@"FirstLetter"];
        newBrand.brandImg = [dic objectForKey:@"BrandImg"];
        return newBrand;
    }
    return nil;
}
/*!
 @method
 @abstract 获取所有品牌
 @result 品牌实体数组
 */
+ (NSMutableArray *)getAllBrands
{
    NSString *sql = @"SELECT * FROM allcarbrand order by FirstLetter";
    NSMutableArray *array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Brand *newBrand = [[Brand alloc] init];
        newBrand.brandId = [[dic objectForKey:@"BrandId"] integerValue];
        newBrand.name = [dic objectForKey:@"Name"];
        newBrand.firstLetter = [dic objectForKey:@"FirstLetter"];
        newBrand.brandImg = [dic objectForKey:@"BrandImg"];
        [res addObject: newBrand];
    }
    return res;
}

/*!
 @method
 @abstract 获取某一品牌下所有车系
 @param brandId NSInteger 品牌id
 @result 车系实体数组
 */
+ (NSArray *)getSeriesInBrand:(NSInteger)brandId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcarseries WHERE FatherId = '%ld'", (long)brandId];
    NSMutableArray *array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Series *newSeries = [[Series alloc] init];
        newSeries.seriesId = [[dic objectForKey:@"SeriesId"] integerValue];
        newSeries.name = [dic objectForKey:@"Name"];
        newSeries.brandId =[[dic objectForKey:@"FatherId"] integerValue];
        [res addObject:newSeries];
    }
    return res;
}


/*!
 @method
 @abstract 获取某一车系下所有的出车型年份
 @param seriesId NSInteger 车系id
 @result 年份实体数组
 */
+ (NSArray *)getYearsInSeries:(NSInteger)seriesId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcaryears WHERE FatherId = '%ld' order by yearname desc", (long)seriesId];
    NSMutableArray *array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        CarYear *newYear = [[CarYear alloc] init];
        newYear.yearId = [[dic objectForKey:@"YearId"] integerValue];
        newYear.name = [dic objectForKey:@"YearName"];
        [res addObject:newYear];
    }
    return res;
}

/*!
 @method
 @abstract 获取某一年份下所有车型
 @param yearId NSInteger 年份id
 @result 车型实体数组
 */
+ (NSArray *)getCarTypesInYear:(NSInteger)yearId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcartype WHERE FatherId = '%ld'", (long)yearId];
    NSMutableArray *array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        CarType *newCarType = [[CarType alloc] init];
        newCarType.typeId = [[dic objectForKey:@"SpecId"] integerValue];
        newCarType.name = [dic objectForKey:@"SpecName"];
        newCarType.yearId = [[dic objectForKey:@"FatherId"] integerValue];
        [res addObject:newCarType];
    }
    return res;
}

/*!
 @method
 @abstract 获取某一车系所有车型
 @param seriesId NSInteger 车系id
 @result 车型实体数组
 */
+ (NSArray *)getCarTypesInSeries:(NSInteger)seriesId{
    NSArray *years = [BrandManager getYearsInSeries:seriesId];
    NSMutableArray *carTypes = [NSMutableArray array];
    for (CarYear *year in years) {
        NSArray* carType = [BrandManager getCarTypesInYear:year.yearId];
        [carTypes addObjectsFromArray:carType];
    }
    return carTypes;
}

/*!
 @method
 @abstract 根据车系id获取车系详情
 @param seriesId NSInteger 车源id
 @result 车源详情实体
 */
+ (Series *)getSeriesWithId:(NSInteger)seriesId
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcarseries WHERE SeriesId = '%ld'", (long)seriesId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    for (NSDictionary *dic in array) {
        Series *newSeries = [[Series alloc] init];
        newSeries.seriesId = [[dic objectForKey:@"SeriesId"] integerValue];
        newSeries.name = [dic objectForKey:@"Name"];
        newSeries.brandId = [[dic objectForKey:@"FatherId"] integerValue];
        return newSeries;
    }
    return nil;
}

+ (Brand *)getBrandBySpec:(NSInteger) specId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcartype WHERE SpecId = '%ld'", (long)specId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    CarType *spec = [[CarType alloc] init];
    for (NSDictionary *dic in array){
        spec.typeId = [[dic objectForKey:@"SpecId"] integerValue];
        spec.name = [dic objectForKey:@"SpecName"];
        spec.yearId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    sql = [NSString stringWithFormat:@"SELECT * FROM allcaryears WHERE YearId = '%ld'", (long)spec.yearId];
    array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    CarYear *year = [[CarYear alloc] init];
    NSInteger parentId = -1;
    for (NSDictionary *dic in array){
        year.yearId = [[dic objectForKey:@"YearId"] integerValue];
        year.name = [dic objectForKey:@"YearName"];
        parentId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    Series *series = [BrandManager getSeriesWithId:parentId];
    Brand *brand = [BrandManager getBrandById:series.brandId];
    return brand;
}

+ (NSArray *)getAllInfoBySeries:(NSInteger) seriesId{
    Series *series = [BrandManager getSeriesWithId:seriesId];
    Brand *brand = [BrandManager getBrandById:series.brandId];
    NSMutableArray *reslt = [[NSMutableArray alloc] init];
    if (series) {
        [reslt addObject:series];
    }
    if (brand) {
        [reslt addObject:brand];
    }
    return reslt;
}

+ (NSArray *)getAllInfoBySpec:(NSInteger) specId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allcartype WHERE SpecId = '%ld'", (long)specId];
    NSMutableArray * array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    CarType *spec = [[CarType alloc] init];
    for (NSDictionary *dic in array){
        spec.typeId = [[dic objectForKey:@"SpecId"] integerValue];
        spec.name = [dic objectForKey:@"SpecName"];
        spec.yearId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    sql = [NSString stringWithFormat:@"SELECT * FROM allcaryears WHERE YearId = '%ld'", (long)spec.yearId];
    array = [[DBAbstraction sharedDBAbstraction] excuteQuery:sql];
    CarYear *year = [[CarYear alloc] init];
    NSInteger parentId = -1;
    for (NSDictionary *dic in array){
        year.yearId = [[dic objectForKey:@"YearId"] integerValue];
        year.name = [dic objectForKey:@"YearName"];
        parentId = [[dic objectForKey:@"FatherId"] integerValue];
    }
    Series *series = [BrandManager getSeriesWithId:parentId];
    Brand *brand = [BrandManager getBrandById:series.brandId];
    NSMutableArray *reslt = [[NSMutableArray alloc] init];
    if (spec) {
        [reslt addObject:spec];
    }
    if (year) {
        [reslt addObject:year];
    }
    if (series) {
        [reslt addObject:series];
    }
    if (brand) {
        [reslt addObject:brand];
    }
    return reslt;
}

@end
