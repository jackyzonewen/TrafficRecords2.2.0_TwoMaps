//
//  TRAutherAlertView.m
//  TrafficRecords
//
//  Created by qiao on 13-12-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRAutherAlertView.h"
#import "JSON.h"
#import "TrafficRecord.h"
#import "AHToastView2.h"
#import "LoadingView.h"
#import "OpenUDID.h"
#import "BrandManager.h"

@implementation TRAutherAlertView

@synthesize textField;
@synthesize authView;
@synthesize carInfoNew;
@synthesize modifyCarId;
@synthesize titleView;
@synthesize cancelBtn;
@synthesize okBtn;
@synthesize changBtn;

-(id) initWithImage:(UIImage *) authCodeImg{
    CGRect rect = [TRAppDelegate appDelegate].window.bounds;
    self =[super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [TRSkinManager colorWithInt:0x85000000];
        float height = 376/2;
        contentView = [[UIView alloc] initWithFrame:CGRectMake(6, self.height/2 - height/2, self.width - 12, height)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 10;
        [self addSubview:contentView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 39)];
        [title setFont:[TRSkinManager mediumFont1]];
        title.text = @"验证码";
        title.textColor = [TRSkinManager colorWithInt:0xfe3c3a];
        title.backgroundColor = [UIColor clearColor];
        [contentView addSubview:title];
        self.titleView = title;
        
        UIImage *delete = TRImage(@"delete2.png");
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(contentView.width - 30 - delete.size.width, title.top, delete.size.width + 30, title.height);
        [deleteBtn setImage:delete forState:UIControlStateNormal];
        [deleteBtn setImage:TRImage(@"delete2HL.png") forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:deleteBtn];
        self.cancelBtn = deleteBtn;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, title.bottom, contentView.width, 0.5)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xfe3c3a];
        [contentView addSubview:line];
        
        UITextField *inputView = [[TRTextField alloc] initWithFrame:CGRectMake(128, 53, 165, 34)];
        [contentView addSubview:inputView];
        inputView.borderStyle = UITextBorderStyleNone;
        inputView.background = [TRImage(@"inputBg3.png") stretchableImageWithLeftCapWidth:4 topCapHeight:3];
        inputView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        ((TRTextField*)inputView).moveSuperView = contentView;
        self.textField = inputView;
        inputView.delegate = self;
        [inputView becomeFirstResponder];
        
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *text = @"看不清楚，换一张";
        changeBtn.frame = CGRectMake(inputView.left, inputView.bottom + 20, [text sizeWithFont:[TRSkinManager smallFont1]].width, 14);
        [changeBtn setTitle:text forState:UIControlStateNormal];
        changeBtn.titleLabel.font = [TRSkinManager smallFont1];
        [changeBtn setTitleColor:[TRSkinManager colorWithInt:0x117acb] forState:UIControlStateNormal];
        [contentView addSubview:changeBtn];
        [changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.changBtn = changeBtn;
        
        UIImage *bgImage = [TRImage(@"loginBg.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(inputView.left, changeBtn.bottom + 20, inputView.width, inputView.height);
        [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
//        [bgBtn setBackgroundImage:TRImage(@"loginBgHL.png") forState:UIControlStateHighlighted];
        [bgBtn setTitle:@"查询" forState:UIControlStateNormal];
        [bgBtn.titleLabel setFont:[TRSkinManager largeFont2]];
        [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
        [contentView addSubview:bgBtn];
        [bgBtn addTarget:self action:@selector(queryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.okBtn = bgBtn;
        
        UIView *kuang = [[UIView alloc] initWithFrame:CGRectMake(15, inputView.top, 101, bgBtn.bottom - inputView.top)];
        kuang.backgroundColor = [UIColor clearColor];
        kuang.layer.borderColor = [TRSkinManager colorWithInt:0xcccccc].CGColor;
        kuang.layer.borderWidth = 1;
        [contentView addSubview:kuang];
        
        float imageW = 100;
        float imageH = authCodeImg.size.height * (imageW / authCodeImg.size.width);
        //        if (authCodeImg.size.width >= imageW * 1.5) {
        //            imageH = authCodeImg.size.height * (100 * 1.5 / authCodeImg.size.width);
        //            imageW = 100 *1.5;
        //        }
        UrlImageView *authCodeView = [[UrlImageView alloc] initWithFrame:CGRectMake(kuang.width/2 - imageW/2, kuang.height/2 - imageH/2, imageW, imageH)];
        authCodeView.image = authCodeImg;
        [kuang addSubview:authCodeView];
        self.authView = authCodeView;
        self.textField.placeholder = @"请输入图形中的文字";
        
        ((TRTextField*)inputView).jiaozhengY = (bgBtn.bottom - inputView.bottom);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEvent:) name:KNotification_GlobTouchEvent object:nil];
    }
    return self;
}

-(void) dealloc{
    [self hiddenKeyBoard];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
}

-(void) touchEvent:(NSNotification*) touchMsg{
    UIEvent *event = touchMsg.object;
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = touch.view;
    if (![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UITextField class]] && view != nil) {
        [self.textField resignFirstResponder];
    }
}

-(void) show{
    [[TRAppDelegate appDelegate].window addSubview:self];
}

-(void) deleteBtnClick:(UIButton *)sender{
    [self removeFromSuperview];
}

-(void) changeBtnClick:(UIButton *)sender{
    if (services == nil) {
        services = [[ChangAuthCodeService alloc] init];
        services.delegate = self;
    }
    if (inLoading) {
        return;
    }
    inLoading = YES;
    if (loading == nil) {
        loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.frame = CGRectMake(self.authView.superview.width/2 - loading.width/2, self.authView.superview.height/2 - loading.height/2, loading.width, loading.height);
    }
    self.authView.image = nil;
    [self.authView.superview addSubview:loading];
    [loading startAnimating];
    
    [services changeService:self.carId city:self.cityId];
    
}

-(void) startLoading{
    [self showLoadingAnimated:YES];
}

-(void) endLoading{
    [self hideLoadingViewAnimated:YES];
}

-(void) queryBtnClick:(UIButton *)sender{
    [self hiddenKeyBoard];
//    {"carinfo": [{"carid": 12345,"citys": [{"cityid":100010,"timestamp": "","authcode":"apxm"}]}]}
    if (self.textField.text.length == 0 ) {
        [self showHintView:@"请输入验证码"];
        return;
    }
    if(inLoading){
        return;
    }
    
    if (carInfoNew != nil) {
        CarInfo *carM = carInfoNew;
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
            NSString *input = self.textField.text;
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                     @"", @"timestamp",
                                     input.length > 0 ? input : @"", @"authcode",
                                     nil];
            [citys addObject:cityDic];
            
        }

        NSMutableDictionary *carInfoDic = [NSMutableDictionary dictionary];
        [carInfoDic setObject:[NSNumber numberWithInt:[carM.carid intValue]] forKey:@"carid"];
        [carInfoDic setObject:queryCitys forKey:@"querycitysid"];
        [carInfoDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KGUIDKey] forKey:@"guid"];
        [carInfoDic setObject:[OpenUDID value] forKey:@"deviceid"];
        [carInfoDic setObject:[NSNumber numberWithInteger:carM.cartypeId] forKey:@"carspecid"];
        [carInfoDic setObject:[NSNumber numberWithInteger:carM.carBrandId] forKey:@"carbrand"];
        [carInfoDic setObject:[NSNumber numberWithInteger:carM.carSeriesId] forKey:@"carseries"];
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
    
    CarInfo *carM = nil;
    for (CarInfo *temp in [CarInfo globCarInfo]) {
        if ([temp.carid isEqualToString: self.carId]) {
            carM = temp;
            break;
        }
    }
    NSMutableArray * jsonArray = [NSMutableArray array];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:carM.carid forKey:@"carid"];
    NSMutableArray *citys = [NSMutableArray array];
    [dic setObject:citys forKey:@"citys"];
    for (CityOfCar * city in carM.citys) {
        if ([city.cityid isEqualToString:self.cityId]) {
            NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid,@"cityid",
                                     city.timestamp, @"timestamp",
                                     self.textField.text, @"authcode",
                                     nil];
            [citys addObject:cityDic];
        }
        
    }
    [jsonArray addObject:dic];
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:jsonArray forKey:@"carinfo"];
    NSString * text = [postDic JSONRepresentation];
    if (queryService == nil) {
        queryService = [[AuthCodeQueryService alloc] init];
        queryService.delegate = self;
    }
    [queryService queryTrafRecord:text];
    inLoading = YES;
    [self showLoadingAnimated:YES];
}

-(void) netServiceContinueWtihTask:(AHServiceRequestTag)tag{
    if(tag == EServiceAuthCodeQuery){
        [self hideLoadingViewAnimated:YES];
        self.hidden = YES;
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceChangeAuthCode) {
        inLoading = NO;
        [loading removeFromSuperview];
        self.authView.image = services.authCode;
        if (services.authinfo.length > 0) {
            self.textField.placeholder = services.authinfo;
        } else {
            self.textField.placeholder = @"请输入图形中的文字";
        }
    } else if(tag == EServiceAuthCodeQuery){
        inLoading = NO;
        [self hideLoadingViewAnimated:YES];
        
        NSDictionary *dic = queryService.responseDic;
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *items = [result objectForKey:@"items"];
        NSDictionary * carInfoDic = [items objectAtIndex:0];
        CarInfo *carM = nil;
        for (CarInfo *temp in [CarInfo globCarInfo]) {
            if ([temp.carid isEqualToString: self.carId]) {
                carM = temp;
                break;
            }
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
                NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                self.authView.image  = [UIImage imageWithData:data];
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
            //更新城市数据库和内存中的城市数据
            [carM updateCity:cityM];
            for (int i = 0; i < carM.citys.count; i++) {
                CityOfCar *city = [carM.citys objectAtIndex:i];
                if ([city.cityid isEqualToString:cityM.cityid]) {
                    [carM.citys replaceObjectAtIndex:i withObject:cityM];
                    break;
                }
            }
        }
        //所有城市结果处理完成，将结果集按time排序
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSArray *sortArray = [carM.trafficRecods sortedArrayUsingComparator: ^NSComparisonResult(id a, id b){
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
        carM.trafficRecods = [NSMutableArray arrayWithArray:sortArray];
        
        if (failedCount == 0 && carM.status == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
            [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        } else {
            if (failedCount != 0) {
                self.textField.text = nil;
                [self showHintView:@"验证码输入有误"];
            } else {
                NSString *statusMsg = nil;
                if (carM.statusMsg.length > 0) {
                    statusMsg = [NSString stringWithFormat:@"%@:%@",carM.carnumber ,carM.statusMsg];
                } else{
                    statusMsg = [NSString stringWithFormat:@"因交管系统变更查询要求，您的牌照为%@的车辆信息需要更新",carM.carnumber];
                }
                [self showHintView:statusMsg];
                [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
            }
        }
    } else if (tag == EServiceAddCarAuthCode) {
        inLoading = NO;
        [self hideLoadingViewAnimated:YES];
        
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
        
        //数据更新成功，通知首页刷新UI,返回首页;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
        if (oldCarM == nil) {
            [self showHintView:@"添加车辆成功"];
        } else {
            [self showHintView:@"车辆修改成功"];
        }
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        NSNotification *msg = [[NSNotification alloc] initWithName:@"authCodeSucess" object:carM userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:msg afterDelay:0.3];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"authCodeSucess" object:carM];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (tag == EServiceChangeAuthCode) {
        inLoading = NO;
        [loading removeFromSuperview];
    } else if(tag == EServiceAuthCodeQuery){
        inLoading = NO;
        [self hideLoadingViewAnimated:YES];
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
    } else{
        inLoading = NO;
        [self hideLoadingViewAnimated:YES];
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        
    }
}

- (void)showHintView:(NSString *)message
{
    UIWindow *window = [TRAppDelegate appDelegate].window;
    AHToastView2 *nv = (AHToastView2 *)[window viewWithTag:1019];
    if (nv) {
        [nv hiddenView];
    }
    nv = [[AHToastView2 alloc] init];
    nv.text = message;
    nv.tag = 1019;
    [nv show];
}

-(UIView*) loadingView {
    UIView * superView = contentView;
    UIView *view = [superView viewWithTag:99];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:contentView.bounds];
        view.backgroundColor = [TRSkinManager colorWithInt:0x44000000];
        view.layer.cornerRadius = 10;
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.frame = CGRectMake(view.width/2 - loadingView.width/2, view.height/2 - loadingView.height/2, loadingView.width, loadingView.height);
        [view addSubview:loadingView];
        [loadingView startAnimating];
        
        view.tag = 99;
    }
    return view;
}

-(void) showLoadingAnimated:(BOOL) animated {
    
    UIView *loadingView = [self loadingView];
    loadingView.alpha = 0.0f;
    
    [contentView addSubview:loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 1.0f;
    }];
}

-(void) hideLoadingViewAnimated:(BOOL) animated {
    
    UIView *loadingView = [self loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark  Imple UITextFieldDelegate Methods


- (BOOL)textFieldShouldReturn:(UITextField *)atextField{
    [atextField resignFirstResponder];
    return NO;
}

-(void) hiddenKeyBoard{
    if (textField) {
        [textField resignFirstResponder];
    }
}
@end
