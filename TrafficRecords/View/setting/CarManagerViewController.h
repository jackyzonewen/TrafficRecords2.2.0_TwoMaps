//
//  CarManagerViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-25.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "DeleteCarService.h"
#import "FMMoveTableView.h"
#import "FMMoveTableViewCell.h"

@interface carManagerCell : FMMoveTableViewCell

@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, strong) UILabel *mainLabel;

@end

//

@interface CarManagerViewController : TRBaseViewController<UITableViewDataSource, UITableViewDelegate,FMMoveTableViewDataSource, FMMoveTableViewDelegate>{
    DeleteCarService           *service;
    NSInteger                  deleteIndex;
    UIButton                   *addBtn;
}
@property (nonatomic, strong)FMMoveTableView *myTableView;
@end
