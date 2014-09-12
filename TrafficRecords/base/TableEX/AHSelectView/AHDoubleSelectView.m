/*!
 @header    AHDoubleSelectView.h
 @abstract  两个Table浮出效果的选择列表
 @author    张洁
 @version   2.5.0 2013/04/19 Creation
 */

#import "AHDoubleSelectView.h"
#import "UIView+ViewFrameGeometry.h"
#import "AHMultiSelectView.h"
#import "AHMultiViewCell.h"
#import "TableViewEx.h"


@interface AHDoubleSelectView()
{
    UIButton  *rightBgView;    //右侧列表的背景View
    UIButton  *splitBgBtn;
    NSInteger leftWidth;       //左边列表的宽
}

/*!
 @property
 @abstract 右侧列表的背景View
 */
@property (nonatomic, retain) UIButton *rightBgView;
/*!
 @property
 @abstract 右侧列表的背景View
 */
@property (nonatomic, retain) UIButton *splitBgBtn;
/*!
 @property
 @abstract 左边列表的宽
 */
@property (nonatomic, assign) NSInteger leftWidth;

@end


@implementation AHDoubleSelectView

@synthesize delegate;
@synthesize dataSource;
@synthesize instructionImage;
@synthesize backGroundView;
@synthesize leftTableView;
@synthesize rightTableView;
@synthesize isAutoSize;
@synthesize splitBtn;
@synthesize leftWidth;
@synthesize rightBgView;
@synthesize splitBgBtn;


//初始化控件
- (void)initControl:(NSInteger)insetBottom
{
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    
    [self addSubview:leftTableView];
    
    rightBgView = [[UIButton alloc] initWithFrame:CGRectMake(self.leftWidth - 4, 0, self.width - self.leftWidth, self.height - insetBottom)];
    [rightBgView setBackgroundColor:[UIColor clearColor]];
    rightBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:rightBgView];
    [rightBgView addSubview:splitBgBtn];
    [rightBgView addSubview:splitBtn];
    rightTableView.selectTableView.moveSuperView = rightBgView;
    
    [self initBackground];
    [rightBgView setHidden:YES];
}


//初始化两个Table之间分隔标志
- (void)initSplitView:(int)drawX
{
    UIImage *rawBackground = [UIImage imageNamed:@"CrossBtnBg.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:7 topCapHeight:0];
    splitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    splitBtn.height = leftTableView.height;
    [splitBtn setBackgroundColor:[UIColor clearColor]];
    splitBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [splitBtn addTarget: self action:@selector(closeRightSelectView) forControlEvents:UIControlEventTouchUpInside];
    splitBtn.frame = CGRectMake(drawX, 0, rawBackground.size.width, splitBtn.height);
    [splitBtn setBackgroundImage: background forState:UIControlStateNormal];
    [splitBtn setBackgroundImage:background forState:UIControlStateHighlighted];
    
    splitBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    splitBgBtn.height = leftTableView.height;
    splitBgBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [splitBgBtn addTarget: self action:@selector(closeRightSelectView) forControlEvents:UIControlEventTouchUpInside];
    splitBgBtn.frame = CGRectMake(drawX + 4, 0, self.width - self.leftWidth + 4, splitBtn.height);
    [splitBgBtn setBackgroundColor:[UIColor whiteColor]];
    splitBgBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

}


//关闭右侧选择界面
- (void)closeRightSelectView
{
    [rightTableView.selectTableView contractionRestoreViewLocation];
}


//显示右侧选择界面
- (void)showRightSelectView:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(rightSelectViewShouldShow: leftSelect:)])
    {
        if (![delegate rightSelectViewShouldShow:self leftSelect:indexPath])
        {
            [self closeRightSelectView];
            return;
        }
    }
    
    if (rightTableView.superview == nil)
    {
        [rightBgView addSubview:rightTableView];
    }
    [rightTableView.selectTableView restoreViewLocation];
}


- (id)initWithRadioSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame leftTableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leftWidth = width;
        self.frame = frame;
        leftTableView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:CGRectMake(0, 0, self.width, self.height - insetBottom) tableInsetBottom:0];
        [self initSplitView:0];
        rightTableView = [[AHMultiSelectView alloc] initWithRadioSelectStyle:style initFrame:CGRectMake(splitBtn.origin.x + splitBtn.width + 3, 0, self.width - width - splitBtn.width + 4, self.height - insetBottom) tableInsetBottom:0];
        leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self initControl:insetBottom];
    }
    return self;
}


- (id)initWithMultiSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame leftTableWidth:(int)width tableInsetBottom:(NSInteger)insetBottom
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leftWidth = width;
        self.frame = frame;
        leftTableView = [[AHMultiSelectView alloc] initWithMultiSelectStyle:style initFrame:CGRectMake(0, 0, self.width, self.height - insetBottom) tableInsetBottom:0];
        [self initSplitView:0];
        rightTableView = [[AHMultiSelectView alloc] initWithMultiSelectStyle:style initFrame:CGRectMake(splitBtn.origin.x + splitBtn.width - 1, 0, self.width - width - splitBtn.width + 4, self.height - insetBottom) tableInsetBottom:0];
        leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self initControl:insetBottom];
    }
    return self;
}


//创建指示图效果
- (void)initInstructionView
{
    instructionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RadioSel.png"]];
    instructionImage.frame = CGRectMake((self.width - instructionImage.width) / 2, 0, instructionImage.width, instructionImage.height);
    [self addSubview:instructionImage];
}


//创建半透明背景效果
- (void)initBackground
{
    backGroundView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [backGroundView setBackgroundColor:[UIColor blackColor]];
    [backGroundView setAlpha:0.7];
    
   // [backGroundView addTarget:self action:@selector(performClose) forControlEvents:UIControlEventTouchUpInside];
    
    backGroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self insertSubview:backGroundView atIndex:0];
}


- (void)setIsAutoSize:(BOOL)autoSize
{
    isAutoSize = autoSize;
    leftTableView.isAutoSize = isAutoSize;
    rightTableView.isAutoSize = isAutoSize;
}


- (void)setSelectedOfIndexPath:(NSIndexPath *)leftIndexPath rightIndexPath:(NSIndexPath *)rightIndexPath isSendHandle:(BOOL)isHandle
{
    [leftTableView setSelectedOfIndexPath:leftIndexPath isSendHandle:isHandle];
    [rightTableView setSelectedOfIndexPath:rightIndexPath isSendHandle:isHandle];
}


- (void)performClose
{
    [self removeFromSuperview];
}


- (void)dealloc
{
    self.backGroundView = nil;
    self.instructionImage = nil;
    self.backGroundView = nil;
    self.splitBgBtn = nil;
    if (leftTableView != nil)
    {
        leftTableView = nil;
    }
    if (rightTableView != nil)
    {
        rightTableView = nil;
    }
    self.instructionImage = nil;
    self.rightBgView = nil;
}


#pragma mark -
#pragma mark AHMultiSelectView Data Source Methods

- (NSInteger)multiSelectView:(AHMultiSelectView *)multiSelectView numberOfRowsInSection:(NSInteger)section
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: leftSelectViewNumberOfRowsInSection:)])
            {
                return [dataSource doubleSelectView:self leftSelectViewNumberOfRowsInSection:section];
            }

        }
        else
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: rightSelectViewNumberOfRowsInSection:)])
            {
                return [dataSource doubleSelectView:self rightSelectViewNumberOfRowsInSection:section];
            }
        }
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(AHMultiSelectView *)multiSelectView
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(leftSelectViewNumberOfSectionsInTableView:)])
            {
                return [dataSource leftSelectViewNumberOfSectionsInTableView:self];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(rightSelectViewNumberOfSectionsInTableView:)])
            {
                return [dataSource rightSelectViewNumberOfSectionsInTableView:self];
            }
        }
    }
    return 0;
}


- (AHMultiViewCell *)multiSelectView:(AHMultiSelectView *)multiSelectView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: leftSelectViewCellForRowAtIndexPath:)])
            {
                return [dataSource doubleSelectView:self leftSelectViewCellForRowAtIndexPath:indexPath];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: rightSelectViewCellForRowAtIndexPath:)])
            {
                return [dataSource doubleSelectView:self rightSelectViewCellForRowAtIndexPath:indexPath];
            }
        }
    }
	return nil;

}


- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: leftSelectViewHeightForRowAtIndexPath:)])
            {
                return [dataSource doubleSelectView:self leftSelectViewHeightForRowAtIndexPath:indexPath];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: rightSelectViewHeightForRowAtIndexPath:)])
            {
                return [dataSource doubleSelectView:self rightSelectViewHeightForRowAtIndexPath:indexPath];
            }
        }
    }
    return [AHMultiViewCell getCellDefaultHeight];
}


- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForHeaderInSection:(NSInteger)section
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: leftTitleForHeaderInSection:)])
            {
                return [dataSource doubleSelectView:self leftTitleForHeaderInSection:section];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: rightTitleForHeaderInSection:)])
            {
                return [dataSource doubleSelectView:self rightTitleForHeaderInSection:section];
            }
        }
    }
    return @"";
}


- (NSString *)multiSelectView:(AHMultiSelectView *)multiSelectView titleForFooterInSection:(NSInteger)section
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: leftTitleForFooterInSection:)])
            {
                return [dataSource doubleSelectView:self leftTitleForFooterInSection:section];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(doubleSelectView: rightTitleForFooterInSection:)])
            {
                return [dataSource doubleSelectView:self rightTitleForFooterInSection:section];
            }
        }
    }
    return 0;
}


- (NSArray *)sectionIndexTitlesForTableView:(AHMultiSelectView *)multiSelectView
{
    if (dataSource != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([dataSource respondsToSelector:@selector(leftSectionIndexTitlesForTableView:)])
            {
                return [dataSource leftSectionIndexTitlesForTableView:self];
            }
            
        }
        else
        {
            if ([dataSource respondsToSelector:@selector(rightSectionIndexTitlesForTableView:)])
            {
                return [dataSource rightSectionIndexTitlesForTableView:self];
            }
        }
    }
    return 0;
}


#pragma mark -
#pragma mark AHMultiSelectViewDelegate Methods

- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didSelect:(NSIndexPath *)indexPath
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftSelectViewDidSelect:)])
            {
                [self showRightSelectView:indexPath];
                return [delegate doubleSelectView:self leftSelectViewDidSelect:indexPath];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightSelectViewDidSelect:)])
            {
                return [delegate doubleSelectView:self rightSelectViewDidSelect:indexPath];
            }
        }
    }
}


- (void)multiSelectView:(AHMultiSelectView *)multiSelectView didCancelSelect:(NSIndexPath *)indexPath
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftSelectViewDidCancelSelect:)])
            {
                [delegate doubleSelectView:self leftSelectViewDidCancelSelect:indexPath];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightSelectViewDidCancelSelect:)])
            {
                [delegate doubleSelectView:self rightSelectViewDidCancelSelect:indexPath];
            }
        }
    }
}


- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldSelect:(NSIndexPath *)indexPath
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftSelectViewShouldSelect:)])
            {
                return [delegate doubleSelectView:self leftSelectViewShouldSelect:indexPath];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightSelectViewShouldSelect:)])
            {
                return [delegate doubleSelectView:self rightSelectViewShouldSelect:indexPath];
            }
        }
    }
    return YES;
}


- (BOOL)multiSelectView:(AHMultiSelectView *)multiSelectView shouldCancelSelect:(NSIndexPath *)indexPath
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftSelectViewShouldCancelSelect:)])
            {
                return [delegate doubleSelectView:self leftSelectViewShouldCancelSelect:indexPath];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightSelectViewShouldCancelSelect:)])
            {
                return [delegate doubleSelectView:self rightSelectViewShouldCancelSelect:indexPath];
            }
        }
    }
    return YES;
}


- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForHeaderInSection:(NSInteger)section
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftViewForHeaderInSection:)])
            {
                return [delegate doubleSelectView:self leftViewForHeaderInSection:section];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightViewForHeaderInSection:)])
            {
                return [delegate doubleSelectView:self rightViewForHeaderInSection:section];
            }
        }
    }
    return nil;
}


- (UIView *)multiSelectView:(AHMultiSelectView *)multiSelectView viewForFooterInSection:(NSInteger)section
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftViewForFooterInSection:)])
            {
                return [delegate doubleSelectView:self leftViewForFooterInSection:section];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightViewForFooterInSection:)])
            {
                return [delegate doubleSelectView:self rightViewForFooterInSection:section];
            }
        }
    }
    return nil;
}


- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForHeaderInSection:(NSInteger)section
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftHeightForHeaderInSection:)])
            {
                return [delegate doubleSelectView:self leftHeightForHeaderInSection:section];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightHeightForHeaderInSection:)])
            {
                return [delegate doubleSelectView:self rightHeightForHeaderInSection:section];
            }
        }
    }
    return 0.0f;
}


- (CGFloat)multiSelectView:(AHMultiSelectView *)multiSelectView heightForFooterInSection:(NSInteger)section
{
    if (delegate != nil)
    {
        if (multiSelectView == leftTableView)
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: leftHeightForFooterInSection:)])
            {
                return [delegate doubleSelectView:self leftHeightForFooterInSection:section];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(doubleSelectView: rightHeightForFooterInSection:)])
            {
                return [delegate doubleSelectView:self rightHeightForFooterInSection:section];
            }
        }
    }
    return 0.0f;
}


- (void)willBeginDragging:(AHMultiSelectView *)multiSelectView
{
    if (multiSelectView == leftTableView)
    {
        [self closeRightSelectView];
    }
}

@end







