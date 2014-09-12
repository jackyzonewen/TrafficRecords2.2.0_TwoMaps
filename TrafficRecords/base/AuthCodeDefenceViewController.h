//
//  AuthCodeDefenceViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-10-12.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "AuthCodeQueryService.h"
#import "CarInfo.h"
#import "AddAuthCodeServices.h"

@interface AuthCodeCell : UITableViewCell
@property (nonatomic, strong) UILabel     *areaLabel;
@property (nonatomic, strong) UIImageView *authImage;
@property (nonatomic, strong) UITextField *input;
@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) UIView *line;
@end

//////////////////////////////////////////

@interface AuthCodeDefenceViewController : TRBaseViewController <UITableViewDataSource, UITableViewDelegate>{
    AuthCodeQueryService            *queryService;
    AddAuthCodeServices             *addAuthCodeServices;
}

//修改车牌号，车辆的改变前的carid
@property (nonatomic, strong)NSString *modifyCarId;
//newCar默认为空，有newCar时表示为添加、修改车辆时输入验证码
@property (nonatomic, strong)CarInfo *carInfoNew;
//待输入验证码的车辆id
@property (nonatomic, strong)NSString *theCarid;
@property (nonatomic, strong)UITableView *myTableView;
@property (nonatomic, strong)UITableView *listTableView;
@property (nonatomic, strong)NSMutableArray * authCodeCarArray;
@property (nonatomic, assign)int currentIndex;
@property (nonatomic, strong)NSMutableDictionary *inputedText;

@end
