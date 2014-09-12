/*!
 @header    AHSurfacedView.h
 @abstract  浮出效果的选择列表
 @author    张洁
 @version   2.5.0 2013/04/19 Creation
 */

#import <UIKit/UIKit.h>


/*!
 @class
 @abstract  浮出效果的选择列表
 */
@interface AHSurfacedView : UIView
{
    UIImageView *instructionImage;  //弹出位置的指示图片
}

/*!
 @property
 @abstract 弹出位置的指示图片
 */
@property (nonatomic, retain) UIImageView *instructionImage;


/*!
 @method
 @abstract   根据frame初始化
 @discussion 根据frame初始化
 @param      frame 创建的frame大小
 @return     返回AHSurfacedView
 */
- (id)initWithFrame:(CGRect)frame;

@end







