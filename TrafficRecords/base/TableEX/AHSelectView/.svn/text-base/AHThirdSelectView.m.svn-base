//
//  AHThirdSelectView.m
//  UsedCar2
//
//  Created by qiao on 13-7-3.
//  Copyright (c) 2013年 che168. All rights reserved.
//

#import "AHThirdSelectView.h"
#import "UIView+ViewFrameGeometry.h"
#import "AHMultiSelectView.h"
#import "AHMultiViewCell.h"
#import "TableViewEx.h"

@implementation AHThirdSelectView

@synthesize delegate;
@synthesize dataSource;
@synthesize backGroundView;
@synthesize isAutoSize;
@synthesize tableArray;

//关闭右侧选择界面
- (void)closetableView:(AHMultiSelectView *) table
{
    AHMultiSelectView *realTable = table;
    if (![table isKindOfClass:[AHMultiSelectView class]]) {
        //两个btn的点击事件也会调用closetableView
        //btn的tag分别是整百+1，整百+2，table为整百+3
        NSInteger tableTag = table.tag/100;
        tableTag = tableTag * 100 + 3;
        realTable = (AHMultiSelectView*)[self viewWithTag:tableTag];
    } 
    NSInteger index = [self indexOfTableView:realTable];
    for (NSInteger i = index; i < self.tableArray.count; i++) {
        AHMultiSelectView *tableView = [self.tableArray objectAtIndex:i];
        if (tableView.superview != nil && tableView.selectTableView.moveSuperView.hidden == NO) {
            [tableView.selectTableView contractionNoAnimation];
        }
    }
}


//显示右侧选择界面
- (void)showtableView:(AHMultiSelectView *) table index:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(thirdSelectView:tableView:ShouldSelect:)])
    {
        if (![delegate thirdSelectView:self tableView:table ShouldSelect:indexPath])
        {
            [self closetableView:table];
            return;
        }
    }
    UIButton *bgBtn = (UIButton*)[self viewWithTag:table.tag - 2];
    if (table.superview == nil)
    {
        [bgBtn addSubview:table];
    }
    [table.selectTableView restoreViewLocation];
}

- (AHMultiSelectView *) createTableView:(SelectStyle) selectstyle tableStyle: (UITableViewStyle)style frame:(CGRect)frame {
    //btn和table间的关系依赖与tag值
    viewsTag += 100;
    UIButton* bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [bgBtn addTarget: self action:@selector(closetableView:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableSplitBg.png"]]];
//    [bgBtn setBackgroundImage:[UIImage imageNamed:@"TableSplitBg.png"] forState:UIControlStateNormal];
    bgBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    UIView * preView = nil;
    if (self.tableArray.count >= 1) {
        preView = [self.tableArray objectAtIndex:self.tableArray.count - 1];
    }
    
    bgBtn.frame = CGRectMake(frame.origin.x - preView.origin.x, frame.origin.y, frame.size.width + preView.origin.x, frame.size.height);
    [preView addSubview:bgBtn];
    [bgBtn setHidden:YES];
    bgBtn.tag = viewsTag + 1;
    
//    UIImage *background = [UIImage imageNamed:@"CrossBtnBg.png"];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundColor:[UIColor clearColor]];
//    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [btn addTarget: self action:@selector(closetableView:) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(4, frame.size.height/2 - background.size.height/2, background.size.width, background.size.height);
//    [btn setBackgroundImage: background forState:UIControlStateNormal];
//    [btn setBackgroundImage:background forState:UIControlStateHighlighted];
//    [bgBtn addSubview:btn];
//    btn.tag = viewsTag + 2;

    CGRect tableRect = bgBtn.bounds;
    tableRect.origin.x += 1;
    AHMultiSelectView * tableView = nil;
    if (selectstyle == RadioSelect) {
        tableView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:tableRect tableInsetBottom:0];
    } else {
        tableView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:tableRect tableInsetBottom:0];
    }
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.selectTableView.moveSuperView = bgBtn;
    tableView.tag = viewsTag + 3;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, tableView.height)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [bgBtn addSubview:line];
    return tableView;
}

-(NSUInteger ) indexOfTableView:(AHMultiSelectView *)multiSelectView{
    return  [self.tableArray indexOfObject:multiSelectView];
}

-(void) asyreloadTableView:(NSNumber *) index{
    [self reloadTableView:index.intValue];
}

-(void) reloadTableView: (NSUInteger) index {
    for (NSInteger i = index; i <=  self.tableArray.count - 1; i++) {
        AHMultiSelectView *tableView = [self.tableArray objectAtIndex:i];
        if (i == index) {
            [tableView.selectTableView reloadData];
        } else {
            [tableView.selectTableView contractionRestoreViewLocation];
        }
    }
}

-(void) closeTableView:(AHMultiSelectView *)multiSelectView {
    NSInteger index = [self.tableArray indexOfObject:multiSelectView];
    for (NSInteger i = index; i <=  self.tableArray.count - 1; i++) {
        AHMultiSelectView *tableView = [self.tableArray objectAtIndex:i];
        [tableView.selectTableView contractionRestoreViewLocation];
    }
}

-(void) closeTableViewWithIndex:(NSNumber *)index{
    for (int i = index.intValue; i <=  self.tableArray.count - 1; i++) {
        AHMultiSelectView *tableView = [self.tableArray objectAtIndex:i];
        [tableView.selectTableView contractionRestoreViewLocation];
    }
}

-(NSArray *) indexPathsForSelected {
    NSMutableArray *result = [NSMutableArray array];
    for (AHMultiSelectView *tableView in self.tableArray) {
        NSArray *selected = [tableView.selectTableView indexPathsForSelectedRows];
        if (selected == nil) {
            break;
        }
        [result addObject:selected];
    }
    return result;
}

- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame nums:(int) num TableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBackground];
        self.frame = frame;
        self.tableArray = [NSMutableArray array];
        AHMultiSelectView* firstView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:CGRectMake(0, 0, self.width, self.height - insetBottom) tableInsetBottom:0];
        firstView.delegate = self;
        firstView.dataSource = self;
        [self addSubview:firstView];
        [self.tableArray addObject:firstView];
        
        CGRect tableRect = CGRectMake(width, 0, frame.size.width - width, frame.size.height - insetBottom);
        for (int i = 0; i < num - 1; i++) {
            AHMultiSelectView *table = [self createTableView:selectstyle tableStyle:UITableViewStylePlain frame:tableRect];
            tableRect.size.width -= width;
            [self.tableArray addObject: table];
        }
    }
    return self;
}

- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame{
    return [self initWith:selectstyle tabStyle:style frame:frame nums:TABLEVIEW_STEPNUMS TableWidth:TABLEVIEW_BELEFT_WIDTH tableInsetBottom:TABLEVIEW_INSETBOTTOM_HEIGHT];
}

- (id)initWith:(SelectStyle) selectstyle tabStyle:(UITableViewStyle)style frame:(CGRect)frame nums:(int) num gap1:(int)width1  gap2:(int)width2 tableInsetBottom:(NSInteger)insetBottom{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBackground];
        self.frame = frame;
        self.tableArray = [NSMutableArray array];
        AHMultiSelectView* firstView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:CGRectMake(0, 0, self.width, self.height - insetBottom) tableInsetBottom:0];
        firstView.delegate = self;
        firstView.dataSource = self;
        [self addSubview:firstView];
        [self.tableArray addObject:firstView];
        
        CGRect tableRect = CGRectMake(width1, 0, frame.size.width - width1, frame.size.height - insetBottom);
        for (int i = 0; i < num - 1; i++) {
            AHMultiSelectView *table = [self createTableView:selectstyle tableStyle:UITableViewStylePlain frame:tableRect];
            tableRect.size.width -= width2;
            tableRect.origin.x = width2;
            [self.tableArray addObject: table];
        }
    }
    return self;
}

//创建半透明背景效果
- (void)initBackground
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_GlobTouchEvent object:nil];
    self.backGroundView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [backGroundView setBackgroundColor:[UIColor blackColor]];
    [backGroundView setAlpha:0.7];
    
    [backGroundView addTarget:self action:@selector(performClose) forControlEvents:UIControlEventTouchUpInside];
    
    backGroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self insertSubview:backGroundView atIndex:0];
    self.hidden = NO;
}

- (void)performClose
{
    [self setHidden:YES];
}

- (void)setIsAutoSize:(BOOL)autoSize
{
    isAutoSize = autoSize;
    for (AHMultiSelectView * tableView in self.tableArray) {
        tableView.isAutoSize = autoSize;
    }
}
- (void)setSelectedIndexPaths:(NSArray *) indexPathArray isSendHandle:(BOOL)isHandle{
    for (int i = 0; i < indexPathArray.count; i++) {
        NSIndexPath *path = [indexPathArray objectAtIndex:i];
        if (i < self.tableArray.count) {
            AHMultiSelectView *tableView = [self.tableArray objectAtIndex:i];
            [tableView setSelectedOfIndexPath:path isSendHandle:isHandle];
        } else {
            return;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
    self.backGroundView = nil;
    self.tableArray = nil;
}

- (void) notifyMessage:(NSNotification*) notifyMsg{
    if ([notifyMsg.name isEqualToString:KNotification_GlobTouchEvent]) {
        UIEvent *event = notifyMsg.object;
        UITouch *touch = [[event allTouches] anyObject];
        TableViewEx *table = nil;
        UIResponder *responder = touch.view;
        while (responder != nil && ![responder isKindOfClass:[TableViewEx class]]) {
            responder = responder.nextResponder;
        }
        table = (TableViewEx *)responder;
        if (responder == nil || ![responder isKindOfClass:[TableViewEx class]]) {
            //防止拖动中手指滑出屏幕或者控件区域，此时touch.view为nil
            if (touchedTable && (touch.phase ==  UITouchPhaseEnded  || touch.phase ==  UITouchPhaseCancelled)) {
                [table touchesEnded:[event allTouches] withEvent:event];
            }
            return;
        }
        touchedTable = table;
        if (touch.phase ==  UITouchPhaseBegan) {
            [table BeganMove:[event allTouches] withEvent:event];
        }
        else if(touch.phase ==  UITouchPhaseMoved) {
            [table Moving:[event allTouches] withEvent:event];
        }
        else if(touch.phase ==  UITouchPhaseEnded) {
            [table EndedMove:[event allTouches] withEvent:event];
        }
        else if(touch.phase ==  UITouchPhaseCancelled) {
            [table EndedMove:[event allTouches] withEvent:event];
        }
    }
}

#pragma mark -
#pragma mark AHMultiSelectView Data Source Methods

- (NSInteger)multiSelectView:(AHMultiSelectView *)multiSelectView numberOfRowsInSection:(NSInteger)section {
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:tableView:NumberOfRowsInSection:)])
    {
        return [dataSource thirdSelectView: self tableView: multiSelectView NumberOfRowsInSection: section];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(AHMultiSelectView *)multiSelectView {
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:numOfSectionsInTableView:)]) {
        return [dataSource thirdSelectView:self numOfSectionsInTableView:multiSelectView];
    }
    return 0;
}

- (AHMultiViewCell *)multiSelectView:(AHMultiSelectView *)multiSelectView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:tableView:CellForRowAtIndexPath:)]) {
        return [dataSource thirdSelectView:self tableView:multiSelectView CellForRowAtIndexPath:indexPath];
    }
    return 0;
}


- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:tableView:HeightForRowAtIndexPath:)]) {
        return [dataSource thirdSelectView:self tableView:multiSelectView HeightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForHeaderInSection:(NSInteger)section{
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:tableView:TitleForHeaderInSection:)]) {
        return [dataSource thirdSelectView:self tableView:multiSelectView TitleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForFooterInSection:(NSInteger)section{
    if(dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:tableView:TitleForFooterInSection:)]){
        return [dataSource thirdSelectView:self tableView:multiSelectView TitleForFooterInSection:section];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(AHMultiSelectView *)multiSelectView {
    if (dataSource != nil && [dataSource respondsToSelector:@selector(thirdSelectView:SectionIndexTitlesForTableView:)]) {
        return [dataSource thirdSelectView:self SectionIndexTitlesForTableView:multiSelectView];
    }
    return nil;
}

#pragma mark -
#pragma mark AHMultiSelectViewDelegate Methods

- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didSelect:(NSIndexPath *)indexPath {
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:DidSelect:)]) {
        [delegate thirdSelectView:self tableView:multiSelectView DidSelect:indexPath];
        NSInteger index = [self indexOfTableView:multiSelectView];
        if (index != self.tableArray.count - 1) {
            [self showtableView:[self.tableArray objectAtIndex:index + 1] index:indexPath];
        }
    }
}

- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didCancelSelect:(NSIndexPath *)indexPath{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:DidCancelSelect:)]) {
        [delegate thirdSelectView:self tableView:multiSelectView DidCancelSelect:indexPath];
    }
}

- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldSelect:(NSIndexPath *)indexPath{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:ShouldSelect:)]) {
        return [delegate thirdSelectView:self tableView:multiSelectView ShouldSelect:indexPath];
    }
    return YES;
}

- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldCancelSelect:(NSIndexPath *)indexPath{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:ShouldCancelSelect:)]) {
        return [delegate thirdSelectView:self tableView:multiSelectView ShouldCancelSelect:indexPath];
    }
    return YES;
}

- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForHeaderInSection:(NSInteger)section{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:ViewForHeaderInSection: )]) {
        return [delegate thirdSelectView:self tableView:multiSelectView ViewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForFooterInSection:(NSInteger)section{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:ViewForFooterInSection:)]) {
        return [delegate thirdSelectView:self tableView:multiSelectView ViewForFooterInSection:section];
    }
    return nil;
}

- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForHeaderInSection:(NSInteger)section {
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:HeightForHeaderInSection:)]) {
        return [delegate thirdSelectView:self tableView:multiSelectView HeightForHeaderInSection:section];
    }
    return 0.0f;
}

- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForFooterInSection:(NSInteger)section{
    if (delegate != nil && [delegate respondsToSelector:@selector(thirdSelectView:tableView:HeightForFooterInSection:)]) {
        return [delegate thirdSelectView:self tableView:multiSelectView HeightForFooterInSection:section];
    }
    return 0.0f;
}

- (void)willBeginDragging:(AHMultiSelectView *)multiSelectView{
    NSInteger index = [self indexOfTableView:multiSelectView];
    if (index < self.tableArray.count - 1) {
        [self closetableView:[self.tableArray objectAtIndex:index + 1]];
    }
}

- (void) didReloadData:(AHMultiSelectView *)multiSelectView{
    
}

@end
