//
//  AddCarViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "CityViewController.h"
#import "ProShortView.h"
#import "Brand.h"
#import "BrandViewController.h"
#import "AddCarService.h"
#import "CarInfo.h"

typedef enum EAddRowItem{
    EAddRowItemCarType = 0,
    EAddRowItemCity,
    EAddRowItemCarNum,
    EAddRowItemEngine,
    EAddRowItemCarFrame,
    EAddRowItemRegisternum,
    EAddRowItemUserName,
    EAddRowItemPasssword,
    EAddRowItemBeizhu
}EAddRowItem;

@interface AddCarViewController : TRBaseViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, AreaDelegate, SelectedProDelegate, BrandDelegate>{
    ProShortView            *shortView;
    //发动机号需要的最少长度
    int                      engineLen;
    //车架号需要的最少长度
    int                      frameLen;
    AddCarService           *service;
    BOOL                     carNumRepeat;
}

@property (nonatomic, strong)NSString             *supportnum;//支持的车牌首字母查询。无限制时为空，有限制时为限制未在其中的
@property (nonatomic, strong)NSString             *loginurl;//需要登录时的登录注册URL
@property (nonatomic, strong)NSString             *jiaoguanjuName;
@property (nonatomic, assign)NSInteger            registernumlen;


@property (nonatomic, strong)NSString            *registerNum;
@property (nonatomic, strong)NSString            *userName;
@property (nonatomic, strong)NSString            *password;


@property (nonatomic, strong)UITableView         *myTableView;
@property (nonatomic, strong)NSMutableArray      *selectCitys;
@property (nonatomic, strong)NSString            *proShortName;
@property (nonatomic, strong)NSString            *carNum;
@property (nonatomic, strong)NSString            *engineNum;
@property (nonatomic, strong)NSString            *frameNum;

@property (nonatomic, strong)Brand               *selectBrand;
@property (nonatomic, strong)Series              *selectSeries;
@property (nonatomic, strong)CarType             *selectSpec;
@property (nonatomic, strong)NSString            *nickName;
@property (nonatomic, assign)int                 carId;

@property (nonatomic, strong)CarInfo             *carData;
@end
