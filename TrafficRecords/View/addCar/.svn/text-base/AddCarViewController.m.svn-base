//
//  AddCarViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AddCarViewController.h"
#import "Area.h"
#import "TRTextField.h"
#import "TRPictrueView.h"
#import "BrandViewController.h"
#import "OpenUDID.h"
#import "JSON.h"
#import "CarInfo.h"
#import "TrafficRecord.h"
#import "AuthCodeDefenceViewController.h"
#import "UINavigationController+ViewAnimation.h"
#import "RecordListViewController.h"
#import "SupportCityManager.h"
#import "TRAutherAlertView.h"
#import "TRPictrueView2.h"
#import "Des.h"

@interface AddCarViewController ()

@end

@implementation AddCarViewController

@synthesize myTableView;
@synthesize selectCitys;
@synthesize proShortName;
@synthesize selectBrand;
@synthesize selectSeries;
@synthesize selectSpec;
@synthesize carNum;
@synthesize engineNum;
@synthesize frameNum;
@synthesize nickName;
@synthesize carId;
@synthesize carData;

@synthesize supportnum;
@synthesize loginurl;
@synthesize registernumlen;
@synthesize registerNum;
@synthesize userName;
@synthesize password;
@synthesize jiaoguanjuName;

-(NSString *) naviTitle{
    if (carData) {
        return @"编辑车辆";
    }
    return @"添加车辆";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    BOOL msgCompelete = YES;
    if (selectSeries == nil || selectBrand == nil) {
        msgCompelete = NO;
    }
    if (selectCitys.count == 0) {
        msgCompelete = NO;
    }
    if (self.carNum.length  == 0) {
        msgCompelete = NO;
    }
    if (engineLen == 99 ) {
        if (self.engineNum.length < 5 || self.engineNum.length > 24) {
            msgCompelete = NO;
        }
    } else if (self.engineNum.length < engineLen){
        msgCompelete = NO;
    }
    if (frameLen == 99 ) {
        if (self.engineNum.length < 5 || self.engineNum.length > 24){
            msgCompelete = NO;
        }
    } else if (self.frameNum.length < frameLen){
        msgCompelete = NO;
    }
    if (loginurl.length > 0 && (self.userName.length == 0 || self.password.length == 0)) {
        msgCompelete = NO;
    }
    if (registernumlen != 0 && self.registerNum.length == 0) {
        msgCompelete = NO;
    }
    
    BOOL dataChanged = [self dataIsChanged];
    //无需保存
    if (carData != nil && !dataChanged) {
        msgCompelete = NO;
    }
    if (dataChanged && !carNumRepeat) {
        if (msgCompelete) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的修改尚未保存，现在保存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil, nil];
            [alert show];
            alert.tag = 200;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"添加信息尚未保存，确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil, nil];
            [alert show];
            alert.tag = 202;
        }

        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200){
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [self submit];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (alertView.tag == 201){
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            NSString * acarNum = [NSString stringWithFormat:@"%@%@", self.proShortName, self.carNum];
            CarInfo *found = nil;
            for (CarInfo *car in [CarInfo globCarInfo]) {
                if ([car.carnumber isEqualToString: acarNum]) {
                    found = car;
                    break;
                }
            }
            NSArray *array = [NSArray arrayWithArray:self.selectCitys];
            self.carData = found;
            
            if (![self.proShortName isEqualToString:@"津"] && ![self.proShortName isEqualToString:@"桂"]) {
                for (City *city in array) {
                    BOOL isexsit = NO;
                    for (City *city2 in self.selectCitys) {
                        if (city.cityId == city2.cityId) {
                            isexsit = YES;
                        }
                    }
                    if (!isexsit) {
                        [self.selectCitys addObject:city];
                        if (frameLen < city.framelen) {
                            frameLen = (int)city.framelen;
                        }
                        if (engineLen < city.enginelen) {
                            engineLen = (int)city.enginelen;
                        }
                    }
                }
            }

            [self.myTableView reloadData];
            carNumRepeat = NO;
        } else {
            carNumRepeat = YES;
            
        }
    } else if(alertView.tag == 202){
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(id) init{
    self = [super init];
    if (self) {
       self.selectCitys = [NSMutableArray array];
        //99为全部号码
        engineLen = 99;
        frameLen = 99;
        self.frameNum = @"";
        self.proShortName = @"京";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= KHeightReduce ;
    self.myTableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [TRSkinManager bgColorLight];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *tableHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.width, 8)];
    tableHead.backgroundColor = [TRSkinManager bgColorLight];
    myTableView.tableHeaderView = tableHead;
    
    if (carData == nil) {
        NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
        City *beFoundCity = [[SupportCityManager sharedManager] getCity:(int)cityId];
        if (beFoundCity != nil && !beFoundCity.notSupport) {
            self.selectCitys = [NSMutableArray arrayWithObject:beFoundCity];
        }
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEvent:) name:KNotification_GlobTouchEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:@"authCodeSucess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void) notifyMessage:(NSNotification *) msg{
    if ([msg.name isEqualToString:UITextFieldTextDidChangeNotification]) {
        TRTextField *textField = msg.object;
        NSInteger tag = textField.tag - 2000;
        switch (tag) {
            case EAddRowItemCarNum:
            {
                self.carNum = textField.text;
                NSString * acarNum = [NSString stringWithFormat:@"%@%@", self.proShortName, self.carNum];
                CarInfo *found = nil;
                for (CarInfo *car in [CarInfo globCarInfo]) {
                    if ([car.carnumber isEqualToString: acarNum]) {
                        found = car;
                        break;
                    }
                }
                if (found != nil && carData == nil) {
                    [MobClick event:@"add_same_carnum"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您添加的车辆已存在，您是否要修改车辆信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil, nil];
                    [alert show];
                    alert.tag = 201;
                } else {
                    carNumRepeat = NO;
                }
            }break;
            case EAddRowItemEngine:
            {
                self.engineNum = textField.text;
            }break;
            case EAddRowItemCarFrame:
            {
                self.frameNum = textField.text;
            }break;
            case EAddRowItemBeizhu:
            {
                self.nickName = textField.text;
            }break;
            case EAddRowItemRegisternum:
            {
                self.registerNum = textField.text;
            }break;
            case EAddRowItemUserName:
            {
                if (textField.text.length > 0) {
                    NSString *coded = [Des doCipher2:textField.text key:[[TRUtility getAppKey] substringToIndex:8] iv:nil context:kCCEncrypt];
                    coded = [NSString stringWithFormat:@"00wzcx_%@", coded];
                    self.userName = coded;
                } else {
                    self.userName = textField.text;
                }
            }break;
            case EAddRowItemPasssword:
            {
                if (textField.text.length > 0) {
                    NSString *coded = [Des doCipher2:textField.text key:[[TRUtility getAppKey] substringToIndex:8] iv:nil context:kCCEncrypt];
                    coded = [NSString stringWithFormat:@"00wzcx_%@", coded];
                    self.password = coded;
                } else {
                    self.password = textField.text;
                }
            }break;
            default:
                break;
        }
    } else if ([msg.name isEqualToString:@"authCodeSucess"]) {
        RecordListViewController *listView = [[RecordListViewController alloc] init];
        listView.carInfo = msg.object;
        [self.navigationController pushViewController:listView animatedWithTransition:UIViewAnimationTransitionCurlUp];
    }
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void) touchEvent:(NSNotification*) touchMsg{
    UIEvent *event = touchMsg.object;
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = touch.view;
    if (![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UITextField class]] && view != nil) {
        [self hiddenKeyBoard];
    }
}
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self hiddenKeyBoard];
//}

- (void) setSelectCitys:(NSMutableArray *) aselectCitys{
    selectCitys = nil;
    selectCitys = aselectCitys;
    self.supportnum = @"";
    self.loginurl = @"";
    self.jiaoguanjuName = @"";
    self.registernumlen = 0;
    
    int maxFrame = 0;
    int maxEngine = 0;
    for (int i = 0; i < selectCitys.count; i++) {
        City *city = [selectCitys objectAtIndex:i];
        if (i == 0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"京", @"110000", @"沪", @"310000",
                                 @"浙", @"330000", @"苏", @"320000",
                                 @"粤", @"440000", @"鲁", @"370000",
                                 @"晋", @"140000", @"冀", @"130000",
                                 @"豫", @"410000", @"川", @"510000",
                                 @"渝", @"500000", @"辽", @"210000",
                                 @"吉", @"220000", @"黑", @"230000",
                                 @"皖", @"340000", @"鄂", @"420000",
                                 @"湘", @"430000", @"赣", @"360000",
                                 @"闽", @"350000", @"陕", @"610000",
                                 @"甘", @"620000", @"宁", @"640000",
                                 @"蒙", @"150000", @"津", @"120000",
                                 @"贵", @"520000", @"云", @"530000",
                                 @"桂", @"450000", @"琼", @"460000",
                                 @"青", @"630000", @"新", @"650000",
                                 @"藏", @"540000",
                                 nil];
            if (self.carNum.length == 0) {
                NSString * proName = [dic objectForKey:[NSString stringWithFormat:@"%ld", (long)city.parentId]];
                if (proName.length > 0) {
                    self.proShortName = proName;
                }
            }
        }
        if (maxEngine < city.enginelen) {
            maxEngine = (int)city.enginelen;
        }
        if (maxFrame < city.framelen) {
            maxFrame = (int)city.framelen;
        }
        if (city.supportnum.length > 0) {
            self.supportnum = city.supportnum;
        }
        if (city.loginurl.length > 0) {
            NSArray *array = [city.loginurl componentsSeparatedByString:@"@"];
            if (array.count >= 2) {
                self.jiaoguanjuName = [array objectAtIndex:0];
                self.loginurl = [array objectAtIndex:1];
            }
        }
        if (city.registernumlen != 0) {
            registernumlen = city.registernumlen;
        }
    }
    engineLen = maxEngine;
    frameLen = maxFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) btnClick:(UIButton *) btn{
    NSInteger tag = btn.tag - 1000;
    if (tag == EAddRowItemCity) {
        CityViewController *city = [[CityViewController alloc] init];
        city.controllerType = 2;
        city.areaDelegate = self;
        [city setSelectCitys:self.selectCitys];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:city];
        [self presentViewController:navi animated:YES completion:nil];
    } else if(tag == EAddRowItemCarType){
        BrandViewController *brandViewCtrller = [[BrandViewController alloc] init];
        brandViewCtrller.brandDelegate = self;
        brandViewCtrller.selectBrand = self.selectBrand;
        brandViewCtrller.selectSeries = self.selectSeries;
        brandViewCtrller.selectSpec = self.selectSpec;
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:brandViewCtrller];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

-(void) submit{
    NSString *carNo = [NSString stringWithFormat:@"%@%@", proShortName, carNum];
    if (carNumRepeat) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您添加的车辆已存在，您是否要修改车辆信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil, nil];
        [alert show];
        alert.tag = 201;
        return;
    }
    if (selectCitys.count == 0) {
        [self showInfoView:@"请选择查询城市"];
        return;
    }
    if (self.carNum.length  != 6 || carNo.length != 7) {
        [self showInfoView:@"请输入正确的车牌号码"];
        return;
    }
    if (engineLen == 99 ) {
        if (self.engineNum.length == 0) {
            [self showInfoView:@"请输入全部发动机号码"];
            return;
        }
    } else if (self.engineNum.length < engineLen){
        NSString *text = [NSString stringWithFormat:@"请输入%d位发动机尾号", engineLen];
        [self showInfoView:text];
        return;
    }
    
    if (frameLen == 99 ) {
        if (self.frameNum.length == 0) {
            [self showInfoView:@"请输入全部车架号码"];
            return;
        }
    } else if (self.frameNum.length < frameLen){
        NSString *text = [NSString stringWithFormat:@"请输入%d位车架尾号", frameLen];
        [self showInfoView:text];
        return;
    }
    if (registernumlen != 0 ) {
        if (registernumlen == 99) {
            if (self.registerNum.length == 0) {
                [self showInfoView:@"请输入登记证书号码"];
                return;
            }
        } else {
            if (self.registerNum.length < registernumlen) {
                NSString *text = [NSString stringWithFormat:@"请输入%d位登记证书尾号", registernumlen];
                [self showInfoView:text];
                return;
            }
        }
    }
    if (loginurl.length > 0) {
        if (self.userName.length == 0) {
//            NSString *text = [NSString stringWithFormat:@"请输入%@用户名", self.jiaoguanjuName];
            [self showInfoView:@"请输入您注册的用户名"];
            return;
        }
        if (self.password.length == 0) {
//            NSString *text = [NSString stringWithFormat:@"请输入%@密码", self.jiaoguanjuName];
            [self showInfoView:@"请输入您注册的密码"];
            return;
        }
    }
    for (City *city in self.selectCitys) {
        NSString *supportNum = city.supportnum;
        if (supportNum.length != 0) {
            NSArray *nums = [supportNum componentsSeparatedByString:@","];
            BOOL found = NO;
            for (NSString *str in nums) {
                NSRange r = [carNo rangeOfString:str];
                if (r.length != 0 ) {
                    found = YES;
                    break;
                }
            }
            if (!found) {
                NSString *text = [NSString stringWithFormat:@"%@系统仅支持%@车牌查询违章", city.name, supportNum];
                [self showInfoView:text];
                return;
            }
        }
    }
    
    
    //无需保存
    if (carData != nil && ![self dataIsChanged]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary *carInfo = [NSMutableDictionary dictionary];
    [carInfo setObject:[NSNumber numberWithInt:carId] forKey:@"carid"];
    NSMutableString *citys = [NSMutableString string];
    for (City *city in selectCitys) {
        if (citys.length > 0) {
            [citys appendString:@","];
        }
        [citys appendFormat:@"%ld", (long)city.cityId];
    }
    [carInfo setObject:citys forKey:@"querycitysid"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [carInfo setObject:[defaults objectForKey:KGUIDKey] forKey:@"guid"];
    [carInfo setObject:[OpenUDID value] forKey:@"deviceid"];
    [carInfo setObject:[NSNumber numberWithInteger:selectSpec.typeId] forKey:@"carspecid"];
    [carInfo setObject:[NSNumber numberWithInteger:selectSpec.yearId] forKey:@"caryeartype"];
    [carInfo setObject:[NSNumber numberWithInteger:selectSeries.seriesId] forKey:@"carseries"];
    [carInfo setObject:[NSNumber numberWithInteger:selectBrand.brandId] forKey:@"carbrand"];
    [carInfo setObject:carNo forKey:@"carnumber"];
    NSString *userId = [NSString stringWithFormat:@"%d", [TRAppDelegate appDelegate].userId];//;
    if (userId.length > 0) {
        [carInfo setObject:userId forKey:@"userid"];
    } else {
        [carInfo setObject:@"" forKey:@"userid"];
    }
    if (self.engineNum) {
        [carInfo setObject:self.engineNum forKey:@"enginenumber"];
    } else {
        [carInfo setObject:@"" forKey:@"enginenumber"];
    }
    if (self.frameNum) {
        [carInfo setObject:self.frameNum forKey:@"framenumber"];
    } else {
        [carInfo setObject:@"" forKey:@"framenumber"];
    }
    [carInfo setObject:[NSNumber numberWithInt:0] forKey:@"carstatus"];
    if (self.nickName.length > 0) {
        [carInfo setObject:self.nickName forKey:@"carname"];
    } else {
        [carInfo setObject:@"" forKey:@"carname"];
    }
    
    [carInfo setObject:self.userName.length > 0 ? self.userName : @"" forKey:@"username"];
    [carInfo setObject:self.password.length > 0 ? self.password : @"" forKey:@"userpwd"];
    [carInfo setObject:self.registerNum.length > 0 ? self.registerNum : @"" forKey:@"registernumber"];
    
    NSDictionary *reslt = [NSDictionary dictionaryWithObject:carInfo forKey:@"carinfo"];
    NSString *text = [reslt JSONRepresentation];
    NSLog(@"%@", text);
    if (service == nil) {
        service = [[AddCarService alloc] init];
        service.delegate = self;
    }
    [service addCarWithJson:text];
    [self showLoadingAnimated:NO];
    [MobClick event:@"add_car_btn_click"];
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceAddCar) {
        NSDictionary *dic = service.responseDic;
        dic = [dic objectForKey:@"result"];
        NSString *pic = [dic objectForKey:@"pic"];
        NSInteger newCarId = [[dic objectForKey:@"carid"] integerValue];

        int status = -1;
        //修改car
        if (newCarId == carId) {
            status = 1;
        } else {
            //新增
            if (carId == 0) {
                status = 0;
            } else { //修改了车牌号
                status = 2;
            }
        }

        CarInfo *info = [[CarInfo alloc] init];
        info.carid = [NSString stringWithFormat:@"%ld", (long)newCarId];
        if (self.nickName.length > 0) {
            info.carname = self.nickName;
        } else {
            info.carname = @"";
        }
        info.carBrandId = selectBrand.brandId;
        info.carSeriesId = selectSeries.seriesId;
        info.cartypeId = selectSpec.typeId;
        info.carnumber = [NSString stringWithFormat:@"%@%@", proShortName, carNum];
        info.enginenumber = self.engineNum;
        info.framenumber = self.frameNum;
        //1.4.0
        info.userName = self.userName;
        info.passWord = self.password;
        info.registernumber = self.registerNum;
        
        CarInfo *oldCar = nil;
        //新增加入尾部
        if (status == 0) {
            if ([CarInfo globCarInfo].count > 0) {
                info.sortIndex = [(CarInfo*)[[CarInfo globCarInfo] lastObject] sortIndex] + 1;
            } else {
                info.sortIndex = 0;
            }
            [[CarInfo globCarInfo] addObject:info];
        } else {
            //修改保持原有排序
            info.sortIndex = carData.sortIndex;
            //将内存中的carinfo替换
            for (int i = 0; i < [CarInfo globCarInfo].count ; i++) {
                CarInfo *temp =  [[CarInfo globCarInfo] objectAtIndex:i];
                if ([temp.carid isEqualToString:[NSString stringWithFormat:@"%d", carId]]) {
                    oldCar = temp;
                    [[CarInfo globCarInfo] replaceObjectAtIndex:i withObject:info];
                    break;
                }
            }
            //将数据库中记录删除
            [CarInfo deleteCar:[NSString stringWithFormat:@"%d", carId]];
        }
        info.picUrl = pic;
        //插入新的数据库记录
        [CarInfo insertCar:info];
        
        BOOL unknownMoney = YES;
        BOOL unknownScore = YES;
        NSArray *citys = [dic objectForKey:@"citys"];
        for (NSDictionary *cityDic in citys) {
            NSString *cityId = [cityDic objectForKey:@"cityid"];
            if ([cityId isKindOfClass:[NSNumber class]]) {
                cityId = [NSString stringWithFormat:@"%ld",[[cityDic objectForKey:@"cityid"] longValue]];
            }
            NSString *timeStamp = [cityDic objectForKey:@"timestamp"];
            if ([timeStamp isKindOfClass:[NSNumber class]]) {
                timeStamp = [NSString stringWithFormat:@"%lld",[[cityDic objectForKey:@"timestamp"] longLongValue]];
            }
            CityOfCar *cityM = [[CityOfCar alloc] init];
            cityM.carid = [NSString stringWithFormat:@"%ld", (long)newCarId];
            cityM.cityid = cityId;
            cityM.timestamp = timeStamp;
            cityM.authInfoMsg = [cityDic objectForKey:@"authinfo"];
            NSString *imageUrl = [cityDic objectForKey:@"authimage"];
            BOOL needAuth = YES;
            //如果authimage值为null，则无需验证码
            if ([imageUrl isKindOfClass:[NSNull class]]) {
                needAuth = NO;
            } else {
                //
                if (imageUrl == nil || imageUrl.length == 0) {
                    needAuth = NO;
                }
            }
            //需要输入验证码
            if (needAuth) {
                cityM.authurl = imageUrl;
                NSDate *overTime = [NSDate dateWithTimeIntervalSinceNow:KTimeStampOverTime];
                NSTimeInterval time = [overTime timeIntervalSince1970];
                cityM.authovertime = [NSString stringWithFormat:@"%lf", time];
            } else {
                NSArray *recordArray = [cityDic objectForKey:@"violationdata"];
                if ([recordArray isKindOfClass:[NSNull class]]) {
                    recordArray = [NSArray array];
                }
                NSMutableArray *newrecords = [NSMutableArray array];
                for (NSDictionary * recordDic in recordArray) {
                    TrafficRecord *record = [TrafficRecord parseFromJson:recordDic];
                    record.cityid = cityM.cityid;
                    record.carid = info.carid;
                    [newrecords addObject:record];
                }
                NSArray *oldArray = [oldCar recordsOfCity:cityId];
                [TrafficRecord replacecar:info.carid withCity:cityM.cityid inserRecords:newrecords];
                //将新数据同步到carinfo对象中
                for (TrafficRecord *record in newrecords) {
                    //1为未处理,统计总分和总扣钱数；否则不显示且不统计
                    if (record.processstatus == 1) {
                        [info.trafficRecods addObject:record];
                        if (record.score >= 0) {
                            info.totalScore += record.score;
                            unknownScore = NO;
                        }
                        if (record.money >= 0) {
                            info.totalMoney += record.money;
                            unknownMoney = NO;
                        }
                    }
                    BOOL isNew = YES;
                    for (TrafficRecord *oldrecord in oldArray) {
                        if ([oldrecord.recordid isEqualToString:record.recordid]) {
                            isNew = NO;
                            break;
                        }
                    }
                    record.isNew = isNew;
                    if (isNew) {
                        info.totalNew ++;
                    }
                }
            }
            [info addCity:cityM];
        }
        if (info.trafficRecods.count > 0 ) {
            info.unknownMoney = unknownMoney;
            info.unknownScore = unknownScore;
        } else {
            info.unknownScore = NO;
            info.unknownScore = NO;
        }
        
        //所有城市结果处理完成，将结果集按time排序
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSArray *sortArray = [info.trafficRecods sortedArrayUsingComparator: ^NSComparisonResult(id a, id b){
            NSString *str1 =  ((TrafficRecord *) a).time;
            NSString *str2 =  ((TrafficRecord *) b).time;
            NSDate *date1 = [dateFormatter dateFromString:str1];
            NSDate *date2 = [dateFormatter dateFromString:str2];
            if (date1 && date2) {
                return [date2 compare:date1];
            } else {
                return [str2 compare:str1];
            }
        }];
        info.trafficRecods = [NSMutableArray arrayWithArray:sortArray];
        //数据处理结束
        if (carData == nil) {
            [self showInfoView:@"添加车辆成功！"];
        } else {
            [self showInfoView:@"修改车辆成功！"];
        }
    
        RecordListViewController *listView = [[RecordListViewController alloc] init];
        listView.carInfo = info;
        [self.navigationController pushViewController:listView animatedWithTransition:UIViewAnimationTransitionCurlUp];
//        [self dismissViewControllerAnimated:YES completion:nil];
        //app全局事件，车辆数据变化
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
    }
    [self hideLoadingViewAnimated:NO];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [MobClick event:@"add_car_fail" label:[NSString stringWithFormat:@"%d", errorCode]];
    [self hideLoadingViewAnimated:NO];
    if (tag == EServiceAddCar && errorCode == -50) {
        [MobClick event:@"add_sign_pop"];
        int authCount = 0;
        NSString *authCarId = nil;
        NSString *authCityId = nil;
        UIImage *authImage = nil;
        NSString *authInfo = nil;
        
        NSDictionary * dic = [service.responseDic objectForKey:@"result"];
        NSString *pic = [dic objectForKey:@"pic"];
        NSInteger newCarId = [[dic objectForKey:@"carid"] integerValue];
        CarInfo *info = [[CarInfo alloc] init];
        info.carid = [NSString stringWithFormat:@"%ld", (long)newCarId];
        if (self.nickName.length > 0) {
            info.carname = self.nickName;
        } else {
            info.carname = @"";
        }
        info.carBrandId = selectBrand.brandId;
        info.carSeriesId = selectSeries.seriesId;
        info.cartypeId = selectSpec.typeId;
        info.carnumber = [NSString stringWithFormat:@"%@%@", proShortName, carNum];
        info.enginenumber = self.engineNum;
        info.framenumber = self.frameNum;
        info.picUrl = pic;
        
        //1.4.0
        info.userName = self.userName;
        info.passWord = self.password;
        info.registernumber = self.registerNum;
        
        NSArray *citys = [dic objectForKey:@"citys"];
        for (NSDictionary *cityDic in citys) {
            NSString *cityId = [cityDic objectForKey:@"cityid"];
            if ([cityId isKindOfClass:[NSNumber class]]) {
                cityId = [NSString stringWithFormat:@"%ld",[[cityDic objectForKey:@"cityid"] longValue]];
            }
            CityOfCar *cityM = [[CityOfCar alloc] init];
            cityM.carid = [NSString stringWithFormat:@"%ld", (long)newCarId];
            cityM.cityid = cityId;
            cityM.timestamp = @"";
            cityM.authInfoMsg = [cityDic objectForKey:@"authinfo"];
            NSString *imageUrl = [cityDic objectForKey:@"authimage"];
            BOOL needAuth = YES;
            //如果authimage值为null，则无需验证码
            if ([imageUrl isKindOfClass:[NSNull class]]) {
                needAuth = NO;
            } else {
                //
                if (imageUrl == nil || imageUrl.length == 0) {
                    needAuth = NO;
                }
            }
            //需要输入验证码
            if (needAuth) {
                cityM.authurl = imageUrl;
                NSDate *overTime = [NSDate dateWithTimeIntervalSinceNow:KTimeStampOverTime];
                NSTimeInterval time = [overTime timeIntervalSince1970];
                cityM.authovertime = [NSString stringWithFormat:@"%lf", time];
                authCount++;
                authCarId = info.carid;
                authCityId = cityM.cityid;
                NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                authImage = [UIImage imageWithData:data];
                authInfo = cityM.authInfoMsg;
            }
            [info.citys addObject:cityM];
        }
        
        
        if(authCount == 1){
            TRAutherAlertView *alertView = [[TRAutherAlertView alloc] initWithImage:authImage];
            alertView.textField.delegate = self;
            alertView.carId = authCarId;
            alertView.cityId = authCityId;
            alertView.carInfoNew = info;
            alertView.textField.placeholder = authInfo;
            if (newCarId != carId) {
                alertView.modifyCarId = [NSString stringWithFormat:@"%d", carId];
            }
            alertView.titleView.text = info.carname.length > 0 ? info.carname : info.carnumber;
            [alertView show];
        } else if(authCount > 1){
            AuthCodeDefenceViewController *authView = [[AuthCodeDefenceViewController alloc] init];
            authView.carInfoNew = info;
            //新旧id不一致，意味车牌号发生变更
            if (newCarId != carId) {
                authView.modifyCarId = [NSString stringWithFormat:@"%d", carId];
            }
            [self.navigationController pushViewController:authView animatedWithTransition:UIViewAnimationTransitionCurlUp];
        }
    }
}

#pragma mark -
#pragma mark AreaDelegate Methods

- (void) selectedBrand:(Brand *)brand Series:(Series *) series Spec:(CarType *) spec{
    self.selectBrand = brand;
    self.selectSeries = series;
    self.selectSpec = spec;
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:EAddRowItemCarType inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark AreaDelegate Methods

- (void) selectedCitys:(NSArray *)array;{
    self.selectCitys = [NSMutableArray arrayWithArray:array];

    if (self.engineNum.length < engineLen && self.engineNum.length > 0) {
        if (engineLen == 99 ) {
            if (self.engineNum.length < 5 || self.engineNum.length > 24) {
                [self showInfoView:@"因城市变更，您输入的发动机号有误"];
            }
        } else {
            [self showInfoView:@"因城市变更，您输入的发动机号长度不够"];
        }
    }
    if (self.frameNum.length < frameLen && self.frameNum.length > 0) {
        if (frameLen == 99 ) {
            if (self.frameNum.length < 5 || self.frameNum.length > 24) {
                [self showInfoView:@"因城市变更，您输入的车架号有误"];
            }
        } else {
            [self showInfoView:@"因城市变更，您输入的车架号长度不够"];
        }
    }
    [self.myTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 11;
    if (frameLen == 0) {
        count --;
    }
    if (engineLen == 0) {
        count --;
    }
    if (registernumlen == 0) {
        count --;
    }
    if (loginurl.length == 0) {
        count -= 2;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [TRSkinManager bgColorLight];
    cell.backgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    if (row >= EAddRowItemEngine && engineLen == 0) {
        row ++;
    }
    if (row >= EAddRowItemCarFrame && frameLen == 0) {
        row ++;
    }
    if (row >= EAddRowItemRegisternum && registernumlen == 0) {
        row++;
    }
    if (row >= EAddRowItemUserName && loginurl.length == 0) {
        row++;
    }
    if (row >= EAddRowItemPasssword && loginurl.length == 0) {
        row++;
    }
    
    if (row <= EAddRowItemBeizhu) {
        UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//        bgBtn.layer.cornerRadius = 10;
        bgBtn.layer.borderWidth = 1;
        bgBtn.layer.borderColor = [TRSkinManager bgColorDark].CGColor;
        NSArray *texts = [NSArray arrayWithObjects:@"车       系", @"查询城市", @"车牌号码",@"发动机号",@"车架号码",@"登记证书",@"用  户  名", @"密       码",@"备       注", nil];
        [bgBtn setTitle:[texts objectAtIndex:row] forState:UIControlStateNormal];
        [bgBtn setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
        [bgBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [bgBtn setBackgroundColor:[TRSkinManager bgColorWhite]];
        bgBtn.frame = CGRectMake(0, 8, tableView.width, 44);
        [bgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
        [bgBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:bgBtn];
        if (row == EAddRowItemCity) {
            bgBtn.tag = EAddRowItemCity + 1000;
            UILabel *label = [self createLabel:@"请选择一个或多个城市"];
            NSMutableString *citys = [NSMutableString string];
            for (City *city in self.selectCitys) {
                if (citys.length > 0) {
                    [citys appendString:@" "];
                }
                [citys appendString:city.name];
            }
            if (selectCitys.count > 0) {
                label.textColor = [TRSkinManager colorWithInt:KSelectedTextColor];
                label.text = citys;
            }
            [bgBtn addSubview:label];
            [bgBtn addSubview:[self createNextImageView]];
        }
        else if(row == EAddRowItemCarNum){
            bgBtn.tag = EAddRowItemCarNum + 1000;
            UIButton *custom = [UIButton buttonWithType:UIButtonTypeCustom];
            custom.frame = CGRectMake(106, 0, 44, 44);
            NSString *text = proShortName;
            if (proShortName == nil || proShortName.length == 0) {
                text = @"京";
            }
            [custom setTitle:text forState:UIControlStateNormal];
            [custom setImage:TRImage(@"arrowDown.png") forState:UIControlStateNormal];
            [custom setImage:TRImage(@"arrowDownHL.png") forState:UIControlStateHighlighted];
            [custom setImageEdgeInsets:UIEdgeInsetsMake(0, custom.titleLabel.width, 0, 0)];
            if (kSystemVersion >= 7.0) {
                [custom setTitleEdgeInsets:UIEdgeInsetsMake(0, -custom.imageView.width - 28, 0, 0)];
            } else {
                [custom setTitleEdgeInsets:UIEdgeInsetsMake(0, -custom.imageView.width - 14, 0, 0)];
            }
            
            [custom setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
            [bgBtn addSubview:custom];
            [custom addTarget:self action:@selector(showShortView) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *input = [self createInput:@"请输入车牌号"];
            input.frame = CGRectMake(150, 11, 160, 22);
            input.tag = 2000 + EAddRowItemCarNum;
            if (self.carNum.length > 0) {
                input.text = self.carNum;
            }
            [bgBtn addSubview:input];
        }
        else if(row == EAddRowItemEngine){
            bgBtn.tag = EAddRowItemEngine + 1000;
            UITextField *input = [self createInput:@"请输入全部发动机号"];
            [bgBtn addSubview:input];
            if (engineLen != 99) {
                if(engineLen == 0){
                    input.placeholder = [NSString stringWithFormat:@"请输入发动机号(选填)"];
                } else {
                    input.placeholder = [NSString stringWithFormat:@"请输入后%d位发动机号", engineLen];
                }
            }
            input.tag = 2000 + EAddRowItemEngine;
            if (self.engineNum.length > 0) {
                input.text = self.engineNum;
            }
            UIButton *btn = [self createInfoBtn];
            btn.tag = EAddRowItemEngine + 100;
            [bgBtn addSubview:btn];
        }
        else if(row == EAddRowItemCarFrame){
            bgBtn.tag = EAddRowItemCarFrame + 1000;
            UITextField *input = [self createInput:@"请输入全部车架号"];
            if (frameLen != 99) {
                if(frameLen == 0){
                    input.placeholder = [NSString stringWithFormat:@"请输入车架号码(选填)"];
                } else {
                    input.placeholder = [NSString stringWithFormat:@"请输入后%d位车架号", frameLen];
                }
            }
            input.tag = 2000 + EAddRowItemCarFrame;
            if (self.frameNum.length > 0) {
                input.text = self.frameNum;
            }
            [bgBtn addSubview:input];
            UIButton *btn = [self createInfoBtn];
            btn.tag = EAddRowItemCarFrame + 100;
            [bgBtn addSubview:btn];
        }
        else if(row == EAddRowItemCarType){
            bgBtn.tag = EAddRowItemCarType + 1000;
            UILabel *label = [self createLabel:@"请选择车系(选填)"];
            if (self.selectBrand && self.selectSeries ) {
                label.text = [NSString stringWithFormat:@"%@",  self.selectSeries.name];
                label.textColor = [TRSkinManager colorWithInt:KSelectedTextColor];
            }
            [bgBtn addSubview:label];
            [bgBtn addSubview:[self createNextImageView]];
        }
        //新加
        else if(row == EAddRowItemRegisternum){
            bgBtn.tag = EAddRowItemRegisternum + 1000;
            UITextField *input = [self createInput:@"请输入全部证书号码"];
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [bgBtn addSubview:input];
            if (registernumlen != 99) {
                if(registernumlen == 0){
                    input.placeholder = [NSString stringWithFormat:@"请输入证书号码(选填)"];
                } else {
                    input.placeholder = [NSString stringWithFormat:@"请输入后%d位证书号码", engineLen];
                }
            }
            input.tag = 2000 + EAddRowItemRegisternum;
            if (self.registerNum.length > 0) {
                input.text = self.registerNum;
            }
            UIButton *btn = [self createInfoBtn];
            btn.tag = EAddRowItemRegisternum + 100;
            [bgBtn addSubview:btn];
        }
        //新加
        else if(row == EAddRowItemUserName){
            bgBtn.tag = EAddRowItemUserName + 1000;
            NSString *text = [NSString stringWithFormat:@"%@用户名", self.jiaoguanjuName];
            UITextField *input = [self createInput:text];
            [bgBtn addSubview:input];
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            input.keyboardType = UIKeyboardTypeDefault;
            input.tag = 2000 + EAddRowItemUserName;
            if (self.userName.length > 0) {
                input.text = self.userName;
            }
            UIButton *btn = [self createInfoBtn];
            btn.tag = EAddRowItemUserName + 100;
            [bgBtn addSubview:btn];
        }
        //新加
        else if(row == EAddRowItemPasssword){
            bgBtn.tag = EAddRowItemPasssword + 1000;
            
            NSString *text = [NSString stringWithFormat:@"%@密码", self.jiaoguanjuName];
            UITextField *input = [self createInput:text];
            [bgBtn addSubview:input];
            input.keyboardType = UIKeyboardTypeASCIICapable;
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            input.tag = 2000 + EAddRowItemPasssword;
            if (self.password.length > 0) {
                NSRange r = [self.password rangeOfString:@"00wzcx_"];
                if (r.length > 0) {
                    NSString *str = [self.password substringFromIndex:r.length];
                    str = [Des doCipher2:str key:[[TRUtility getAppKey] substringToIndex:8] iv:nil context:kCCDecrypt];
                    input.text = str;
                } else {
                    input.text = self.password;
                }
            }
            
            UIButton *btn = [self createInfoBtn];
            btn.tag = EAddRowItemPasssword + 100;
            [bgBtn addSubview:btn];
        }
        
        else if(row == EAddRowItemBeizhu){
            bgBtn.tag = EAddRowItemBeizhu + 1000;
            UITextField *input = [self createInput:@"输入爱车昵称(选填)"];
            input.keyboardType = UIKeyboardTypeDefault;
            input.tag = 2000 + EAddRowItemBeizhu;
            if (self.nickName.length > 0) {
                input.text = self.nickName;
            }
            [bgBtn addSubview:input];
        }
    } else if(row == EAddRowItemBeizhu + 1){
        UIImage *bgImage = [TRImage(@"loginBg.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(self.view.width/2 - 297/2, 8, 297, 44);
        [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
//        [bgBtn setBackgroundImage:TRImage(@"loginBgHL.png") forState:UIControlStateHighlighted];
        [bgBtn setTitle:@"开始查询" forState:UIControlStateNormal];
        if (carData != nil) {
            [bgBtn setTitle:@"保存修改" forState:UIControlStateNormal];
        }
        [bgBtn.titleLabel setFont:[TRSkinManager largeFont2]];
        [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
        [bgBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:bgBtn];
    } else if(row == EAddRowItemBeizhu + 2){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, tableView.width-14*2, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"所填信息为当地交管局查询所必需信息，我们将对您的信息严格保密，请放心填写。";
        label.textColor = [TRSkinManager colorWithInt:0x9b9b9b];
        label.font = [TRSkinManager smallFont1];
        label.numberOfLines = 0;
        [cell addSubview:label];
    }
    return cell;
}

-(UILabel *) createLabel:(NSString *) text{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(106, 0, 190, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;

    label.textColor = [TRSkinManager colorWithInt:0xb3b3b3];
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

-(UIImageView *) createNextImageView{
    UIImage *image = TRImage(@"nextStep.png");
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.frame = CGRectMake(305 - image.size.width, 22 - image.size.height / 2, image.size.width, image.size.height);
    return view;
}

-(UITextField *) createInput :(NSString *) holdText{
    TRTextField *input = [[TRTextField alloc] initWithFrame:CGRectMake(106, 11, 178, 22)];
    input.borderStyle = UITextBorderStyleNone;
    input.placeholder = holdText;
    input.font = [UIFont systemFontOfSize:16];
    [input setTextColor:[TRSkinManager colorWithInt:KSelectedTextColor]];
    input.keyboardType = UIKeyboardTypeASCIICapable;
    input.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    input.autocorrectionType = UITextAutocorrectionTypeNo;
    input.delegate = self;
    input.moveSuperView = myTableView;
    return input;
}

-(UIButton *) createInfoBtn{
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = TRImage(@"info.png");
    infoBtn.frame = CGRectMake(305 - image.size.width, 22 - image.size.height / 2, image.size.width, image.size.height);
    [infoBtn setBackgroundImage:image forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:TRImage(@"info_hl.png") forState:UIControlStateHighlighted];
    [infoBtn addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
    return infoBtn;
}

-(void) btnClick2:(UIButton *) btn{
    UIView *superView = btn.superview;
    CGRect myrect = btn.frame;
    /**
     *	计算自身相对与window的坐标
     */
    while (superView != nil && ![superView isKindOfClass:[UIWindow class]]) {
        myrect.origin.y += superView.origin.y;
        if ([superView isKindOfClass:[UIScrollView class]]) {
            myrect.origin.y -= [(UIScrollView *)superView contentOffset].y;
        }
        superView = superView.superview;
    }
    
    if (EAddRowItemCarFrame == btn.tag - 100) {
        TRPictrueView *view = [[TRPictrueView alloc] initWithImage:@"frame.png"];
        [view showAtFrame:myrect];
    } else if(EAddRowItemEngine == btn.tag - 100){
        TRPictrueView *view = [[TRPictrueView alloc] initWithImage:@"engin.png"];
        [view showAtFrame:myrect];
    }
    else if(EAddRowItemRegisternum == btn.tag - 100){
        TRPictrueView *view = [[TRPictrueView alloc] initWithImage2:[UIImage imageNamed:@"reg_num_pic.jpg"]];
        [view showAtFrame:myrect];
    }
    else if(EAddRowItemUserName == btn.tag - 100){
        NSString *str = [NSString stringWithFormat:@"请输入您在%@注册的用户名和密码；", jiaoguanjuName];
        TRPictrueView2 *view = [[TRPictrueView2 alloc] initTitle:@"小问号提示" content:str URL:loginurl];
        [view showAtFrame:myrect];
    }
    else if(EAddRowItemPasssword == btn.tag - 100){
        NSString *str = [NSString stringWithFormat:@"请输入您在%@注册的用户名和密码；", jiaoguanjuName];
        TRPictrueView2 *view = [[TRPictrueView2 alloc] initTitle:@"小问号提示" content:str URL:loginurl];
        [view showAtFrame:myrect];
    }
    [self hiddenKeyBoard];
}

#pragma mark -
#pragma mark SelectedProDelegate Methods

-(void) showShortView{
    if (focusTextField) {
        [focusTextField resignFirstResponder];
        focusTextField = nil;
    }
    if (shortView == nil) {
        shortView = [[ProShortView alloc] initWithFrame:CGRectMake(0, self.view.height - 216, self.view.width, 216)];
        shortView.delegate = self;
    }
//    [self.view addSubview:shortView];
    [shortView showInView:self.view];
}

-(void) proBeSelected:(NSString *) proName{
    [shortView hiddenKeyBoard];
    self.proShortName = proName;
    NSString * acarNum = [NSString stringWithFormat:@"%@%@", self.proShortName, self.carNum];
    CarInfo *found = nil;
    for (CarInfo *car in [CarInfo globCarInfo]) {
        if ([car.carnumber isEqualToString: acarNum]) {
            found = car;
            break;
        }
    }
    if (found != nil) {
        [MobClick event:@"add_same_carnum"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您添加的车辆已存在，您是否要修改车辆信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil, nil];
        [alert show];
        alert.tag = 201;
    } else {
        carNumRepeat = NO;
    }
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:EAddRowItemCarNum inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSNotification *msg = [NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:textField];
    [self performSelector:@selector(notifyMessage:) withObject:msg afterDelay:0.05];
    if ([string isEqualToString:@""]) {//删除
        return YES;
    }
    NSInteger tag = textField.tag - 2000;
    switch (tag) {
        case EAddRowItemCarNum:
        {
            NSInteger len = textField.text.length + string.length;
            int maxLen = 6;
            if (len > maxLen) {
                return NO;
            }
            NSString *caps = [string uppercaseString];
            if (![caps isEqualToString:string]) {
                NSMutableString *text = [NSMutableString string];
                if (textField.text.length > 0 ) {
                    [text appendString:textField.text];
                    [text insertString:caps atIndex:range.location];
                } else {
                    [text appendString:caps];
                }
                textField.text = text;
                return NO;
            }
            NSString *emailRegex = @"^[a-zA-Z0-9]+$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
            BOOL res = [emailTest evaluateWithObject:string];
            if (!res) {
                [self showInfoView:@"只能输入字母和数字"];
            }
            
            return res;
        }break;
        case EAddRowItemEngine:
        case EAddRowItemCarFrame:
        {
        } break;
        default:{
            if ([string isEqualToString:@"'"] || [string isEqualToString:@"‘"]) {
                return NO;
            }
        }break;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag - 2000;
    switch (tag) {
        case EAddRowItemCarNum:
        {
            self.carNum = textField.text;
        }break;
        case EAddRowItemEngine:
        {
            self.engineNum = textField.text;
        }break;
        case EAddRowItemCarFrame:
        {
            self.frameNum = textField.text;
        }break;
        case EAddRowItemBeizhu:
        {
            self.nickName = textField.text;
        }break;
            
        case EAddRowItemRegisternum:
        {
            self.registerNum = textField.text;
        }break;
        case EAddRowItemUserName:
        {
            self.userName = textField.text;
        }break;
        case EAddRowItemPasssword:
        {
            if (textField.text.length > 0) {
                NSString *coded = [Des doCipher2:textField.text key:[[TRUtility getAppKey] substringToIndex:8] iv:nil context:kCCEncrypt];
                coded = [NSString stringWithFormat:@"00wzcx_%@", coded];
                self.password = coded;
            } else {
                self.password = textField.text;
            }
        }break;
        default:
            break;
    }
}

-(void) setCarData:(CarInfo *) aCarData{
    carData = nil;
    carData = aCarData;
    NSMutableArray *tmparray = [NSMutableArray array];
    SupportCityManager *cityM = [SupportCityManager sharedManager];
    for (CityOfCar * cityCar in carData.citys) {
        City * city = [cityM getCity:cityCar.cityid.intValue];
        if (city) {
            [tmparray addObject:city];
        }
    }
    self.selectCitys = tmparray;
    
    self.proShortName = [carData.carnumber substringToIndex:1];
    self.carNum = [carData.carnumber substringFromIndex:1];
    self.engineNum = carData.enginenumber;
    self.frameNum = carData.framenumber;
    
    self.userName = carData.userName;
    self.password = carData.passWord;
    self.registerNum = carData.registernumber;
    
    NSArray * array = nil;
    if (carData.cartypeId != 0) {
        array = [BrandManager getAllInfoBySpec:carData.cartypeId];
    } else {
        array = [BrandManager getAllInfoBySeries:carData.carSeriesId];
    }
    for (NSObject *obj in array) {
        if ([obj isKindOfClass:[Brand class]]) {
            self.selectBrand = (Brand*)obj;
        } else if([obj isKindOfClass:[Series class]]){
             self.selectSeries = (Series*)obj;
        } else if([obj isKindOfClass:[CarType class]]){
            self.selectSpec = (CarType*)obj;
        }
    }
    self.nickName = carData.carname;
    self.carId = carData.carid.intValue;
}

-(BOOL) dataIsChanged{
    if (carData == nil) {
        if (self.carNum.length > 0 || self.engineNum.length > 0 || self.frameNum.length > 0 || self.nickName.length > 0
            || self.carId != 0 || self.selectSpec.typeId != 0 || self.userName.length > 0 || self.password.length > 0 || self.registerNum.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    NSString * acarNum = [NSString stringWithFormat:@"%@%@", self.proShortName, self.carNum];
    if (![acarNum isEqualToString:carData.carnumber]) {
        return YES;
    }
    if ( self.engineNum.length != carData.enginenumber.length) {
        return YES;
    } else if(![self.engineNum isEqualToString:carData.enginenumber] && self.engineNum != carData.enginenumber){
        return YES;
    }
    if (self.frameNum.length != carData.framenumber.length) {
        return YES;
    } else if (![self.frameNum isEqualToString:carData.framenumber] && self.frameNum != carData.framenumber) {
        return YES;
    }
    if (![self.nickName isEqualToString:carData.carname]) {
        return YES;
    }
    if (self.carId != carData.carid.intValue) {
        return YES;
    }
    if (self.selectSeries.seriesId != carData.carSeriesId) {
        return YES;
    }
    if (![self.userName isEqualToString:carData.userName] && self.userName != carData.userName) {
        return YES;
    }
    if (![self.password isEqualToString:carData.passWord] && self.password != carData.passWord) {
        return YES;
    }
    if (![self.registerNum isEqualToString:carData.registernumber]) {
        return YES;
    }
    
    //检测城市数据是否变化
    if (selectCitys.count != carData.citys.count) {
        return YES;
    }
    for (City * city in selectCitys) {
        BOOL found = NO;
        for (CityOfCar * cityCar in carData.citys) {
            if (cityCar.cityid.intValue == city.cityId) {
                found = YES;
                break;
            }
        }
        if (!found) {
            return YES;
        }
    }
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddenKeyBoard];
}
@end
