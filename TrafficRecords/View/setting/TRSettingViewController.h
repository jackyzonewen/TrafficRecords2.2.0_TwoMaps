//
//  TRSettingViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "GetAppInfoService.h"

@interface TRSettingViewController : TRBaseViewController<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray             *textArray;
    NSMutableArray             *iconArray;
    GetAppInfoService   *appInfoService;
}
@property (nonatomic, strong)UITableView *myTableView;
@end
