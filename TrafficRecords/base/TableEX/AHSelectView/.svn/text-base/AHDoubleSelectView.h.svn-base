/*!
 @header    AHDoubleSelectView.h
 @abstract  两个Table浮出效果的选择列表
 @author    张洁
 @version   2.5.0 2013/04/19 Creation
 */

#import <UIKit/UIKit.h>
#import "AHMultiSelectView.h"


@class AHMultiSelectView;
@class AHDoubleSelectView;

/*!
 @protocol
 @abstract  两个Table浮出效果的选择列表的代理方法
 */
@protocol AHDoubleSelectViewDelegate<NSObject>

@optional

/*!
 @method
 @abstract   当左边列表选中某一个时调用
 @discussion 当左边列表选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发选中事件的行索引
 */
- (void)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewDidSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当左边列表取消选中某一个时调用
 @discussion 当左边列表取消选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发取消选中事件的行索引
 */
- (void)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewDidCancelSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当左边列表即将选中某一个时调用
 @discussion 当左边列表即将选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发即将选中事件的行索引
 @return     如果返回NO,则不再触发选中事件
 */
- (BOOL)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewShouldSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当左边列表即将取消选中某一个时调用
 @discussion 当左边列表即将取消选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发即将取消选中事件的行索引
 @return     如果返回NO,则不再触发取消选中事件
 */
- (BOOL)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewShouldCancelSelect:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   当右边列表选中某一个时调用
 @discussion 当右边列表选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发选中事件的行索引
 */
- (void)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewDidSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当右边列表取消选中某一个时调用
 @discussion 当右边列表取消选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发取消选中事件的行索引
 */
- (void)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewDidCancelSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当右边列表即将选中某一个时调用
 @discussion 当右边列表即将选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发即将选中事件的行索引
 @return     如果返回NO,则不再触发选中事件
 */
- (BOOL)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewShouldSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当右边列表即将取消选中某一个时调用
 @discussion 当右边列表即将取消选中某一个时调用
 @param      doubleSelectView 触发该事件的AHDoubleSelectView
 @param      index 触发即将取消选中事件的行索引
 @return     如果返回NO,则不再触发取消选中事件
 */
- (BOOL)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewShouldCancelSelect:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   返回左边列表要绘制列表section的页眉View
 @discussion 返回左边列表要绘制列表section的页眉View
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftViewForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回左边列表要绘制列表section的页脚View
 @discussion 返回左边列表要绘制列表section的页脚View
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftViewForFooterInSection:
(NSInteger)section;
/*!
 @method
 @abstract   返回右边列表要绘制列表section的页眉View
 @discussion 返回右边列表要绘制列表section的页眉View
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightViewForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回右边列表要绘制列表section的页脚View
 @discussion 返回右边列表要绘制列表section的页脚View
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightViewForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制左侧列表section的页眉高
 @discussion 返回要绘制左侧列表section的页眉高
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftHeightForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制右侧列表section的页眉高
 @discussion 返回要绘制右侧列表section的页眉高
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉所在索引
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightHeightForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制左侧列表section的页脚高
 @discussion 返回要绘制左侧列表section的页脚高
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页脚所在索引
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftHeightForFooterInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制右侧列表section的页脚高
 @discussion 返回要绘制右侧列表section的页脚高
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页脚所在索引
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightHeightForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   右侧列表即将显示时调用
 @discussion 右侧列表即将显示时调用，手势时也调用
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      leftSelect 左侧列表选中项
 @return     返回YES,则正常显示，否则不显示
 */
- (BOOL)rightSelectViewShouldShow:(AHDoubleSelectView *)doubleSelectView leftSelect:(NSIndexPath *)indexPath;

@end


/*!
 @protocol
 @abstract  两个Table浮出效果的选择列表的数据源方法
 */
@protocol AHDoubleSelectViewDataSource<NSObject>

@required


/*!
 @method
 @abstract   返回左边列表当前section下的行数
 @discussion 返回左边列表当前section下的行数
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      section 要返回个数的section
 */
- (NSInteger)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewNumberOfRowsInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回左边列表当前列表section个数
 @discussion 返回左边列表当前列表section个数
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 */
- (NSInteger)leftSelectViewNumberOfSectionsInTableView:(AHDoubleSelectView *)doubleSelectView;
/*!
 @method
 @abstract   返回左边列表indexPath要绘制的AHMultiViewCell
 @discussion 返回左边列表indexPath要绘制的AHMultiViewCell
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      indexPath 要绘制的indexPath
 */
- (AHMultiViewCell *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   返回左边列表indexPath要绘制的AHMultiViewCell的高
 @discussion 返回左边列表indexPath要绘制的AHMultiViewCell的高
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      indexPath 要绘制的indexPath
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftSelectViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   返回右边列表当前section下的行数
 @discussion 返回右边列表当前section下的行数
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      section 要返回个数的section
 */
- (NSInteger)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewNumberOfRowsInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回右边列表当前列表section个数
 @discussion 返回右边列表当前列表section个数
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 */
- (NSInteger)rightSelectViewNumberOfSectionsInTableView:(AHDoubleSelectView *)doubleSelectView;
/*!
 @method
 @abstract   返回右边列表indexPath要绘制的AHMultiViewCell
 @discussion 返回右边列表indexPath要绘制的AHMultiViewCell
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      indexPath 要绘制的indexPath
 */
- (AHMultiViewCell *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   返回右边列表indexPath要绘制的AHMultiViewCell的高
 @discussion 返回右边列表indexPath要绘制的AHMultiViewCell的高
 @param      doubleSelectView 当前回调的AHDoubleSelectView
 @param      indexPath 要绘制的indexPath
 */
- (CGFloat)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightSelectViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/*!
 @method
 @abstract   返回要绘制左边列表section的页眉标题
 @discussion 返回要绘制左边列表section的页眉标题
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉标题所在索引
 */
- (NSString *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftTitleForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制左边列表section的页脚标题
 @discussion 返回要绘制左边列表section的页脚标题
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页脚标题所在索引
 */
- (NSString *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView leftTitleForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制左边列表的索引列表
 @discussion 返回要绘制左边列表的索引列表
 @param      doubleSelectView 当前回调的doubleSelectView
 @return     要绘制的索引列表
 */
- (NSArray *)leftSectionIndexTitlesForTableView:(AHDoubleSelectView *)doubleSelectView;
/*!
 @method
 @abstract   返回要绘制右边列表section的页眉标题
 @discussion 返回要绘制右边列表section的页眉标题
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页眉标题所在索引
 */
- (NSString *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightTitleForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制右边列表section的页脚标题
 @discussion 返回要绘制右边列表section的页脚标题
 @param      doubleSelectView 当前回调的doubleSelectView
 @param      section 要绘制的页脚标题所在索引
 */
- (NSString *)doubleSelectView:(AHDoubleSelectView *)doubleSelectView rightTitleForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制右边列表的索引列表
 @discussion 返回要绘制右边列表的索引列表
 @param      doubleSelectView 当前回调的doubleSelectView
 @return     要绘制的索引列表
 */
- (NSArray *)rightSectionIndexTitlesForTableView:(AHDoubleSelectView *)doubleSelectView;

@end


/*!
 @class
 @abstract  两个Table浮出效果的选择列表
 */
@interface AHDoubleSelectView : UIView<AHMultiSelectViewDataSource, AHMultiSelectViewDelegate>
{
    
    UIImageView       *instructionImage;  //弹出位置的指示图片
    BOOL              isAutoSize;         //当数据小于Frame时，是否自动处理Frame为数据所占区域
    AHMultiSelectView *leftTableView;     //左边的TableView
    AHMultiSelectView *rightTableView;    //右边的TableView
    UIButton          *splitBtn;          //分隔按钮
    UIButton          *backGroundView;    //背景
}

/*!
 @property
 @abstract 事件的监听委托
 */
@property (nonatomic, weak) id <AHDoubleSelectViewDelegate> delegate;
/*!
 @property
 @abstract 数据源的委托
 */
@property (nonatomic, weak) id <AHDoubleSelectViewDataSource> dataSource;
/*!
 @property
 @abstract 弹出位置的指示图片
 */
@property (nonatomic, strong) UIImageView *instructionImage;
/*!
 @property
 @abstract 当数据小于Frame时，是否自动处理Frame为数据所占区域
 */
@property (nonatomic, assign) BOOL isAutoSize;
/*!
 @property
 @abstract 左边的TableView
 */
@property (nonatomic, readonly) AHMultiSelectView *leftTableView;
/*!
 @property
 @abstract 右边的TableView
 */
@property (nonatomic, readonly) AHMultiSelectView *rightTableView;
/*!
 @property
 @abstract 分隔按钮
 */
@property (nonatomic, retain) UIButton *splitBtn;
/*!
 @property
 @abstract 背景
 */
@property (nonatomic, retain) UIButton *backGroundView;


/*!
 @method
 @abstract   单择方式初始化
 @discussion 单择方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @param      width 左边列表的宽
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWithRadioSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame leftTableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom;
/*!
 @method
 @abstract   多选方式初始化
 @discussion 多选方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @param      width 左边列表的宽
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWithMultiSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame leftTableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom;
/*!
 @method
 @abstract   设置选中行
 @discussion 单选时为取消原选择，多选时为多增加一个选择项
 @param      leftIndexPath  左边列表要选中的行
 @param      rightIndexPath 右边列表要选中的行
 @param      是否发送监听的通知
 */
- (void)setSelectedOfIndexPath:(NSIndexPath *)leftIndexPath rightIndexPath:(NSIndexPath *)rightIndexPath isSendHandle:(BOOL)isHandle;

@end








