//
//  AddressPickViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-3-13.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "CityViewController.h"
#import "GetOfficeInfoService.h"
#import "OfficAdressCell.h"

@interface AddressPickViewController : TRBaseViewController<AreaDelegate,UITableViewDataSource, UITableViewDelegate, OfficAdressCellEventObserver>
{
    GetOfficeInfoService            *service;
    BOOL                             inLoading;
}

@property (nonatomic, strong)City                *city;
@property (nonatomic, strong)UITableView         *myTableView;
@property (nonatomic, strong)NSMutableArray      *dataArray;
@end
