/*!
 @header   BrandManager.h
 @abstract 品牌车系业务处理文件
 @author   韩龙
 @version 1.00 2012/12/10
 */


#import <Foundation/Foundation.h>
#import "Brand.h"

@class Brand;
@class Series;
@class CarYear;
@class CarType;

/*!
 @class
 @abstract  品牌车系业务处理类
 */
@interface BrandManager : NSObject

+ (Brand *) getBrandById:(NSInteger)brandId;
/*!
 @method
 @abstract 获取所有品牌
 @result 品牌实体数组
 */
+ (NSMutableArray *)getAllBrands;

/*!
 @method
 @abstract 获取某一品牌下所有车系
 @param brandId NSInteger 品牌id
 @result 车系实体数组
 */
+ (NSArray *)getSeriesInBrand:(NSInteger)brandId;

/*!
 @method
 @abstract 获取某一车系下所有的出车型年份
 @param seriesId NSInteger 车系id
 @result 年份实体数组
 */
+ (NSArray *)getYearsInSeries:(NSInteger)seriesId;

/*!
 @method
 @abstract 获取某一年份下所有车型
 @param yearId NSInteger 年份id
 @result 车型实体数组
 */
+ (NSArray *)getCarTypesInYear:(NSInteger)yearId;

/*!
 @method
 @abstract 获取某一车系所有车型
@param seriesId NSInteger 车系id
 @result 车型实体数组
 */
+ (NSArray *)getCarTypesInSeries:(NSInteger)seriesId;

/*!
 @method
 @abstract 根据车系id获取车系详情
 @param seriesId NSInteger 车源id
 @result 车源详情实体
 */
+ (Series *)getSeriesWithId:(NSInteger)seriesId;

+ (NSArray *)getAllInfoBySeries:(NSInteger) seriesId;

///*!
// @method
// @abstract 获取品牌等增量数据
// @result 增量数据数组
// */
//+ (Series *)getIncreaseData;

+ (Brand *)getBrandBySpec:(NSInteger) specId;

+ (NSArray *)getAllInfoBySpec:(NSInteger) specId;
@end
