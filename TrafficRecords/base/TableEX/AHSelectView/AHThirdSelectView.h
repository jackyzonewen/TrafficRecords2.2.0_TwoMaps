//
//  AHThirdSelectView.h
//  UsedCar2
//
//  Created by qiao on 13-7-3.
//  Copyright (c) 2013年 che168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHMultiSelectView.h"

@class AHMultiSelectView;
@class AHThirdSelectView;

#define TABLEVIEW_BELEFT_WIDTH (float)78
#define TABLEVIEW_INSETBOTTOM_HEIGHT (float)49.0
#define TABLEVIEW_STEPNUMS (int)3

/*!
 @protocol
 @abstract  两个Table浮出效果的选择列表的代理方法
 */
@protocol AHThirdSelectViewDelegate<NSObject>

@optional

/*!
 @method
 @abstract   当table列表选中某一个时调用
 @discussion 当table列表选中某一个时调用
 @param      index 触发选中事件的行索引
 */
- (void)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table DidSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当table列表取消选中某一个时调用
 @discussion 当table列表取消选中某一个时调用
 @param      index 触发取消选中事件的行索引
 */
- (void)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table DidCancelSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当table列表即将选中某一个时调用
 @discussion 当table列表即将选中某一个时调用
 @param      index 触发即将选中事件的行索引
 @return     如果返回NO,则不再触发选中事件
 */
- (BOOL)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ShouldSelect:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   当table列表即将取消选中某一个时调用
 @discussion 当table列表即将取消选中某一个时调用
 @param      index 触发即将取消选中事件的行索引
 @return     如果返回NO,则不再触发取消选中事件
 */
- (BOOL)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ShouldCancelSelect:(NSIndexPath *)indexPath;

/*!
 @method
 @abstract   返回table列表要绘制列表section的页眉View
 @discussion 返回table列表要绘制列表section的页眉View
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ViewForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回table列表要绘制列表section的页脚View
 @discussion 返回table列表要绘制列表section的页脚View
 @param      section 要绘制的页眉所在索引
 */
- (UIView *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ViewForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制table列表section的页眉高
 @discussion 返回要绘制table列表section的页眉高
 @param      section 要绘制的页眉所在索引
 */
- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table HeightForHeaderInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制table列表section的页脚高
 @discussion 返回要绘制table列表section的页脚高
 @param      section 要绘制的页脚所在索引
 */
- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table HeightForFooterInSection:(NSInteger)section;

@end


/*!
 @protocol
 @abstract  两个Table浮出效果的选择列表的数据源方法
 */
@protocol AHThirdSelectViewDataSource<NSObject>

@required


/*!
 @method
 @abstract   返回table列表当前section下的行数
 @discussion 返回table列表当前section下的行数
 @param      section 要返回个数的section
 */
- (NSInteger)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table NumberOfRowsInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回table列表当前列表section个数
 @discussion 返回table列表当前列表section个数
 @param      thirdSelectView
 */
- (NSInteger)thirdSelectView:(AHThirdSelectView *)thirdSelectView  numOfSectionsInTableView:(AHMultiSelectView *) table;
/*!
 @method
 @abstract   返回table列表indexPath要绘制的AHMultiViewCell
 @discussion 返回table列表indexPath要绘制的AHMultiViewCell
 @param      indexPath 要绘制的indexPath
 */
- (AHMultiViewCell *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table CellForRowAtIndexPath:(NSIndexPath *)indexPath;
/*!
 @method
 @abstract   返回table列表indexPath要绘制的AHMultiViewCell的高
 @discussion 返回table列表indexPath要绘制的AHMultiViewCell的高
 @param      indexPath 要绘制的indexPath
 */
- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView  tableView:(AHMultiSelectView *) table HeightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/*!
 @method
 @abstract   返回要绘制table列表section的页眉标题
 @discussion 返回要绘制table列表section的页眉标题
 @param      section 要绘制的页眉标题所在索引
 */
- (NSString *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table TitleForHeaderInSection:(NSInteger)section;
/*!
 @method
 @abstract   返回要绘制table列表section的页脚标题
 @discussion 返回要绘制table列表section的页脚标题
 @param      section 要绘制的页脚标题所在索引
 */
- (NSString *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table TitleForFooterInSection:(NSInteger)section;

/*!
 @method
 @abstract   返回要绘制table列表的索引列表
 @discussion 返回要绘制table列表的索引列表
 @return     要绘制的索引列表
 */
- (NSArray *)thirdSelectView:(AHThirdSelectView *)thirdSelectView SectionIndexTitlesForTableView:(AHMultiSelectView *) table;
@end

@interface AHThirdSelectView : UIView<AHMultiSelectViewDataSource, AHMultiSelectViewDelegate>
{
    BOOL              isAutoSize;         //当数据小于Frame时，是否自动处理Frame为数据所占区域
    UIButton          *backGroundView;    //背景
    int               viewsTag;
    TableViewEx       *touchedTable;
}

@property (nonatomic, retain) NSMutableArray    *tableArray;
/*!
 @property
 @abstract 事件的监听委托
 */
@property (nonatomic, weak) id <AHThirdSelectViewDelegate> delegate;
/*!
 @property
 @abstract 数据源的委托
 */
@property (nonatomic, weak) id <AHThirdSelectViewDataSource> dataSource;
/*!
 @property
 @abstract 当数据小于Frame时，是否自动处理Frame为数据所占区域
 */
@property (nonatomic, assign) BOOL isAutoSize;
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
 @param      num 列表级数
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame nums:(int) num TableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom;

/*!
 @method
 @abstract   单择方式初始化
 @discussion 单择方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @return     返回AHMultiSelectView
 */
- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame;

/*!
 @method
 @abstract   单择方式初始化
 @discussion 单择方式初始化
 @param      frame 创建的frame大小
 @param      style 创建的列表的显示方式
 @param      width1 1级列表的宽
 @param      width2 后续列表的宽
 @param      num 列表级数
 @param      insetBottom TableView距离底部的间距
 @return     返回AHMultiSelectView
 */
- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame nums:(int) num gap1:(int)width1  gap2:(int)width2 tableInsetBottom:(NSInteger)insetBottom;

/*!
 @method
 @abstract   设置选中行
 @discussion 单选时为取消原选择，多选时为多增加一个选择项
 @param      indexPathArray  要选中的行的数组
 @param      是否发送监听的通知
 */
- (void)setSelectedIndexPaths:(NSArray *) indexPathArray isSendHandle:(BOOL)isHandle;

/*
 @method
 @abstract   获取multiSelectView在多级列表中的第几级
 @discussion 获取multiSelectView在多级列表中的第几级
 @param      multiSelectView 要获取的tableview
 @return     第多少级
 */
-(NSUInteger ) indexOfTableView:(AHMultiSelectView *)multiSelectView;
-(void) asyreloadTableView:(NSNumber *) index;
/*
 @method
 @abstract   重载第index级TableView
 @discussion 重载第index级TableView，隐藏此级以下的所有级
 @param      index要重载的TableView的索引
 */
-(void) reloadTableView: (NSUInteger) index;
-(void) closeTableView:(AHMultiSelectView *)multiSelectView;
-(void) closeTableViewWithIndex:(NSNumber *)index;
/*!
 @method
 @abstract   获取所有选中项
 @discussion 支持多选时获取
 @param      indexPath 要选中的索引
 */
-(NSArray *) indexPathsForSelected;

- (void)showtableView:(AHMultiSelectView *) table index:(NSIndexPath *)indexPath;

@end
