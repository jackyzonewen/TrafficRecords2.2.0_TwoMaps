//
//  TRRefreshViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRRefreshViewController.h"

@interface TRRefreshViewController ()

@end

@implementation TRRefreshViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(EGORefreshTableHeaderView *) getHeadView:(UIScrollView *) scrollView{
    if (headView == nil) {
        UIImage *indicator = TRImage(@"load.png");
        headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(12, KDefaultStartY - indicator.size.height -10, indicator.size.width, indicator.size.height) ImageName:indicator];
        headView.delegate = self;
        [self.view addSubview:headView];
    }
//    [headView setTop:scrollView.top - headView.height -14];
    return headView;
}

#pragma mark -
#pragma mark Load Data Source

//下拉刷新的控件重新获取数据
- (void) loadData
{
	isReloading = YES;
}

//加载完数据后，scrollView恢复正常
- (void)doneLoadData
{
    isReloading = NO;
    [[self getHeadView:myScrollView]  egoRefreshScrollViewDataSourceDidFinishedLoading:myScrollView];
    
    //取消KLoadingDuration秒的调用
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doneLoadData) object:nil];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//滚动时用于更新label状态，
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    myScrollView = scrollView;
    [[self getHeadView:myScrollView] egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    myScrollView = scrollView;
    [[self getHeadView:myScrollView] egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadData];
    //KLoadingDuration秒后取消loading状态
	[self performSelector:@selector(doneLoadData) withObject:nil afterDelay:KLoadingDuration];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return isReloading; // should return if data source model is reloading
}

-(void) autoRefresh{
    //如果正在刷新，则不再刷新
    if (isReloading) {
        return;
    }
    isAutoRefsh = YES;
    [myScrollView setContentOffset:CGPointMake(0, -70) animated:NO];
    CGPoint *point = nil;
    [self scrollViewDidScroll:myScrollView];
    [self scrollViewWillEndDragging:myScrollView withVelocity:CGPointZero targetContentOffset:point];
    [UIView beginAnimations:@"autoRefresh" context:nil];
    [UIView setAnimationDuration:0.5];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [UIView commitAnimations];
}
@end
