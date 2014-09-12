/*!
 @header   Brand.h
 @abstract 品牌实体类文件
 @author   韩龙
 @version 1.00 2012/12/10
 */

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 品牌实体类
 */
@interface Brand : NSObject
{
    NSInteger brandId;
    NSString *name;
    NSString *firstLetter;
    NSString *brandImg;
}

/*!
 @property
 @abstract 品牌id
 */
@property(nonatomic, assign) NSInteger brandId;

/*!
 @property
 @abstract 品牌名称
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 首字母
 */
@property(nonatomic, copy) NSString *firstLetter;

/*!
 @property
 @abstract 品牌图片
 */
@property(nonatomic, copy) NSString *brandImg;


@end

/*!
 @class
 @abstract 车系实体类
 */
@interface Series : NSObject
{
    NSInteger seriesId;
    NSString *name;
    NSString *firstLetter;
}

/*!
 @property
 @abstract 车系id
 */
@property(nonatomic, assign) NSInteger seriesId;

/*!
 @property
 @abstract 车系名称
 */
@property(nonatomic, copy) NSString *name;

/*!
 @property
 @abstract 首字母
 */
@property(nonatomic, copy) NSString *firstLetter;

@property(nonatomic, assign) NSInteger brandId;


@end

/*!
 @class
 @abstract 车系的年份类
 */
@interface CarYear : NSObject
{
    NSInteger yearId;
    NSString *name;
}

/*!
 @property
 @abstract 年份id
 */
@property(nonatomic, assign) NSInteger yearId;

/*!
 @property
 @abstract 车系名称
 */
@property(nonatomic, copy) NSString *name;


@end

/*!
 @class
 @abstract 车型实体类
 */
@interface CarType : NSObject
{
    NSInteger typeId;
    NSString *name;
}

/*!
 @property
 @abstract 车型id
 */
@property(nonatomic, assign) NSInteger typeId;

/*!
 @property
 @abstract 车型名称
 */
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger yearId;
@end



