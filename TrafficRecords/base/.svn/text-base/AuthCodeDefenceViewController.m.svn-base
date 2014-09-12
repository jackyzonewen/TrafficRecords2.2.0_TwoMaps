//
//  AuthCodeDefenceViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-10-12.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AuthCodeDefenceViewController.h"
#import "CityOfCar.h"
#import "TRTextField.h"
#import "AreaDBManager.h"
#import "JSON.h"
#import "TrafficRecord.h"
#import "OpenUDID.h"
#import "BrandManager.h"
#import "UINavigationController+ViewAnimation.h"
#import "RecordListViewController.h"

#define KImageWidth 100

@implementation AuthCodeCell
@synthesize areaLabel;
@synthesize authImage;
@synthesize input;
@synthesize deleteBtn;
@synthesize line;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 280, 44)];
        label.text = @"北京地区";
        label.numberOfLines = 0;
        label.textColor = [TRSkinManager textColorDark];
        label.backgroundColor = [UIColor clearColor];
        label.font = [TRSkinManager mediumFont2];
        self.areaLabel = label;
        [self addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, label.bottom + 2, 130, 30)];
        [self addSubview:imageView];
        self.authImage = imageView;
        
        self.input = [[TRTextField alloc] initWithFrame:CGRectMake(150, imageView.top, KImageWidth , 32)];
        input.borderStyle = UITextBorderStyleNone;
        input.backgroundColor = [UIColor clearColor];
        input.background = [TRImage(@"inputBg3.png") stretchableImageWithLeftCapWidth:4 topCapHeight:3];
        
        input.keyboardType = UIKeyboardTypeDefault;
        input.returnKeyType = UIReturnKeySend;
        [self addSubview:input];
        
        UIImage *delete = TRImage(@"delete.png");
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setSize:delete.size];
        [btn setBackgroundImage:delete forState:UIControlStateNormal];
        [btn setBackgroundImage:TRImage(@"deleteHL.png") forState:UIControlStateHighlighted];
        [self addSubview:btn];
        self.deleteBtn = btn;
        
        
    }
    return self;
}

@end

////////////////////////////////////////////////////////////

@interface AuthCodeDefenceViewController ()

@end

@implementation AuthCodeDefenceViewController
@synthesize authCodeCarArray;
@synthesize myTableView;
@synthesize currentIndex;
@synthesize inputedText;
@synthesize listTableView;
@synthesize carInfoNew;
@synthesize modifyCarId;
@synthesize theCarid;

-(NSString *) naviTitle{
    if (self.authCodeCarArray.count > 0) {
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:0];
        return carM.carnumber;
    }
    return @"";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    if (carInfoNew != nil) {
        [self.navigationController popViewControllerAnimatedWithTransition:UIViewAnimationTransitionCurlDown];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initAuthCodeArray
{
    self.authCodeCarArray = [NSMutableArray array];
    if (carInfoNew != nil) {
        CarInfo * tmpnewcar = [carInfoNew copyCar];
        [self.authCodeCarArray addObject:tmpnewcar];
        [tmpnewcar.citys removeAllObjects];
        
        for (CityOfCar *cityM in carInfoNew.citys) {
            NSTimeInterval time = [cityM.authovertime doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            if (cityM.authurl.length > 0 && [date compare:[NSDate date]] == NSOrderedDescending) {
                //将base64字符串转换成图片对象
                NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                UIImage *image = [UIImage imageWithData:data];
                
//                NSData *png = UIImagePNGRepresentation(image);
//                NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                NSString *documentDirectory = [directoryPaths objectAtIndex:0];
//                NSString *file = [NSString stringWithFormat:@"%@_%@.png", carInfoNew.carid, cityM.cityid];
//                documentDirectory = [documentDirectory stringByAppendingPathComponent:file];
//                [png writeToFile:documentDirectory atomically:YES];
                
                cityM.authImage = image;
                //将需要验证码的城市加入newCar对象
                [tmpnewcar.citys addObject:cityM];
            }
        }
        return;
    }
    for (CarInfo *temp in [CarInfo globCarInfo]) {
        CarInfo *carM = nil;
        if (self.theCarid.length > 0 && [temp.carid isEqualToString:self.theCarid]) {
            carM = temp;
        } else if(self.theCarid.length == 0){
            carM = temp;
        }
        for (CityOfCar *cityM in carM.citys) {
            NSTimeInterval time = [cityM.authovertime doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            //验证码存在且过期时间大于现在时间
            if (cityM.authurl.length > 0 && [date compare:[NSDate date]] == NSOrderedDescending) {
                CarInfo * tmpnewcar = nil;
                //查找authCodeCarArray数组里是否存在当前有验证码的车辆
                for (CarInfo * tmpCar in self.authCodeCarArray) {
                    if ([tmpCar.carid isEqualToString:carM.carid]) {
                        tmpnewcar = tmpCar;
                        break;
                    }
                }
                //不存在，拷贝当前车辆，并且加入authCodeCarArray数组
                if (tmpnewcar == nil) {
                    tmpnewcar = [carM copyCar];
                    [tmpnewcar.citys removeAllObjects];
                    [self.authCodeCarArray addObject:tmpnewcar];
                }
                //将base64字符串转换成图片对象
                NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                UIImage *image = [UIImage imageWithData:data];
                cityM.authImage = image;
                [tmpnewcar.citys addObject:cityM];
            }
        }
    }

}

-(void) showCarList{
    UIView *view = [self.view viewWithTag:3099];
    view.hidden = !view.hidden;
}

- (void)viewDidLoad
{
    [self initAuthCodeArray];
    self.inputedText = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, KDefaultStartY , self.view.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [self.view addSubview:line];
    self.view.backgroundColor = [TRSkinManager bgColorWhite];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, 36)];
    label.text = @"为了您的信息安全，需输入验证码获得最新信息";
    label.textColor = [TRSkinManager textColorDark];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [TRSkinManager smallFont1];
    [self.view addSubview:label];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom , self.view.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [self.view addSubview:line];
    
    UIImage *bgImage = [TRImage(@"loginBg.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(self.view.width/2 - 297/2, self.view.height - KHeightReduce - 50, 297, 44);
    [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
//    [bgBtn setBackgroundImage:TRImage(@"loginBgHL.png") forState:UIControlStateHighlighted];
    [bgBtn setTitle:@"提交" forState:UIControlStateNormal];
    [bgBtn.titleLabel setFont:[TRSkinManager largeFont1]];
    [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
    [bgBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgBtn];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.bottom, self.view.width, bgBtn.top - line.bottom) style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage *upIcon = TRImage(@"up.png");
    float height = self.authCodeCarArray.count * 44 + upIcon.size.height;
    if (self.authCodeCarArray.count > 6) {
        height = 6 * 44;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, KDefaultStartY, 200, height)];
    view.backgroundColor = [UIColor clearColor];
    view.tag = 3099;
    UIImageView *iconView = [[UIImageView alloc] initWithImage:upIcon];
    [iconView setLeft:148];
    [view addSubview:iconView];
    view.hidden = YES;
    [self.view addSubview:view];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, upIcon.size.height, view.width, height - upIcon.size.height) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [view addSubview:self.listTableView];
//    self.listTableView.hidden = YES;
    self.listTableView.layer.cornerRadius = 4;
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.backgroundView = [[UIView alloc] init];
    self.listTableView.backgroundView.backgroundColor = [TRSkinManager colorWithInt:0x5e5e5e];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(160, 22 - 18, 100, 36);
    NSString *title = nil;
    if (self.authCodeCarArray.count > 0) {
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:0];
        [selectBtn setTitle:carM.carnumber forState:UIControlStateNormal];
        title = carM.carnumber;
    }
    selectBtn.titleLabel.font = [TRSkinManager largeFont2];
    [selectBtn setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
    [selectBtn setTop: 22 - selectBtn.height/2];
    [selectBtn addTarget:self action:@selector(showCarList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = selectBtn;
    float width = [title sizeWithFont:[TRSkinManager largeFont2] constrainedToSize:CGSizeMake(100000, 44)].width;
    UIImageView *icon = [[UIImageView alloc] initWithImage:TRImage(@"dropDown.png")];
    icon.frame = CGRectMake(width + 6, 22 - [TRSkinManager largeFont2].lineHeight/2 + 2, icon.width, icon.height);
    [selectBtn addSubview:icon];
    icon.tag = 100;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFeildValueChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEvent:) name:KNotification_GlobTouchEvent object:nil];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
}

-(void) touchEvent:(NSNotification*) touchMsg{
    UIEvent *event = touchMsg.object;
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = touch.view;
    if (![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UITextField class]] && view != nil) {
        [self hiddenKeyBoard];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddenKeyBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) submit{
    //如果为添加车辆提交验证码，则需要将不需要提交验证码的city也提交进去
    if (carInfoNew != nil) {
        CarInfo *carM = carInfoNew;
        if (carM.citys.count == 0) {
            [self naviLeftClick:nil];
            return;
        }
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:carM.carid forKey:@"carid"];
        NSMutableArray *citys = [NSMutableArray array];
        [dic setObject:citys forKey:@"citys"];
        
        NSMutableString *queryCitys = [NSMutableString string];
        for (CityOfCar * city in carM.citys) {
            if (queryCitys.length > 0) {
                [queryCitys appendString:@","];
            }
            [queryCitys appendString:city.cityid];
            NSString *input = [self.inputedText objectForKey:[NSString stringWithFormat:@"%@_%@", carM.carid, city.cityid]];

            if (input.length > 0) {
                NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                         @"", @"timestamp",
                                         input.length > 0 ? input : @"", @"authcode",
                                         nil];
                [citys addObject:cityDic];
            }
        }
        if (citys.count == 0) {
            [self showInfoView:@"请输入验证码"];
            return;
        }
        NSMutableDictionary *carInfoDic = [NSMutableDictionary dictionary];
        [carInfoDic setObject:[NSNumber numberWithInt:[carM.carid intValue]] forKey:@"carid"];
        [carInfoDic setObject:queryCitys forKey:@"querycitysid"];
        [carInfoDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KGUIDKey] forKey:@"guid"];
        [carInfoDic setObject:[OpenUDID value] forKey:@"deviceid"];
        [carInfoDic setObject:[NSNumber numberWithInt:(int)carM.cartypeId] forKey:@"carspecid"];
        [carInfoDic setObject:[NSNumber numberWithInt:(int)carM.carBrandId] forKey:@"carbrand"];
        [carInfoDic setObject:[NSNumber numberWithInt:(int)carM.carSeriesId] forKey:@"carseries"];
        [carInfoDic setObject:[NSNumber numberWithInt:0] forKey:@"caryeartype"];
//        NSArray * array = [BrandManager getAllInfoBySpec:carM.cartypeId];
//        for (NSObject *obj in array) {
//            if ([obj isKindOfClass:[Brand class]]) {
//                Brand *selectBrand = (Brand*)obj;
//                [carInfoDic setObject:[NSNumber numberWithInt:selectBrand.brandId] forKey:@"carbrand"];
//            } else if([obj isKindOfClass:[Series class]]){
//                Series *selectSeries = (Series*)obj;
//                [carInfoDic setObject:[NSNumber numberWithInt:selectSeries.seriesId] forKey:@"carseries"];
//            } else if([obj isKindOfClass:[CarType class]]){
//                CarType *selectSpec = (CarType*)obj;
//                [carInfoDic setObject:[NSNumber numberWithInt:selectSpec.yearId] forKey:@"caryeartype"];
//            }
//        }
        [carInfoDic setObject:carM.carnumber forKey:@"carnumber"];
        [carInfoDic setObject:[NSNumber numberWithInt:[TRAppDelegate appDelegate].userId] forKey:@"userid"];
        [carInfoDic setObject:carM.enginenumber.length > 0 ? carM.enginenumber : @"" forKey:@"enginenumber"];
        [carInfoDic setObject:carM.framenumber > 0 ? carM.framenumber : @"" forKey:@"framenumber"];
        [carInfoDic setObject:[NSNumber numberWithInt:0] forKey:@"carstatus"];
        [carInfoDic setObject:carM.carname forKey:@"carname"];
        [carInfoDic setObject:carM.picUrl.length > 0 ? carM.picUrl : @"" forKey:@"pic"];
        
        
        
        [carInfoDic setObject:carM.userName.length > 0 ? carM.userName : @"" forKey:@"username"];
        [carInfoDic setObject:carM.passWord.length > 0 ? carM.passWord : @"" forKey:@"userpwd"];
        [carInfoDic setObject:carM.registernumber.length > 0 ? carM.registernumber : @"" forKey:@"registernumber"];
        
//        NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonArray forKey:@"carcode"];
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:dic, @"carcode",
                                 carInfoDic, @"carinfo", nil];
        NSString * text = [postDic JSONRepresentation];
        if (addAuthCodeServices == nil) {
            addAuthCodeServices = [[AddAuthCodeServices alloc] init];
            addAuthCodeServices.delegate = self;
        }
        [addAuthCodeServices queryTrafRecord:text];
        [self showLoadingAnimated:YES];
        return;
    }
    
    if (currentIndex < self.authCodeCarArray.count) {
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
        if (carM.citys.count == 0) {
            [self naviLeftClick:nil];
            return;
        }
        NSMutableArray * jsonArray = [NSMutableArray array];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:carM.carid forKey:@"carid"];
        NSMutableArray *citys = [NSMutableArray array];
        [dic setObject:citys forKey:@"citys"];
        for (CityOfCar * city in carM.citys) {
            NSString *input = [self.inputedText objectForKey:[NSString stringWithFormat:@"%@_%@", carM.carid, city.cityid]];
            if (input.length > 0) {
                NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                         city.timestamp, @"timestamp",
                                         input, @"authcode",
                                         nil];
                [citys addObject:cityDic];
            }

        }
        if (citys.count == 0) {
            [self showInfoView:@"请输入验证码"];
            return;
        }
        [jsonArray addObject:dic];
        NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonArray forKey:@"carinfo"];
        NSString * text = [postDic JSONRepresentation];
        if (queryService == nil) {
            queryService = [[AuthCodeQueryService alloc] init];
            queryService.delegate = self;
        }
        [queryService queryTrafRecord:text];
        [self showLoadingAnimated:YES];
    }
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    if (tag == EServiceAddCarAuthCode) {
        NSDictionary *dic = addAuthCodeServices.responseDic;
        NSDictionary *result = [dic objectForKey:@"result"];
        
        NSString *carid = [NSString stringWithFormat:@"%d", [[result objectForKey:@"carid"] intValue]];
        CarInfo *carM = carInfoNew;//[self.authCodeCarArray objectAtIndex:currentIndex];
        carM.picUrl = [result objectForKey:@"pic"];
        carM.totalMoney = 0;
        carM.totalScore = 0;
        carM.totalNew = 0;
        BOOL unknownMoney = YES;
        BOOL unknownScore = YES;
        
        
        CarInfo *oldCarM = nil;
        NSString *beDeleteCarId = self.modifyCarId;
        //若果车牌号变更，则carid变更；否则，carid不变，只需更新carinfo的其他数据
        if (beDeleteCarId.length == 0) {
            beDeleteCarId = carid;
        }
        for (CarInfo *temp in [CarInfo globCarInfo]) {
            if ([temp.carid isEqualToString:beDeleteCarId]) {
                oldCarM = temp;
                //将数据库中旧数据删除
                [CarInfo deleteCar:beDeleteCarId];
                break;
            }
        }
        if (oldCarM == nil) {
            if ([CarInfo globCarInfo].count > 0) {
                carM.sortIndex = [(CarInfo*)[[CarInfo globCarInfo] lastObject] sortIndex] + 1;
            } else {
                carM.sortIndex = 0;
            }
        } else {
            carM.sortIndex = oldCarM.sortIndex;
            [[CarInfo globCarInfo] removeObject:oldCarM];
        }
        //将新的车辆信息 加入数据库
        [CarInfo insertCar:carM];
        
        NSArray *citys = [result objectForKey:@"citys"];
        for (NSDictionary * cityDic in citys) {
            NSString *cityId = [cityDic objectForKey:@"cityid"];
            if ([cityId isKindOfClass:[NSNumber class]]) {
                cityId = [NSString stringWithFormat:@"%ld",[[cityDic objectForKey:@"cityid"] longValue]];
            }
            NSString *timeStamp = [cityDic objectForKey:@"timestamp"];
            if ([timeStamp isKindOfClass:[NSNumber class]]) {
                timeStamp = [NSString stringWithFormat:@"%lld",[[cityDic objectForKey:@"timestamp"] longLongValue]];
            }
            CityOfCar *cityM = [carM getCityById:cityId];
            if (cityM == nil) {
                cityM = [[CityOfCar alloc] init];
                cityM.carid = carM.carid;
                cityM.cityid = cityId;
                cityM.timestamp = @"";
            }
            BOOL needAuth = YES;
            cityM.authInfoMsg = [cityDic objectForKey:@"authinfo"];
            NSString *imageUrl = [cityDic objectForKey:@"authimage"];
            //如果authimage值为null，则无需验证码
            if ([imageUrl isKindOfClass:[NSNull class]]) {
                needAuth = NO;
            } else {
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
                cityM.timestamp = timeStamp;
                cityM.authurl = nil;
                cityM.authImage = nil;
                cityM.authovertime = nil;
                //解析违章数据，其中包括过往的所有已处理，未处理数据
                NSArray *recordArray = [cityDic objectForKey:@"violationdata"];
                if ([recordArray isKindOfClass:[NSNull class]]) {
                    recordArray = [NSArray array];
                }
                NSMutableArray *newrecords = [NSMutableArray array];
                for (NSDictionary * recordDic in recordArray) {
                    TrafficRecord *record = [TrafficRecord parseFromJson:recordDic];
                    record.cityid = cityM.cityid;
                    record.carid = carM.carid;
                    [newrecords addObject:record];
                }
                //更新数据库中记录
                [TrafficRecord replacecar:carM.carid withCity:cityM.cityid inserRecords:newrecords];
                
                NSArray *oldArray = [oldCarM recordsOfCity:cityId];
                //将新数据同步到carinfo对象中
                for (TrafficRecord *record in newrecords) {
                    //1为未处理,统计总分和总扣钱数；否则不显示且不统计
                    if (record.processstatus == 1) {
                        [carM.trafficRecods addObject:record];
                        if (record.score >= 0) {
                            carM.totalScore += record.score;
                            unknownScore = NO;
                        }
                        if (record.money >= 0) {
                            carM.totalMoney += record.money;
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
                        carM.totalNew ++;
                    }
                }
            }
            //更新城市数据库
            [carM updateCity:cityM];
        }
        if (carM.trafficRecods.count > 0 ) {
            carM.unknownMoney = unknownMoney;
            carM.unknownScore = unknownScore;
        } else {
            carM.unknownScore = NO;
            carM.unknownScore = NO;
        }
        
        if ([CarInfo globCarInfo].count == 0) {
            [[CarInfo globCarInfo] addObject:carM];
        } else {
            for (int i = 0; i < [CarInfo globCarInfo].count; i++) {
                CarInfo *temp =  [[CarInfo globCarInfo] objectAtIndex:i];
                if (temp.sortIndex >= carM.sortIndex) {
                    [[CarInfo globCarInfo] insertObject:carM atIndex:i];
                    break;
                } else {
                    if (i == [CarInfo globCarInfo].count - 1) {
                        [[CarInfo globCarInfo] addObject:carM];
                        break;
                    }
                }
            }
        }
        //卸载内存中旧数据
//        [CarInfo resetAllCars];
        self.authCodeCarArray = nil;
        
        //数据更新成功，通知首页刷新UI,返回首页;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
        if (oldCarM == nil) {
            [self showInfoView:@"添加车辆成功"];
        } else {
            [self showInfoView:@"车辆修改成功"];
        }
        
        RecordListViewController *listView = [[RecordListViewController alloc] init];
        listView.carInfo = carM;
        [self.navigationController pushViewController:listView animatedWithTransition:UIViewAnimationTransitionCurlUp];
    }
    else if (tag == EServiceAuthCodeQuery) {
        NSDictionary *dic = queryService.responseDic;
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *items = [result objectForKey:@"items"];
        if (items.count == 0) {
            //发生错误
            [self showInfoView:@"网络数据错误"];
            return;
        }
        NSDictionary * carInfoDic = [items objectAtIndex:0];
        NSString *carid = [NSString stringWithFormat:@"%d", [[carInfoDic objectForKey:@"carid"] intValue]];
        
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
        for (CarInfo *temp in [CarInfo globCarInfo]) {
            if ([temp.carid isEqualToString:carM.carid]) {
                carM = temp;
                break;
            }
        }
        
        if (![carid isEqualToString:carM.carid]) {
            //发生错误
            [self showInfoView:@"网络数据错误"];
            return;
        }
        //新增字段
        carM.status = [[carInfoDic objectForKey:@"carreturncode"] intValue];
        carM.statusMsg = [carInfoDic objectForKey:@"returnmessage"];
        
        NSArray *citys = [carInfoDic objectForKey:@"citys"];
        int failedCount = 0;
        for (NSDictionary * cityDic in citys) {
            NSString *cityId = [cityDic objectForKey:@"cityid"];
            if ([cityId isKindOfClass:[NSNumber class]]) {
                cityId = [NSString stringWithFormat:@"%ld",[[cityDic objectForKey:@"cityid"] longValue]];
            }
            NSString *timeStamp = [cityDic objectForKey:@"timestamp"];
            if ([timeStamp isKindOfClass:[NSNumber class]]) {
                timeStamp = [NSString stringWithFormat:@"%lld",[[cityDic objectForKey:@"timestamp"] longLongValue]];
            }
            CityOfCar *cityM = [carM getCityById:cityId];
            BOOL needAuth = YES;
            cityM.authInfoMsg = [cityDic objectForKey:@"authinfo"];
            NSString *imageUrl = [cityDic objectForKey:@"authimage"];
            //如果authimage值为null，则无需验证码
            if ([imageUrl isKindOfClass:[NSNull class]]) {
                needAuth = NO;
            } else {
                if (imageUrl == nil || imageUrl.length == 0) {
                    needAuth = NO;
                }
            }
            //需要输入验证码
            if (needAuth) {
                failedCount ++;
                cityM.authurl = imageUrl;
                NSDate *overTime = [NSDate dateWithTimeIntervalSinceNow:KTimeStampOverTime];
                NSTimeInterval time = [overTime timeIntervalSince1970];
                cityM.authovertime = [NSString stringWithFormat:@"%lf", time];
            } else {
                cityM.timestamp = timeStamp;
                cityM.authurl = nil;
                cityM.authImage = nil;
                cityM.authovertime = nil;
                //解析违章数据，其中包括过往的所有已处理，未处理数据
                NSArray *recordArray = [cityDic objectForKey:@"violationdata"];
                if ([recordArray isKindOfClass:[NSNull class]]) {
                    recordArray = [NSArray array];
                }
                NSMutableArray *newrecords = [NSMutableArray array];
                for (NSDictionary * recordDic in recordArray) {
                    TrafficRecord *record = [TrafficRecord parseFromJson:recordDic];
                    record.cityid = cityM.cityid;
                    record.carid = carM.carid;
                    [newrecords addObject:record];
                    
                    BOOL befound = NO;
                    for (int j = 0; j < carM.trafficRecods.count; j++) {
                        TrafficRecord *temp = [carM.trafficRecods objectAtIndex:j];
                        if ([temp.recordid isEqualToString:record.recordid]) {
                            befound = YES;
                            [carM.trafficRecods replaceObjectAtIndex:j withObject:record];
                            break;
                        }
                    }
                    //如果没找到，则替换
                    if (!befound) {
                        [carM.trafficRecods addObject:record];
                    }
                }
                //更新数据库中记录
                [TrafficRecord replacecar:carM.carid withCity:cityM.cityid inserRecords:newrecords];
            }
            //更新城市数据库
            [carM updateCity:cityM];
            
            for (int i = 0; i < carM.citys.count; i++) {
                CityOfCar *city = [carM.citys objectAtIndex:i];
                if ([city.cityid isEqualToString:cityM.cityid]) {
                    [carM.citys replaceObjectAtIndex:i withObject:cityM];
                    break;
                }
            }
        }
//        //卸载内存中旧数据
//        [CarInfo resetAllCars];
        self.authCodeCarArray = nil;

        if (failedCount > 0 ) {
            //因为可能城市减少，验证码数据变更等等，重新载入数据
            [self showInfoView:[NSString stringWithFormat:@"您有%d处验证码输入有误，请重新输入", failedCount]];
            [self initAuthCodeArray];
            [self.myTableView reloadData];
        } else {
            //数据更新成功，通知首页刷新UI,返回首页;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
    
    if (tag == EServiceAddCarAuthCode) {
        //车辆信息有问题，回退到车辆添加页面重新填写
//        if (errorCode == -61 || errorCode == -62 || errorCode == -63 || errorCode == -64) {
        [self.navigationController popViewControllerAnimatedWithTransition:UIViewAnimationTransitionCurlDown];
//        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.myTableView) {
        if (self.authCodeCarArray.count > currentIndex) {
            CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
            return carM.citys.count;
        }
    } else if(tableView == self.listTableView){
        return self.authCodeCarArray.count;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myTableView) {
        if (self.authCodeCarArray.count > currentIndex) {
            CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
            CityOfCar *cityM = [carM.citys objectAtIndex:indexPath.row];
            if(cityM.authImage == nil)
                return 64;
            float imageH = cityM.authImage.size.height * (KImageWidth / cityM.authImage.size.width);
            if (cityM.authImage.size.width >= KImageWidth * 1.5) {
                imageH = cityM.authImage.size.height * (KImageWidth * 1.5 / cityM.authImage.size.width);
            }
            return imageH + 64;
        }
    }else if(tableView == self.listTableView){
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹出的tableView
    if(tableView == self.listTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authcodeCell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"authcodeCell2"];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, listTableView.width, 0.5)];
            line.backgroundColor = [TRSkinManager colorWithInt:0x4d4c4c];
//            line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [cell addSubview:line];
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [TRSkinManager colorWithInt:0x5e5e5e];
            
            UIImageView *arrow = [[UIImageView alloc] initWithImage:TRImage(@"next3.png")];
            arrow.frame = CGRectMake(tableView.width - arrow.width - 10, 22 - arrow.height/2, arrow.width, arrow.height);
            [cell addSubview:arrow];
        }
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:indexPath.row];
        cell.textLabel.text = carM.carnumber;
        cell.textLabel.textColor = [TRSkinManager textColorWhite];
        return cell;
    }
    
    //验证码tableView
    AuthCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"authcodeCell"];
    float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AuthCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"authcodeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.authCodeCarArray.count > currentIndex) {
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
        CityOfCar *cityM = nil;
        if (carM.citys.count > indexPath.row) {
            cityM = [carM.citys objectAtIndex:indexPath.row];
        }
        City *city = [AreaDBManager getCityByCityId:[cityM.cityid integerValue]];
        cell.areaLabel.text = [NSString stringWithFormat:@"%@地区", city.name];
        if (cityM.authInfoMsg.length > 0) {
            cell.areaLabel.text = [NSString stringWithFormat:@"%@(%@)", cell.areaLabel.text, cityM.authInfoMsg];
        }
        cell.authImage.image = cityM.authImage;
        float imageW = KImageWidth;
        float imageH = 0;
        if(cityM.authImage != nil){
            imageH = cityM.authImage.size.height * (KImageWidth / cityM.authImage.size.width);
            if (cityM.authImage.size.width >= KImageWidth * 1.5) {
                imageH = cityM.authImage.size.height * (KImageWidth * 1.5 / cityM.authImage.size.width);
                imageW = KImageWidth *1.5;
            }
        }
        [cell.authImage setSize:CGSizeMake(imageW, imageH)];
        cell.input.delegate = self;
        cell.input.tag = indexPath.row + 1000;
        if (imageW == KImageWidth *1.5) {
            [cell.input setLeft:cell.authImage.right + 10];
        } else {
            [cell.input setLeft:150];
        }
        [(TRTextField *)cell.input setMoveSuperView:myTableView];
        cell.input.text = [self.inputedText objectForKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
        cell.deleteBtn.frame = CGRectMake(self.view.width - cell.deleteBtn.size.width, height/2 - cell.deleteBtn.size.height/2, cell.deleteBtn.size.width, cell.deleteBtn.size.height);
        cell.deleteBtn.tag = indexPath.row + 1100;
        if (carM.citys.count == 1) {
            cell.deleteBtn.hidden = YES;
        } else {
            cell.deleteBtn.hidden = NO;
        }
        [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.line setTop:height - cell.line.height];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL res = [super textFieldShouldReturn:textField];
    [self performSelector:@selector(submit) withObject:nil afterDelay:0];
    return res;
}

-(void) textFeildValueChanged:(NSNotification *) msg{
    UITextField *textField = msg.object;
    NSInteger row = textField.tag - 1000;
    CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
    CityOfCar *cityM = nil;
    if (carM.citys.count > row) {
        cityM = [carM.citys objectAtIndex:row];
    }
    if (textField.text) {
        [self.inputedText setObject:textField.text forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
    } else {
        [self.inputedText setObject:@"" forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"text"] && [object isKindOfClass:[UITextField class]]) {
        UITextField *textField = object;
        NSInteger row = textField.tag - 1000;
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
        CityOfCar *cityM = nil;
        if (carM.citys.count > row) {
            cityM = [carM.citys objectAtIndex:row];
        }
        if (textField.text) {
            [self.inputedText setObject:textField.text forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
        } else {
            [self.inputedText setObject:@"" forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.listTableView) {
        currentIndex = (int)indexPath.row;
        [self showCarList];
        UIButton *btn = (UIButton*)self.navigationItem.titleView;
        if (self.authCodeCarArray.count > currentIndex) {
            CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
            [btn setTitle:carM.carnumber forState:UIControlStateNormal];
            UIImageView *icon = (UIImageView*)[btn viewWithTag:100];
            float width = [[btn titleForState:UIControlStateNormal] sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(100000, 44)].width;
            icon.frame = CGRectMake(width + 6, 22 - [TRSkinManager largeFont2].lineHeight/2 + 2, icon.width, icon.height);
            [self.myTableView reloadData];
        }

        [self.listTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    int row = textField.tag - 1000;
//    CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
//    CityOfCar *cityM = nil;
//    if (carM.citys.count > row) {
//        cityM = [carM.citys objectAtIndex:row];
//    }
//    if (textField.text) {
//        [self.inputedText setObject:textField.text forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
//    } else {
//        [self.inputedText setObject:@"" forKey:[NSString stringWithFormat:@"%@_%@", carM.carid, cityM.cityid]];
//    }
//    return YES;
//}


-(void) btnClick:(UIButton *) btn{
    if (currentIndex >= self.authCodeCarArray.count) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定不查询该地区违章信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
    [alert show];
    alert.tag = btn.tag;
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex){
        NSInteger row = alertView.tag - 1100;
        CarInfo *carM = [self.authCodeCarArray objectAtIndex:currentIndex];
        CityOfCar *cityM = nil;
        if (carM.citys.count > row) {
            cityM = [carM.citys objectAtIndex:row];
        }
        //更新城市到数据库
        if (cityM) {
            cityM.authurl = nil;
            cityM.authImage = nil;
            cityM.authovertime = nil;
        }
        [carM updateCity:cityM];
        
        //将城市从 car移除
        [carM.citys removeObject:cityM];
        [self.myTableView reloadData];
    }
}

@end
