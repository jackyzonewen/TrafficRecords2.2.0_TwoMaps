/*!
 @header    AHMultiViewCell.h
 @abstract  多样选择的View的cell
 @author    张洁
 @version   2.5.0 2013/04/17 Creation
 */

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"


//多样选择的View的cell
@interface AHMultiViewCell : UITableViewCellEx
{
    BOOL     isSelected;      //是否是选择的状态
    
}

/*!
 @property
 @abstract 选择的状态
 */
@property(nonatomic, strong) UIImageView *selectView;
/*!
 @property
 @abstract 是否是选择的状态,注意不是指焦点状态
 */
@property(nonatomic, assign) BOOL isSelected;


/*!
 @method
 @abstract   初始化
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame;
/*!
 @method
 @abstract   获取cell默认的高
 @discussion 获取cell默认的高
 */
+ (CGFloat)getCellDefaultHeight;

@end
