//
//  TRAppDelegate.m
//  TrafficRecords
//
//  Created by qiao on 13-8-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//
#import "MyWindow.h"
#import "TRAppDelegate.h"
#import "TRMainViewController.h"
#import "ASIHTTPRequest.h"
#import "FMDatabase.h"
#import "TRSettingViewController.h"
#import "MMDrawerVisualState.h"
#import "DBAbstraction.h"
#import "FMDBImplementor.h"
#import "SBJson.h"
#import "CarInfo.h"
#import "SupportCityManager.h"
#import "OpenUDID.h"
#import "Des.h"
#import "UMSocial.h"
#import <MAMapKit/MAMapKit.h>
#import "LimitNumViewController.h"
#import "AreaDBManager.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSAgent.h"
#import "RecordListViewController.h"
#import "CarInfo.h"
#import "BMapKit.h"

@implementation TRAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize appInfo;
@synthesize supportCitys;
@synthesize userId;
@synthesize userName;
@synthesize password;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (kSystemVersion >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if ([KChannelId isEqualToString:KChannelAppStore]) {
        [MobClick startWithAppkey:KUMengAppKey];
    } else {
        [MobClick startWithAppkey:KUMengAppKey reportPolicy:SEND_ON_EXIT channelId:KChannelId];
    }
    [UMSocialData setAppKey:KUMengAppKey];
    
    [UMSAgent setBaseURL:KUMSAgentServerHost debugModel:0];
    if (KChannelId.length == 0) {
        [UMSAgent startWithAppKey:@"wz_ios" ReportPolicy:LOG_REALTIME ChannelId:@"App Store"];
    } else {
        [UMSAgent startWithAppKey:@"wz_ios" ReportPolicy:LOG_REALTIME ChannelId:KChannelId];
    }
    
    [MAMapServices sharedServices].apiKey = KGaoDeMapKey;
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:KQQAppKey appKey:KQQAppSecert url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setSupportQzoneSSO:YES];
    [UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialWechatHandler setWXAppId:KWXAPPKey url:nil];
    

    self.window = [[MyWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initDataBase];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:KGUIDKey] length] == 0) {
        NSDate *date = [NSDate date];
        NSString *str = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        [defaults setObject:str forKey:KGUIDKey];
        [defaults synchronize];
    }
    
    if ([defaults objectForKey:KProductionDBTimestamp] == nil) {
        //设置程序默认时间戳
        [defaults setObject:@"06/25/2014 09:57:00 PM" forKey:KProductionDBTimestamp];
    }
    
    self.userName = [defaults objectForKey:KUserName];
    self.password = [Des decryptStr:[defaults objectForKey:KPassword] key:gKey_addCar iv:gIv_addCar];
    self.userId = [[Des decryptStr:[defaults objectForKey:KUserId] key:gKey_addCar iv:gIv_addCar] intValue];    
    // Override point for customization after application launch.
    self.viewController = [[TRMainViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.viewController];

    
    TRSettingViewController *settingViewCtrller = [[TRSettingViewController alloc] init];
    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:navi leftDrawerViewController:settingViewCtrller];
    drawerController.showsShadow = YES;
    [drawerController setMaximumLeftDrawerWidth:KSettingViewWidth];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeFull;
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState slideVisualStateBlock];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
//    _mapManager = [[BMKMapManager alloc]init];
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [_mapManager start:KBaiduMapKey generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"百度地图启动失败!");
//    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    [self getAppInfo];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    NSString *str =[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleIdentifierKey];
    //企业开发者证书
    if ([str isEqualToString:@"com.TrafficRecords"]) {
        [_mapManager start:KCompanyBaiduMapKey  generalDelegate:nil];
    } else {
        [_mapManager start:KAppStoreBaiduMapKey  generalDelegate:nil];
    }
    /*
     {
     a = 100410;
     aps =     {
     alert = "\U60a8\U8f66\U724c\U4e3a\U4eacQMV135\U6709\U65b0\U7684\U8fdd\U7ae0\U8bb0\U5f55\Uff0c\U8bf7\U70b9\U51fb\U67e5\U770b\U8be6\U60c5>>";
     badge = 0;
     sound = default;
     };
     ext = "return_home:1,vehicle_id:111123";
     id = 11;
     t = 2;
     }
     return_home  0不跳首页 1跳转首页
     */
    if (launchOptions != nil) {
        [MobClick event:@"pushmsg_recived_notinuse"];
        NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"/////////////////////push msg:////////////////////%@", dic);
        NSInteger type = [[dic objectForKey:@"t"] integerValue];
        if (type == 1) {
            NSString *cityID = [dic objectForKey:@"ext"];
            cityID = [cityID stringByReplacingOccurrencesOfString:@"cityid:" withString:@""];
            UIViewController *visableController = self.viewController;
            if (visableController) {
                LimitNumViewController *limitView = [[LimitNumViewController alloc] init];
                limitView.cityId = cityID.intValue;
                if (limitView.cityId == 0) {
                    limitView.cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
                }
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:limitView];
                [visableController presentViewController:navi animated:YES completion:nil];
            }
        } else if(type == 2){
            NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
            NSString *cityName = nil;
            if (cityId > 0) {
                cityName = [AreaDBManager getCityByCityId:cityId].name;
            }
            [MobClick event:@"pushmsg_wz_receive" label:cityName];
            
            NSString *info = [dic objectForKey:@"ext"];
            NSArray *array = [info componentsSeparatedByString:@","];
            NSMutableDictionary *infodic = [NSMutableDictionary dictionary];
            for (NSString *str in array) {
                NSArray *pair = [str componentsSeparatedByString:@":"];
                if (pair.count == 2) {
                    [infodic setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
                }
            }
            //跳转首页
            if ([[infodic objectForKey:@"return_home"] integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_PushMsgReceived object:[NSNumber numberWithBool:YES]];
            } else {//跳转违章记录页
                UIViewController *visableController = self.viewController;
                if (visableController) {
                    NSInteger carId = [[infodic objectForKey:@"vehicle_id"] integerValue];
                    CarInfo *carM = nil;
                    for (CarInfo *car in [CarInfo globCarInfo]) {
                        if ([car.carid integerValue] == carId) {
                            carM = car;
                            break;
                        }
                    }
                    if (carM) {
                        RecordListViewController *listView = [[RecordListViewController alloc] init];
                        listView.carInfo = carM;
                        listView.fromPush = YES;
                        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:listView];
                        [visableController presentViewController:navi animated:YES completion:nil];
                    }
                }
            }
        }
    }
    
    return YES;
}


-(void) getAppInfo{
    if (self.appInfo == nil) {
        self.appInfo = [[GetAppInfoService alloc] init];
        self.appInfo.delegate = self;
    }
    [self.appInfo getAppInfo];
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceGetAppInfo) {
        NSString *cityTimestamp =  self.appInfo.citysTimestamp;
        NSString *productionDBtimestamp =  self.appInfo.productionDBtimestamp;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *localCity = [defaults objectForKey:KCitysTimestamp];
        NSString *localProductionDB = [defaults objectForKey:KProductionDBTimestamp];
        NSString *oldlukuangTimestamp = [defaults objectForKey:KLuKuangTimestamp];
        if (![cityTimestamp isEqualToString:localCity]) {
            //更新支持的城市数据
            self.supportCitys = [[GetSupportCityService alloc] init];
            self.supportCitys.delegate = self;
            [self.supportCitys upDateSupportCitys];
        }
        if (![productionDBtimestamp isEqualToString:localProductionDB]) {
            //更新数据库
            [self upDateProductionDB];
        }
        if (![oldlukuangTimestamp isEqualToString:[self.appInfo luKuangTimeStamp]]) {
            self.luKuangService = [[LuKuangInfoService alloc] init];
            self.luKuangService.delegate = self;
            [self.luKuangService getLuKuangInfo];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GetAppInfo object:nil];
    } else if(tag == EServiceGetSupportCity){
        self.supportCitys = nil;
        NSString * cityTimestamp = self.appInfo.citysTimestamp;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cityTimestamp forKey:KCitysTimestamp];
        [defaults synchronize];
        [[SupportCityManager sharedManager] reloadData];
    } else if(tag == EServiceLuKuangInfo)
    {
        self.luKuangService = nil;
        NSString * luKuangTimeStamp = self.appInfo.luKuangTimeStamp;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:luKuangTimeStamp forKey:KLuKuangTimestamp];
        [defaults synchronize];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (tag == EServiceGetAppInfo) {
    }
}

//- (void)updateAllBrand:(DBAbstraction *)db
//{
//    NSString * sql5 = @"DROP TABLE allcarbrand";
//    NSString * sql6 = @"DROP TABLE allcarseries";
//    NSString * sql7 = @"DROP TABLE allcaryears";
//    NSString * sql8 = @"DROP TABLE allcartype";
//    
//    NSString * sql1 = @"CREATE TABLE allcarbrand ( BrandId text, Name text, FirstLetter text, BrandImg text)";
//    NSString * sql2 = @"CREATE TABLE allcarseries ( SeriesId text, Name text, FatherId text )";
//    NSString * sql3 = @"CREATE TABLE allcaryears ( YearId text, YearName text, FatherId text )";
//    NSString * sql4 = @"CREATE TABLE allcartype ( SpecId text, SpecName text, FatherId text );";
//    [db excuteUpdate:sql5];
//    [db excuteUpdate:sql6];
//    [db excuteUpdate:sql7];
//    [db excuteUpdate:sql8];
//    
//    [db excuteUpdate:sql1];
//    [db excuteUpdate:sql2];
//    [db excuteUpdate:sql3];
//    [db excuteUpdate:sql4];
////    NSURL * url = [NSURL URLWithString:@"http://sp.autohome.com.cn/2sc/specAll.ashx"];
////    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    NSString *textFile = [[NSBundle mainBundle] pathForResource:@"allcars" ofType:@"txt"];
//    NSString *content = [NSString stringWithContentsOfFile:textFile encoding:NSUTF8StringEncoding error:nil];
//    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    NSArray * array = [content JSONValue];
//    for (NSDictionary * brandDic in array) {
//        int brandId = [[brandDic objectForKey:@"Id"] intValue];
//        NSString *brandName = [brandDic objectForKey:@"Name"];
//        NSString *firstLetter = [brandDic objectForKey:@"FirstLetter"];
//        NSString *brandIMG = [brandDic objectForKey:@"BrandImg"];
//        
//        NSString * brandSql = [NSString stringWithFormat:@"INSERT INTO allcarbrand(BrandId, Name, FirstLetter, BrandImg)  VALUES('%d', '%@', '%@', '%@' )",  brandId, brandName, firstLetter, brandIMG];
//        BOOL res = [db excuteUpdate:brandSql];
//        
//        NSArray *seriesArray = [brandDic objectForKey:@"Series"];
//        for (NSDictionary * seriesDic in seriesArray) {
//            int seriesId = [[seriesDic objectForKey:@"Id"] intValue];
//            NSString *seriesName = [seriesDic objectForKey:@"Name"];
//            NSString * seriesSql = [NSString stringWithFormat:@"INSERT INTO allcarseries(SeriesId, Name, FatherId)  VALUES('%d', '%@', '%d' )",  seriesId, seriesName, brandId];
//            res = [db excuteUpdate:seriesSql];
//            NSArray *yearArray = [seriesDic objectForKey:@"Years"];
//            for (NSDictionary * yearDic in yearArray) {
//                int YearId = [[yearDic objectForKey:@"YearId"] intValue];
//                NSString *YearName = [yearDic objectForKey:@"YearName"];
//                NSString * yearSql = [NSString stringWithFormat:@"INSERT INTO allcaryears(YearId, YearName, FatherId)  VALUES('%d', '%@', '%d' )",  YearId, YearName, seriesId];
//                res = [db excuteUpdate:yearSql];
//                NSArray *specArray = [yearDic objectForKey:@"Specs"];
//                for (NSDictionary * specDic in specArray) {
//                    int SpecId = [[specDic objectForKey:@"SpecId"] intValue];
//                    NSString *SpecName = [specDic objectForKey:@"SpecName"];
//                    NSString * specSql = [NSString stringWithFormat:@"INSERT INTO allcartype(SpecId, SpecName, FatherId)  VALUES('%d', '%@', '%d' )",  SpecId, SpecName, YearId];
//                    res = [db excuteUpdate:specSql];
//                }
//            }
//        }
//    }
//    NSLog(@"ok!!!!");
//}

//-(void) updateCity:(DBAbstraction *)db{
//    NSString * sql1 = @"CREATE TABLE Area (AreaId text PRIMARY KEY NOT NULL, Name text, Parent text, FirstLetter nvarchar(6) )";
//    [db excuteUpdate:sql1];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
//    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray * array = [[content JSONValue] objectForKey:@"citys"];
//    for (NSDictionary * dic in array) {
//        sql1 = [NSString stringWithFormat:@"INSERT INTO Area(AreaId, Name, Parent, FirstLetter)  VALUES('%d', '%@', '%d', '%@')",  [[dic objectForKey:@"areaId"] intValue], [dic objectForKey:@"name"], [[dic objectForKey:@"parentId"] intValue], [dic objectForKey:@"firstLetter"]];
//        BOOL res = [db excuteUpdate:sql1];
//        [iConsole info:@"%@:%d", sql1, res];
//    }
//}

- (void)initDataBase
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //1.4.0删除老版本的limitNum2.json旧数据，因为旧数据与新版本不兼容
    if ([[defaults objectForKey:KLimitNumsTimestamp] length] == 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //获取路径
        //参数NSDocumentDirectory要获取那种路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
        //获取文件路径
        NSString *pathll = [documentsDirectory stringByAppendingPathComponent:@"limitNum2.json"];
        [fileManager removeItemAtPath:pathll error:nil];
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [TRUtility searchPath: NSDocumentDirectory];
    docPath = [docPath stringByAppendingPathComponent:@"TRDataBase.rdb"];
    
    //初始化sharedDB，品牌和地区的数据库
    DBAbstraction * db = [DBAbstraction sharedDBAbstraction];
    if (![fm fileExistsAtPath:docPath]) {
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"TRDataBase" ofType:@"rdb"];
        [fm copyItemAtPath:srcPath toPath:docPath error:nil];
    }
    db.implementor = [[FMDBImplementor alloc] initWithPath:docPath];
    
    
    //初始化productionDB，车辆、城市、违章数据库
    db = [DBAbstraction productionDBAbstraction];
    
    //将当前版本的数据库文件导入Document路径
    NSString *currentDbFile = [TRUtility searchPath: NSDocumentDirectory];
    currentDbFile = [currentDbFile stringByAppendingPathComponent:@"Product_1.1.0.db"];
    if (![fm fileExistsAtPath:currentDbFile]) {
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"Product_1.1.0" ofType:@"db"];
        [fm copyItemAtPath:srcPath toPath:currentDbFile error:nil];
    }
    db.implementor = [[FMDBImplementor alloc] initWithPath:currentDbFile];
    
    //1.4.0版本新增3个字段
//    car.userName = [dic objectForKey:@"username"];
//    car.passWord = [dic objectForKey:@"password"];
//    car.registernumber = [dic objectForKey:@"registernumber"];
    //获取表的属性
    NSString *sqlTest = @"select sql from sqlite_master where tbl_name='carinfo' and type='table';";
    NSMutableArray *array  = [db excuteQuery:sqlTest];
    BOOL found = NO;
    if (array.count > 0) {
        NSDictionary *dic = [array objectAtIndex:0];
        NSString *desc = [dic description];
        NSRange r = [desc rangeOfString:@"username"];
        if (r.length != 0) {
            found = YES;
        }
    }
    if (!found) {
        NSString *sql1_140 = @"ALTER TABLE carinfo ADD username text DEFAULT(NULL)";
        NSString *sql2_140 = @"ALTER TABLE carinfo ADD password text DEFAULT(NULL)";
        NSString *sql3_140 = @"ALTER TABLE carinfo ADD registernumber text DEFAULT(NULL)";
        [db synExcuteUpdates:[NSArray arrayWithObjects:sql1_140, sql2_140, sql3_140, nil]];
    }
    
    //如果存在往期数据库版本，则进行数据库的移植
    
    //1.0.0版本升级到当前版本
    NSString * oldDBPath_1_0_0 = [TRUtility searchPath: NSDocumentDirectory];
    oldDBPath_1_0_0 = [oldDBPath_1_0_0 stringByAppendingPathComponent:@"Product.db"];
    if ([fm fileExistsAtPath:oldDBPath_1_0_0]) {
        DBAbstraction *oldDB = [[DBAbstraction alloc] init];
        oldDB.implementor = [[FMDBImplementor alloc] initWithPath:oldDBPath_1_0_0];
        NSArray *array = [oldDB getAllDataAsSql:[NSArray arrayWithObjects:@"carinfo", @"cityinfo", @"trafficrecord",nil]];
        if (array.count > 0) {
            [db synExcuteUpdates:array];
        }
        [fm removeItemAtPath:oldDBPath_1_0_0 error:nil];
    }
}

-(void) upDateProductionDB{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *downloadUrl = [NSString stringWithFormat:@"%@usedcar.db", KServerHost];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:downloadUrl]];
//        if (data == nil) {
//            return ;
//        }
        //写入备份数据库文件
        NSString *docPath = [TRUtility searchPath: NSDocumentDirectory];
        docPath = [docPath stringByAppendingPathComponent:@"TRDataBase_backUp.rdb"];
        BOOL rslt = [data writeToFile:docPath atomically:YES];
        //释放内存
        data = nil;
        if (rslt) {
            DBAbstraction *globDb = [DBAbstraction sharedDBAbstraction];
            __block BOOL compelete = NO;
            while (!compelete) {
                //数据库处于事务处理状态
                if (globDb.implementor == nil || ![globDb.implementor isTransactionInProgress]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        globDb.implementor = nil;
                        
                        NSFileManager * fm = [NSFileManager defaultManager];
                        NSString *docPath2 = [TRUtility searchPath: NSDocumentDirectory];
                        docPath2 = [docPath2 stringByAppendingPathComponent:@"TRDataBase.rdb"];
                        NSError *err = nil;
                        [fm removeItemAtPath:docPath2 error:&err];
                        [fm moveItemAtPath:docPath toPath:docPath2 error:&err];
                        if (err) {
                            NSLog(@"错误日志：%@", err);
                        }
                        globDb.implementor = [[FMDBImplementor alloc] initWithPath:docPath2];
                        compelete = YES;
                        NSString *productionDBtimestamp =  self.appInfo.productionDBtimestamp;
                        [[NSUserDefaults standardUserDefaults] setObject:productionDBtimestamp forKey:KProductionDBTimestamp];
                    });
                } else {
                    sleep(1);
                    NSLog(@"数据库事务处理中，等待事务处理完毕");
                }
            }
        }
    });
}

//- (void)initShareSDK
//{
//    [ShareSDK registerApp:KShareSDKAppKey];
//    [ShareSDK connectTencentWeiboWithAppKey:KQQAppKey appSecret:KQQAppSecert redirectUri:@"http://www.sharesdk.cn"];
//    [ShareSDK connectSinaWeiboWithAppKey:KSinaWeiBoKey appSecret:KSinaWeiBoSecert redirectUri:@"http://www.weizhang.com"];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
//}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (tokenBeSended == NO) {
        NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
        NSLog(@"token reg sucess: %@", token);
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        token = [token stringByTrimmingCharactersInSet:whitespace];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString :@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        //    NSLog(@"%@",token);
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KSaveTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self sendToken];
        tokenBeSended = YES;
    }
}

-(void) sendToken{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey];
    if (token.length == 0) {
        return;
    }
    if (regDeviceTokenService == nil) {
        regDeviceTokenService = [[RegDevicesTokenService alloc] init];
        regDeviceTokenService.delegate = self;
    }
    
    [regDeviceTokenService regDevicesToken:[[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey] UID:[NSString stringWithFormat:@"%d", self.userId]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    {
//        a = 100410;
//        aps =     {
//            alert = "\U4eca\U65e5\U9650\U724c\U53f711111";
//            badge = 0;
//            sound = default;
//        };
//        ext = "cityid:110100";
//        id = 17;
//        t = 1;
//    }
    NSLog(@"/////////////////////push msg:////////////////////%@", userInfo);
    NSString *contentMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([[NSDate date] timeIntervalSinceDate:enterForegroundTime] < 1) {
        [MobClick event:@"pushmsg_recived_notinuse"];
        [self dealPushMsg:userInfo];
    } else {
        [MobClick event:@"pushmsg_recived_inuse"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:contentMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        pushInfo = userInfo;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        return;
    }
    [self dealPushMsg:pushInfo];
    pushInfo = nil;
}

-(void) dealPushMsg:(NSDictionary *) userInfo{
    NSInteger type = [[userInfo objectForKey:@"t"] integerValue];
    //限行推送
    if (type == 1) {
        MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
        UIViewController *visableController = nil;
        if (drawerController.openSide == MMDrawerSideLeft) {
            UIViewController *temp = drawerController.leftDrawerViewController;
            while (temp != nil) {
                if ([temp isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *navi = (UINavigationController*)temp;
                    temp = [[navi viewControllers] objectAtIndex:navi.viewControllers.count - 1];
                }
                visableController = temp;
                temp = temp.presentedViewController;
            }
        } else {
            UIViewController *temp = drawerController.centerViewController;
            while (temp != nil) {
                if ([temp isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *navi = (UINavigationController*)temp;
                    temp = [[navi viewControllers] objectAtIndex:navi.viewControllers.count - 1];
                }
                visableController = temp;
                temp = temp.presentedViewController;
            }
        }
        if (visableController) {
            NSString *cityID = [userInfo objectForKey:@"ext"];
            cityID = [cityID stringByReplacingOccurrencesOfString:@"cityid:" withString:@""];
            LimitNumViewController *limitView = [[LimitNumViewController alloc] init];
            limitView.cityId = cityID.intValue;
            if (limitView.cityId == 0) {
                limitView.cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
            }
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:limitView];
            [visableController presentViewController:navi animated:YES completion:nil];
        }
    } else {
        NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
        NSString *cityName = nil;
        if (cityId > 0) {
            cityName = [AreaDBManager getCityByCityId:cityId].name;
        }
        [MobClick event:@"pushmsg_wz_receive" label:cityName];
        
        NSString *info = [userInfo objectForKey:@"ext"];
        NSArray *array = [info componentsSeparatedByString:@","];
        NSMutableDictionary *infodic = [NSMutableDictionary dictionary];
        for (NSString *str in array) {
            NSArray *pair = [str componentsSeparatedByString:@":"];
            if (pair.count == 2) {
                [infodic setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
            }
        }
        //跳转首页
        if ([[infodic objectForKey:@"return_home"] integerValue] == 1) {
            MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
            if (drawerController.openSide == MMDrawerSideLeft) {
                UIViewController *temp = drawerController.leftDrawerViewController;
                [temp dismissModalViewControllerAnimated:YES];
                [drawerController closeDrawerAnimated:NO completion:nil];
            } else {
                UIViewController *temp = drawerController.centerViewController;
                [temp dismissModalViewControllerAnimated:YES];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_PushMsgReceived object:[NSNumber numberWithBool:YES]];
        } else {//跳转违章记录页
            MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
            UIViewController *visableController = nil;
            if (drawerController.openSide == MMDrawerSideLeft) {
                UIViewController *temp = drawerController.leftDrawerViewController;
                while (temp != nil) {
                    if ([temp isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *navi = (UINavigationController*)temp;
                        temp = [[navi viewControllers] objectAtIndex:navi.viewControllers.count - 1];
                    }
                    visableController = temp;
                    temp = temp.presentedViewController;
                }
            } else {
                UIViewController *temp = drawerController.centerViewController;
                while (temp != nil) {
                    if ([temp isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *navi = (UINavigationController*)temp;
                        temp = [[navi viewControllers] objectAtIndex:navi.viewControllers.count - 1];
                    }
                    visableController = temp;
                    temp = temp.presentedViewController;
                }
            }
            if (visableController) {
                NSInteger carId = [[infodic objectForKey:@"vehicle_id"] integerValue];
                CarInfo *carM = nil;
                for (CarInfo *car in [CarInfo globCarInfo]) {
                    if ([car.carid integerValue] == carId) {
                        carM = car;
                        break;
                    }
                }
                if (carM) {
                    RecordListViewController *listView = [[RecordListViewController alloc] init];
                    listView.carInfo = carM;
                    listView.fromPush = YES;
                    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:listView];
                    [visableController presentViewController:navi animated:YES completion:nil];
                }
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    enterForegroundTime = [NSDate date];
    //后台切换前台，请求配置接口，距离上次请求少于30分钟，则从缓存读取
    if (self.appInfo == nil) {
        self.appInfo = [[GetAppInfoService alloc] init];
        self.appInfo.delegate = self;
    }
    [self.appInfo getAppInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return [TencentOAuth HandleOpenURL:url];
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(TRAppDelegate *) appDelegate{
    return (TRAppDelegate *)[UIApplication sharedApplication].delegate;
}

+(MMDrawerController *)mmDrawerController{
    TRAppDelegate *appdelegate = [TRAppDelegate appDelegate];
    if ([appdelegate.window.rootViewController isKindOfClass:[MMDrawerController class]]) {
        return (MMDrawerController*)appdelegate.window.rootViewController;
    } else {
        return nil;
    }
}

@end
