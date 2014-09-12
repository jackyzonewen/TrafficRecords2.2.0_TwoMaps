/*!
 @header    AHMultiSelectView.m
 @abstract  多样选择的View
 @author    张洁
 @version   2.5.0 2013/04/17 Creation
 */

#import "AHMultiSelectView.h"
#import "AHMultiViewCell.h"
#import "UIView+ViewFrameGeometry.h"
#import "TableViewEx.h"


@implementation AHMultiSelectView

@synthesize selectTableView;
@synthesize delegate;
@synthesize dataSource;
@synthesize selectStyle;
@synthesize selectedImage;
@synthesize unSelectedImage;
@synthesize selectedIndexPath;
@synthesize isAutoSize;
@synthesize isShowState;


- (id)initWithRadioSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom
{
    self = [self initWithSelectStyle:RadioSelect initFrame:frame style:style tableInsetBottom:insetBottom];
    if (self)
    {
        //初始化默认的选中与非选中效果显示
        self.selectedImage = [UIImage imageNamed:@"RadioSel.png"];
        self.unSelectedImage = [UIImage imageNamed:@"RadioUnSel.png"];
    }
    return self;
}


- (id)initWithMultiSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom
{
    self = [self initWithSelectStyle:MultiSelect initFrame:frame style:style tableInsetBottom:insetBottom];
    if (self)
    {
        //初始化默认的选中与非选中效果显示
        self.selectedImage = [UIImage imageNamed:@"CheckSel.png"];
        self.unSelectedImage = [UIImage imageNamed:@"CheckUnSel.png"];
    }
    return self;
}


- (id)initWithSelectStyle:(SelectStyle)initSelectStyle initFrame:(CGRect)frame style:(UITableViewStyle)style tableInsetBottom:(NSInteger)insetBottom
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isShowState = NO;
        isAutoSize = NO;
        selectStyle = initSelectStyle;
        selectTableView = [[TableViewEx alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - insetBottom) style:style];
        selectTableView.dataSource = self;
        selectTableView.delegate = self;
        selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        selectTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:selectTableView];
    }
    return self;
}


- (void)dealloc
{
    self.selectedImage = nil;
    self.unSelectedImage = nil;
    self.selectTableView = nil;
    if (selectedIndexPath != nil)
    {
        selectedIndexPath = nil;
    }
}


#pragma mark -
#pragma mark Table Data Source Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(multiSelectView: heightForRowAtIndexPath:)])
    {
        return [dataSource multiSelectView:self heightForRowAtIndexPath:indexPath];
    }
    return [AHMultiViewCell getCellDefaultHeight];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [dataSource numberOfSectionsInTableView:self];
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(multiSelectView: numberOfRowsInSection:)])
    {
        NSInteger s = [dataSource multiSelectView:self numberOfRowsInSection:section];
        return s;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(multiSelectView: cellForRowAtIndexPath:)])
    {
        AHMultiViewCell *cell = [dataSource multiSelectView:self cellForRowAtIndexPath:indexPath];
        if (cell != nil)
        {
//            [cell.selectView setBackgroundImage:unSelectedImage forState:UIControlStateNormal];
//            [cell.selectView addTarget:self action:@selector(checkState) forControlEvents:UIControlEventTouchUpInside];
//            cell.selectView.hidden = !isShowState;
//            if (cell.isSelected)
//            {
//                [cell.selectView setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
//                //cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            }
//            else
//            {
//                [cell.selectView setBackgroundImage:self.unSelectedImage forState:UIControlStateNormal];
//                //cell.accessoryType = UITableViewCellAccessoryNone;
//            }
            //自动适应高
            if (indexPath.section == 0 && indexPath.row == 0)
            {
                if (isAutoSize
                    && selectTableView.height > selectTableView.contentSize.height)
                {
                    selectTableView.frame = CGRectMake(selectTableView.origin.x, selectTableView.origin.y, selectTableView.contentSize.width, selectTableView.contentSize.height);
                }
                if (delegate
                    && [delegate respondsToSelector:@selector(didReloadData:)])
                {
                    [delegate didReloadData:self];
                }
            }
        }
        return cell;
    }
	return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(multiSelectView: titleForHeaderInSection:)])
    {
        return [dataSource multiSelectView:self titleForHeaderInSection:section];
    }
    return @"";
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(multiSelectView: titleForFooterInSection:)])
    {
        return [dataSource multiSelectView:self titleForFooterInSection:section];
    }
    return 0;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (dataSource
        && [dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
    {
        return [dataSource sectionIndexTitlesForTableView:self];
    }
    return 0;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectTableView isEditing])
    {
        //如果列表数据是处于编辑状态，则直接返回
        return;
    }
    [self setSelectedOfIndexPath:indexPath isSendHandle:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (delegate
        && [delegate respondsToSelector:@selector(multiSelectView: viewForHeaderInSection:)])
    {
        return [delegate multiSelectView:self viewForHeaderInSection:section];
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (delegate
        && [delegate respondsToSelector:@selector(multiSelectView: viewForFooterInSection:)])
    {
        return [delegate multiSelectView:self viewForFooterInSection:section];
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (delegate
        && [delegate respondsToSelector:@selector(multiSelectView: heightForHeaderInSection:)])
    {
        return [delegate multiSelectView:self heightForHeaderInSection:section];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (delegate
        && [delegate respondsToSelector:@selector(multiSelectView: heightForFooterInSection:)])
    {
        return [delegate multiSelectView:self heightForFooterInSection:section];
    }
    return 0;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == selectTableView)
    {
        if (delegate
            && [delegate respondsToSelector:@selector(willBeginDragging:)])
        {
            return [delegate willBeginDragging:self];
        }
    }
}


#pragma mark -
#pragma mark AHMultiSelectView Methods

//标记此行为选中状态
- (void)cellSelected:(AHMultiViewCell *)cell selectIndexPath:(NSIndexPath *)indexPath isSendHandle:(BOOL)isHandle
{
    if (indexPath != nil)
    {
        //只要不为空，就保存一下，这是会了防止设置选中时，还没有绘制cell
        [self setCurrSelectedIndexPath:indexPath];
    }
    if (cell == nil)
    {
        return;
    }
    if (isHandle)
    {
        if (delegate
            && [delegate respondsToSelector:@selector(multiSelectView: shouldSelect:)])
        {
            if (![delegate multiSelectView:self shouldSelect:indexPath])
            {
                return;
            }
        }
    }
    //[selectTableView se
    //[selectTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    if (!cell.isSelected)
    {
        cell.selected = YES;
//        [cell.selectView setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
    }
    if (isHandle)
    {
        if (delegate
            && [delegate respondsToSelector:@selector(multiSelectView: didSelect:)])
        {
            return [delegate multiSelectView:self didSelect:indexPath];
        }
    }
}


//标记此行为非选中状态
- (void)cellCancelSelected:(AHMultiViewCell *)cell cancelSelectIndexPath:(NSIndexPath *)indexPath  isSendHandle:(BOOL)isHandle
{
    if (cell == nil)
    {
        return;
    }
    if (isHandle)
    {
        if (delegate
            && [delegate respondsToSelector:@selector(multiSelectView: shouldCancelSelect:)])
        {
            if (![delegate multiSelectView:self shouldCancelSelect:indexPath])
            {
                return;
            }
        }
    }
    
//    [selectTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cell.isSelected)
    {
        cell.selected = NO;
//        [cell.selectView setBackgroundImage:self.unSelectedImage forState:UIControlStateNormal];
    }
    if (isHandle)
    {
        if (delegate
            && [delegate respondsToSelector:@selector(multiSelectView: didCancelSelect:)])
        {
            return [delegate multiSelectView:self didCancelSelect:indexPath];
        }
    }
}



//标记此行是删除还是取消
- (void)cellSelectedOrCancel:(AHMultiViewCell *)cell isSendHandle:(BOOL)isHandle
{
    if (cell == nil)
    {
        return;
    }
    if (selectStyle == RadioSelect)
    {
        if (!cell.isSelected)
        {
            NSIndexPath *curIndex = [selectTableView indexPathForSelectedRow];
            //单选时要取消上一个选择的
            if (selectedIndexPath != nil && curIndex != nil
                && (selectedIndexPath.row != curIndex.row
                    || selectedIndexPath.section != curIndex.section))
            {
                AHMultiViewCell *oldCell = (AHMultiViewCell *)[selectTableView cellForRowAtIndexPath:selectedIndexPath];
                if (oldCell != nil)
                {
                    [self cellCancelSelected:oldCell cancelSelectIndexPath:selectedIndexPath isSendHandle:isHandle];
                }
            }
            [self cellSelected:cell selectIndexPath:[selectTableView indexPathForSelectedRow] isSendHandle:isHandle];
            //[self setCurrSelectedIndexPath:[selectTableView indexPathForSelectedRow]];
            
        }
    }
    else
    {
        if (!cell.isSelected)
        {
            [self cellSelected:cell selectIndexPath:[selectTableView indexPathForSelectedRow] isSendHandle:isHandle];
        }
        else
        {
            [self cellCancelSelected:cell cancelSelectIndexPath:[selectTableView indexPathForSelectedRow] isSendHandle:isHandle];
        }
    }
}

- (void)setSelectedOfIndexPath:(NSIndexPath *)indexPath isSendHandle:(BOOL)isHandle
{
    [selectTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    AHMultiViewCell *cell = nil;
    if (indexPath != nil)
    {
        //[selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //[NSIndexPath indexPathForRow:0 inSection:0]
        cell = (AHMultiViewCell *)[selectTableView cellForRowAtIndexPath:indexPath];
    }
    if (cell == nil)
    {
        //单选时要取消上一个选择的
        if (selectedIndexPath != nil)
        {
            AHMultiViewCell *oldCell = (AHMultiViewCell *)[selectTableView cellForRowAtIndexPath:selectedIndexPath];
            if (oldCell != nil)
            {
                [self cellCancelSelected:oldCell cancelSelectIndexPath:selectedIndexPath isSendHandle:isHandle];
            }
        }
        //if (indexPath != nil)
        {
            [self setCurrSelectedIndexPath:indexPath];
        }
        return;
    }
    
    if (selectStyle == RadioSelect)
    {
        //单选时要取消上一个选择的
        if (selectedIndexPath != nil
            && (selectedIndexPath.row != indexPath.row
                || selectedIndexPath.section != indexPath.section))
        {
            AHMultiViewCell *oldCell = (AHMultiViewCell *)[selectTableView cellForRowAtIndexPath:selectedIndexPath];
            if (oldCell != nil)
            {
                [self cellCancelSelected:oldCell cancelSelectIndexPath:selectedIndexPath isSendHandle:isHandle];
            }
        }
        [self cellSelected:cell selectIndexPath:indexPath isSendHandle:isHandle];
        [self setCurrSelectedIndexPath:indexPath];
    }
    else
    {
        if (!cell.isSelected)
        {
            [self cellSelected:cell selectIndexPath:indexPath isSendHandle:isHandle];
        }
        else
        {
            [self cellCancelSelected:cell cancelSelectIndexPath:indexPath isSendHandle:isHandle];
        }
    }
}


- (NSArray *)indexPathsForSelected
{
    NSArray *selectedArray = [[NSArray alloc] init];
    NSInteger count = [[selectTableView visibleCells] count];
    for (NSInteger i = 0; i < count; i++)        
    {
        
        AHMultiViewCell *cell = (AHMultiViewCell *)[[selectTableView visibleCells] objectAtIndex:i];
        
        if (cell.isSelected)
        {
            //selectedArray.a
        }
        
    }
    return selectedArray;
}


- (void)setCurrSelectedIndexPath:(NSIndexPath *)indexPath
{
//    if (selectedIndexPath != nil)
//    {
//        [selectedIndexPath release];
//    }
    selectedIndexPath = indexPath;
}


- (void)reloadData
{
    [selectTableView reloadData];
}

@end







