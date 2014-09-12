//
//  TRAppViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-4-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRRefreshViewController.h"
#import "AppRecommendService.h"

@interface TRAppViewController : TRBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppRecommendService *recommndList;
}

@property (nonatomic, strong)UITableView         *myTableView;
@property (nonatomic, strong)NSMutableArray      *dataArray;
@end
