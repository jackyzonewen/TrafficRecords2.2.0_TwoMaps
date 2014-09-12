/*!
 @header    AHMultiSelectView.h
 @abstract  多样选择的View
 @author    张洁
 @version   2.5.0 2013/04/17 Creation
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class AHMultiSelectView;
@class AHMultiViewCell;
@class TableViewEx;


//选择方式
typedef enum
{
    RadioSelect,   //单选
    MultiSelect    //多选
} SelectStyle;


/*!
 @protocol
 @abstract  多样式选择的代理方法
 */
@protocol AHMultiSelectViewDelegate<NSObject>

@optional

/*!
 @method
 @abstract   当选中某一个时调用
 @discussion 当选中某一个时调用
 @param      multiSelectView 触发选中事件的multiSelectView
 @param      index 触发选中事件的行索引
 */
- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当取消选中某一个时调用
 @discussion 当取消选中某一个时调用
 @param      multiSelectView 触发取消选中事件的multiSelectView
 @param      index 触发取消选中事件的行索引
 */
- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didCancelSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当即将选中某一个时调用
 @discussion 当即将选中某一个时调用
 @param      multiSelectView 触发即将选中事件的multiSelectView
 @param      index 触发即将选中事件的行索引
 @return     如果返回NO,则不再触发选中事件
 */
- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当即将取消选中某一个时调用
 @discussion 当即将取消选中某一个时调用
 @param      multiSelectView 触发即将取消选中事件的multiSelectView
 @param      index 触发即将取消选中事件的行索引
  @return     如果返回NO,则不再触发取消选中事件
 */
- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldCancelSelect:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   返回要绘制列表section的页眉View
 @discussion 返回要绘制列表section的页眉View
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制列表section的页脚View
 @discussion 返回要绘制列表section的页脚View
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页脚所在索引
 */
- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制列表section的页眉高
 @discussion 返回要绘制列表section的页眉高
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页眉所在索引
 */
- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制列表section的页脚高
 @discussion 返回要绘制列表section的页脚高
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页脚所在索引
 */
- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   当即拖拽时调用
 @discussion 当即拖拽时调用
 @param      multiSelectView 触发当即拖拽时调用事件的multiSelectView
 */
- (void)willBeginDragging:(AHMultiSelectView *)multiSelectView;

/*!
 @method
 @abstract   当载入数据时调用
 @discussion 触发reloadData时调用
 @param      multiSelectView 触发当即拖拽时调用事件的multiSelectView
 */
- (void)didReloadData:(AHMultiSelectView *)multiSelectView;

@end


/*!
 @protocol
 @abstract  AHMultiSelectView的数据源方法
 */
@protocol AHMultiSelectViewDataSource<NSObject>

@required

/*!
 @method
 @abstract   返回当前section下的行数
 @discussion 返回当前section下的行数
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要返回个数的section
 */
- (NSInteger)multiSelectView:(AHMultiSelectView *)multiSelectView numberOfRowsInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回当前列表section个数
 @discussion 返回当前列表section个数
 @param      multiSelectView 当前回调的multiSelectView
 */
- (NSInteger)numberOfSectionsInTableView:(AHMultiSelectView *)multiSelectView;
/*!
 @method
 @abstract   返回indexPath要绘制的AHMultiViewCell
 @discussion 返回indexPath要绘制的AHMultiViewCell
 @param      multiSelectView 当前回调的multiSelectView
 @param      indexPath 要绘制的indexPath
 */
- (AHMultiViewCell *)multiSelectView:(AHMultiSelectView *)multiSelectView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   返回indexPath要绘制的AHMultiViewCell的高
 @discussion 返回indexPath要绘制的AHMultiViewCell的高
 @param      multiSelectView 当前回调的multiSelectView
 @param      indexPath 要绘制的indexPath
 */
- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   返回要绘制section的页眉标题
 @discussion 返回要绘制section的页眉标题
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页眉标题所在索引
 */
- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制section的页脚标题
 @discussion 返回要绘制section的页脚标题
 @param      multiSelectView 当前回调的multiSelectView
 @param      section 要绘制的页脚标题所在索引
 */
- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制的索引列表
 @discussion 返回要绘制的索引列表
 @param      multiSelectView 当前回调的multiSelectView
 @return     要绘制的索引列表
 */
- (NSArray *)sectionIndexTitlesForTableView:(AHMultiSelectView *)multiSelectView;

@end


/*!
 @class
 @abstract  多样选择的View
 */
@interface AHMultiSelectView : UIButton <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    TableViewEx *selectTableView;   //选择的列表
    UIImage     *selectedImage;     //选中时的状态显示图片
    UIImage     *unSelectedImage;   //未选中时的状态显示图片
    SelectStyle selectStyle;        //选择方式
    BOOL        isAutoSize;         //当数据小于Frame时，是否自动处理Frame为数据所占区域
    NSIndexPath *selectedIndexPath; //当前选择项的索引,只有单选起作用
    BOOL        isShowState;        //是否显示选中状态,只对单选起作用
}

/*!
 @property
 @abstract 事件的监听委托
 */
@property (nonatomic, weak) id <AHMultiSelectViewDelegate> delegate;
/*!
 @property
 @abstract 数据源的委托
 */
@property (nonatomic, weak) id <AHMultiSelectViewDataSource> dataSource;
/*!
 @property
 @abstract 选择的列表
 */
@property (nonatomic, retain) TableViewEx *selectTableView;
/*!
 @property
 @abstract 选中时的状态显示图片
 */
@property (nonatomic, retain) UIImage *selectedImage;
/*!
 @property
 @abstract 未选中时的状态显示图片
 */
@property (nonatomic, retain) UIImage *unSelectedImage;
/*!
 @property
 @abstract 当前选择项的索引，只有单选起作用
 */
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
/*!
 @property
 @abstract 选择方式
 */
@property (nonatomic, assign) SelectStyle selectStyle;
/*!
 @property
 @abstract 当数据小于Frame时，是否自动处理Frame为数据所占区域
 */
@property (nonatomic, assign) BOOL isAutoSize;
/*!
 @property
 @abstract 是否显示选中状态,只对单选起作用
 */
@property (nonatomic, assign) BOOL isShowState;


/*!
 @method
 @abstract   单择方式初始化
 @discussion 单择方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWithRadioSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom;
/*!
 @method
 @abstract   多选方式初始化
 @discussion 多选方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWithMultiSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom;
/*!
 @method
 @abstract   标记此CELL是删除还是取消
 @discussion 单选时为取消原选择，多选时为多增加一个选择项
 @param      cell 要处理的CELL
 @param      是否发送监听的通知
 */
- (void)cellSelectedOrCancel:(AHMultiViewCell *)cell isSendHandle:(BOOL)isHandle;
/*!
 @method
 @abstract   设置选中行
 @discussion 单选时为取消原选择，多选时为多增加一个选择项
 @param      indexPath 要选中的行
 @param      是否发送监听的通知
 */
- (void)setSelectedOfIndexPath:(NSIndexPath *)indexPath isSendHandle:(BOOL)isHandle;
/*!
 @method
 @abstract   获取所有选中项
 @discussion 支持多选时获取
 @param      indexPath 要选中的索引
 */
- (NSArray *)indexPathsForSelected;
/*!
 @method
 @abstract   重新载入列表数据
 @discussion 重新载入列表数据
 */
- (void)reloadData;

@end







