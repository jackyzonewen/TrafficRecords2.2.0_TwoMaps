//
//  TRRefreshViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface TRRefreshViewController : TRBaseViewController <UIScrollViewDelegate, EGORefreshTableHeaderDelegate>{
    BOOL                            isReloading;
    EGORefreshTableHeaderView       *headView;
    UIScrollView                    *myScrollView;
    BOOL                            isAutoRefsh;
}

-(EGORefreshTableHeaderView *) getHeadView:(UIScrollView *) scrollView;
//自动刷新
-(void) autoRefresh;
//下拉刷新的控件重新获取数据
- (void) loadData;
//加载完数据后，scrollView恢复正常
- (void)doneLoadData;
@end
