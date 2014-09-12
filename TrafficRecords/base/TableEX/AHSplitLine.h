/*!
 @header    AHSplitLine.h
 @abstract  普通分隔线
 @author    兰春红
 @version   2.1.0 2012/11/02 Creation
 */

#import <UIKit/UIKit.h>

enum splitLineOrientation
{
    Portrait        =1,
    Landscape       =2
};

/*!
 @class
 @abstract  普通分隔线
 */
@interface AHSplitLine : UIView

/*!
 @property
 @abstract 上面或左侧的线
 */
@property (nonatomic,retain) UIView * firstLine;

/*!
 @property
 @abstract 下面或右侧的线
 */
@property (nonatomic,retain) UIView * secondLine;

/*!
 @method
 @abstract              　初始化
 @discussion            　初始化
 @param   frame           frame
 @param   orientation     方向
 @param   firstColor      自定义第一条线的颜色
 @param   secondColor     自定义第二条线的颜色
 @result                  返回结果 AHSplitLine
 */
- (id)initWithFrame:(CGRect)frame orientation:(NSInteger)orientation firstLineColor:(UIColor *)firstColor secondLineColor:(UIColor *)secondColor;

/*!
 @method
 @abstract              　设置下划线宽度
 @discussion            　设置下划线宽度
 @param  width            下划线宽度
 @param  orientation     　下划线方向
 @result                  返回结果 void
 */
- (void)setLineWidth:(float)width orientation:(NSInteger)orientation;


/*!
 @method
 @abstract              　设置两条分隔线颜色
 @discussion            　设置两条分隔线颜色
 @param   firstColor      第一条线颜色
 @param   secondColor     第二条线颜色
 @result                  返回结果 void
 */
- (void)setFirstLineColor:(UIColor *)firstColor secondLineColor:(UIColor *)secondColor;

@end
