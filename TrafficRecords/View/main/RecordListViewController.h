//
//  RecordListViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-11-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRRefreshViewController.h"
#import "CarInfo.h"
#import "QueryTrafRecordService.h"

@interface RecordListViewController : TRRefreshViewController<UITableViewDataSource, UITableViewDelegate>{
    QueryTrafRecordService   *recordService;
    BOOL                      hasShowAuthCode;
    BOOL                      showInfoView;
    BOOL                      locked;
    UIView                   *infoView;
}

@property (nonatomic, strong)UITableView *myTableView;
@property (nonatomic, strong)CarInfo     *carInfo;
@property (nonatomic, assign)BOOL         fromPush;

@end
