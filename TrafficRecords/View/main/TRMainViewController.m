//
//  TRViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-8-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRMainViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "Area.h"
#import "AreaDBManager.h"
#import "WeatherCell.h"
#import "WeatherService.h"
#import "JSON.h"
#import "LimitNumManager.h"
#import "CarInfo.h"
#import "TrafficRecord.h"
#import "AddCarViewController.h"
#import "AuthCodeDefenceViewController.h"
#import "TRNotifyView.h"
#import "UINavigationController+ViewAnimation.h"
#import "CarViewCell.h"
#import "RecordListViewController.h"
#import "TRAutherAlertView.h"
#import "AHToastView2.h"
#import "LimitNumViewController.h"
#import "LuKuangViewController.h" //高德地图路况
#import "TRWebViewController.h"
#import "ActivityViewController.h"
#import <iAd/iAd.h>
#import "AreaRoundViewController.h"
#import "GaoFadiViewController.h"

@interface TRMainViewController ()

@end

@implementation TRMainViewController

@synthesize myTableView;

-(NSString *) naviTitle{
    return @"违章查询";
}

-(NSString *) naviLeftIcon{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:KSettingBeClicked] == NO) {
        return @"setting_new.png";
    }
    return @"setting.png";
}

-(NSString *) naviRightIcon{
    return @"addCar.png";
}

-(void) naviLeftClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:KSettingBeClicked] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KSettingBeClicked];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self initNavigation];
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) naviRightClick:(UIButton *)sender{
    AddCarViewController *addCar = [[AddCarViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)initWeatherData:(int)cityId
{
    NSString * str = [TRUtility readcontentFromFile:@"LastWeatherInfo.json"];
    NSDictionary *json = [str JSONValue];
//    NSArray *items = [json objectForKey:@"result"];
    NSDictionary *dic = [json objectForKey:@"result"];
    NSArray *items = [dic objectForKey:@"items"];
    //构造无网络数据时天气数据
    if (items.count > 0) {
        NSDictionary *dic = [items objectAtIndex:0];
        weatherModule = [[WeatherModule alloc] init];        
        weatherModule.dateIndex = [[dic objectForKey:@"index"] intValue];
        weatherModule.date = [dic objectForKey:@"date"];
        weatherModule.weatherType = [[dic objectForKey:@"weathertype"] intValue];
        weatherModule.weatherText = [dic objectForKey:@"weathertext"];
        weatherModule.lowTemper = [[dic objectForKey:@"lowtemperature"] intValue];
        weatherModule.highTemper = [[dic objectForKey:@"hightemperature"] intValue];
        weatherModule.air = [[dic objectForKey:@"air"] intValue];
        weatherModule.airText = [dic objectForKey:@"airtext"];
        weatherModule.xicheZhishu = [dic objectForKey:@"xiche"];
    } else {
        weatherModule = [[WeatherModule alloc] init];
        weatherModule.weatherType = EWeatherDuoyun;
        weatherModule.lowTemper = 18;
        weatherModule.highTemper = 25;
        weatherModule.weatherText = @"多云转小雨";
        weatherModule.xicheZhishu = @"不适宜洗车";
        weatherModule.air = 87;
        weatherModule.date = [TRUtility dateToString:[NSDate date]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    recordLoaded = YES;
    weatherLoaded = YES;
    hiddenDic = [NSMutableDictionary dictionary];
    NSArray *array = [CarInfo globCarInfo];
    for (int i = 0; i < array.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        if (array.count > 1) {
            [hiddenDic setObject:[NSNumber numberWithBool:YES] forKey:key];
        } else {
            [hiddenDic setObject:[NSNumber numberWithBool:NO] forKey:key];
        }
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId <= 0) {
        currentCity = [AreaDBManager getCityByKeyWord:@"北京"];
    } else {
        currentCity = [AreaDBManager getCityByCityId:cityId];
    }
    itemCount = 4;
//    if (weatherModule.air == -1) {//不支持pm2.5
//        itemCount--;
//    }
    LimitCityInfo *cityInfo = [LimitNumManager cityInfo:currentCity.cityId];
    if (cityInfo == nil) { //不支持限行
        itemCount--;
    }
    LuKuangCity *lukuang = [LuKuangCity getLuKuangCityById:currentCity.cityId];
    if (!lukuang.supportLuKuang) {//不支持路况
        itemCount--;
    }
    
    
    CGRect frame = self.view.bounds;
    float hiddenH = KHiddenHeight;
    if (frame.size.height > 480) {
        hiddenH -= 30;
    }
    frame.origin.y = KDefaultStartY - hiddenH;
    frame.size.height -= (KHeightReduce - hiddenH);
    self.myTableView = [[FMMoveTableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    myTableView.topHiddenH = hiddenH;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myScrollView = myTableView;
    
    

    WeatherCell *cell = [WeatherCell loadFromXib];
    [cell.cityBtn addTarget:self action:@selector(CityClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.xianXingBg addTarget:self action:@selector(limitNumClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.themeImageView setTop:hiddenH * KCompressFloat];
    if (self.view.height > 480) {
        float reduce = 23;
        [cell.weatherIcon setTop:cell.weatherIcon.top - reduce];
        [cell.weatherLabel setTop:cell.weatherLabel.top - reduce];
        [cell.xiCheLabel setTop:cell.xiCheLabel.top - reduce];
        [cell.temLabel setTop:cell.temLabel.top - reduce];
        [cell.pmBg setTop:cell.pmBg.top - reduce];
        [cell.pmIcon setTop:cell.pmIcon.top - reduce];
        [cell.pmLabel setTop:cell.pmLabel.top - reduce];
    }
    myTableView.tableHeaderView = cell;
    
    
    
    service = [[WeatherService alloc] init];
    service.delegate = self;
    recordService = [[QueryTrafRecordService alloc] init];
    recordService.delegate = self;
    [self initWeatherData:(int)cityId];
    
    [self updateWheatherView];
    [self updateNoDataViews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KLimitNumsTimestamp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_CarChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KThemeImageChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_HaveActivity object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_PushMsgReceived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_GetAppInfo object:nil];
    //刷新天气
    donotLoadRecord = YES;
    [self autoRefresh];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl] length] > 0 && ![[[NSUserDefaults standardUserDefaults] objectForKey:KActivityTimestamp] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KActivityTimestamp2]]) {
        [self showActivityView];
    } else {
        [self hiddenActivityView];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:KMainViewGuidShow] == NO &&  [CarInfo globCarInfo].count > 0) {
        [self showGuidView];
    }
}

-(void) showGuidView{
    UIView *bgview = [[UIView alloc] initWithFrame:[TRAppDelegate appDelegate].window.bounds];
    bgview.backgroundColor = [TRSkinManager colorWithInt:0x66000000];
    [[TRAppDelegate appDelegate].window addSubview:bgview];
    bgview.tag = 3444;
    
    UIImage *image = TRImage(@"guid1.png");
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(bgview.width/2 - image.size.width/2, 160, image.size.width, image.size.height)];
    imagView.image = image;
    [bgview addSubview:imagView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeGuidView)];
    [bgview addGestureRecognizer:tap];
}

-(void) closeGuidView{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KMainViewGuidShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIView *bgview = [[TRAppDelegate appDelegate].window  viewWithTag:3444];
    [bgview removeFromSuperview];
}


-(void) limitNumClicked:(id) sender{
    [MobClick event:@"limiticon_click"];
    LimitNumViewController *limitView = [[LimitNumViewController alloc] init];
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId <= 0) {
        cityId = [AreaDBManager getCityByKeyWord:@"北京"].cityId;
    }
    limitView.cityId = cityId;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:limitView];
    [self presentModalViewController:navi animated:YES];
}

-(void) areaRoundClicked:(id) sender{
    AreaRoundViewController *areaRoundViewController = [[AreaRoundViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:areaRoundViewController];
    [self presentModalViewController:navi animated:YES];
}

-(void) gaofadiClicked:(id) sender{
    [MobClick event:@"gaofidi_icon_click"];
    GaoFadiViewController *gaofadiViewController = [[GaoFadiViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gaofadiViewController];
    [self presentModalViewController:navi animated:YES];
}

-(void) updateNoDataViews{
    if ([CarInfo globCarInfo].count > 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        self.myTableView.backgroundView = view;
//        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(28, 0, 2,view.height)];
//        view2.backgroundColor = [TRSkinManager colorWithInt:0xe6e6e6];
//        view2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [view addSubview:view2];
//        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, - myTableView.height, myTableView.width, myTableView.height)];
//        view3.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
//        [self.myTableView addSubview:view3];
        
        myTableView.tableFooterView = nil;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        self.myTableView.backgroundView = view;
        
        UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.width, 180)];
        bgview.backgroundColor = [UIColor clearColor];
        self.myTableView.tableFooterView = bgview;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = TRImage(@"dashedBox.png");
        btn.frame = CGRectMake(myTableView.width/2 - image.size.width/2, 12, image.size.width, image.size.height);
        [btn setBackgroundImage:TRImage(@"dashedBox.png") forState:UIControlStateNormal];
        [btn setBackgroundImage:TRImage(@"dashedBoxHL.png") forState:UIControlStateHighlighted];
//        [btn setTitle:@"点击添加车辆" forState:UIControlStateNormal];
        [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btn];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.bottom + 4, myTableView.width, 24)];
        label.font = [TRSkinManager smallFont1];
        label.text = @"点击添加车辆";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x999999];
        label.textAlignment = NSTextAlignmentCenter;
        [bgview addSubview:label];
    }
}

-(void) updateWheatherView{
    WeatherCell *cell = (WeatherCell *)myTableView.tableHeaderView;
    [cell.cityBtn setTitle:currentCity.name forState:UIControlStateNormal];
    UIImage * image = weatherModule.weatherIcon;
    [cell.weatherIcon setTop:cell.weatherIcon.top + cell.weatherIcon.height/2 - image.size.height/2];
    [cell.weatherIcon setImage: image];
    [cell.weatherIcon setWidth:image.size.width];
    [cell.weatherIcon setHeight:image.size.height];
    [cell.weatherLabel setLeft:cell.weatherIcon.right + 6];
    cell.weatherLabel.text = weatherModule.weatherText;
    cell.temLabel.text = [NSString stringWithFormat:@"%d°~%d°", weatherModule.lowTemper, weatherModule.highTemper];
    cell.xiCheLabel.text = weatherModule.xicheZhishu;
    cell.pmLabel.text = [NSString stringWithFormat:@"%d", weatherModule.air];
    if (weatherModule.air >= 200) {
        cell.pmIcon.image = TRImage(@"pmHigh.png");
    } else {
        cell.pmIcon.image = TRImage(@"pmLow.png");
    }
    if (weatherModule.air == -1) {
        cell.pmBg.hidden = YES;
        cell.pmIcon.hidden = YES;
        cell.pmLabel.hidden = YES;
    } else {
        cell.pmBg.hidden = NO;
        cell.pmIcon.hidden = NO;
        cell.pmLabel.hidden = NO;
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId == 0) {
        cityId = 110100;//北京
    }
    NSString *limitText = [LimitNumManager getLimitNumByCity:(int)cityId];

    if (limitText == nil) {
        cell.xianXingBg.hidden = YES;
        cell.xianXingLabel.hidden = YES;
        cell.xianXingSplitLine.hidden = YES;
        [cell.dateLabel setRight:cell.xianXingBg.right];
    } else {
        cell.xianXingBg.hidden = NO;
        cell.xianXingLabel.hidden = NO;
        cell.xianXingSplitLine.hidden = NO;
        [cell.dateLabel setRight:cell.xianXingBg.left - 8];
        
        cell.xianXingLabel.text = limitText;
        if ([limitText isEqualToString:@"不限行"] || limitText.length == 1 || limitText.length == 2) {
            cell.xianXingSplitLine.hidden = YES;
            if ([limitText isEqualToString:@"不限行"] || limitText.length == 2) {
                [cell.xianXingLabel setFont:[UIFont systemFontOfSize:11]];
            } else {
                [cell.xianXingLabel setFont:[UIFont systemFontOfSize:16]];
            }
        } else {
            cell.xianXingSplitLine.hidden = NO;
            [cell.xianXingLabel setFont:[UIFont systemFontOfSize:16]];
        }
    }
    cell.dateLabel.text = [LimitNumManager getTodayDateWeek];
}

-(void) openLukuang{

    LuKuangViewController * lukuang = [[LuKuangViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lukuang];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    visable = YES;
    if (kSystemVersion >= 7.0) {
        self.navigationController.navigationBar.barTintColor = [self naviColor];
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId <= 0) {
        [self startLocaltion];
    }
}

- (void) notifyMessage:(NSNotification *) msg{
    if ([msg.name isEqualToString:KLimitNumsTimestamp]) {
        [LimitNumManager resetGlobObject];
        itemCount = 4;
//        if (weatherModule.air == -1) {//不支持pm2.5
//            itemCount--;
//        }
        LimitCityInfo *cityInfo = [LimitNumManager cityInfo:currentCity.cityId];
        if (cityInfo == nil) { //不支持限行
            itemCount--;
        }
        LuKuangCity *lukuang = [LuKuangCity getLuKuangCityById:currentCity.cityId];
        if (!lukuang.supportLuKuang) {//不支持路况
            itemCount--;
        }
        [myTableView reloadData];
        [self updateWheatherView];
    } else if([msg.name isEqualToString:KNotification_CarChanged]) {
        [self updateNoDataViews];
        //需要刷新 
        if (msg.object && [msg.object boolValue]) {
            [myTableView reloadData];
            [self autoRefresh];
        } else {
            //将数据刷新到UI
            [myTableView reloadData];
        }
    } else if([msg.name isEqualToString:KThemeImageChanged]){
        WeatherCell *cell = (WeatherCell *)myTableView.tableHeaderView;
        NSString *lastUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KThemeImageChanged];
        if (lastUrl.length > 0) {
            [cell.themeImageView setImageWithURL:[NSURL URLWithString:lastUrl] placeholderImage:cell.themeImageView.image];
        }
    } else if([msg.name isEqualToString:KNotification_HaveActivity] && msg.object){
        GetAppInfoService *appinfo = msg.object;
        NSString *localTimeStame = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityTimestamp];
        if (![appinfo.activityTimestamp isEqualToString:localTimeStame]  && appinfo.activityUrl.length > 0) {
            [self showActivityView];
        } else {
            [self hiddenActivityView];
        }
    } else if([msg.name isEqualToString:KNotification_PushMsgReceived]){
        if (isReloading) {
            //如果仅选择城市，则不刷新违章记录
            NSArray *array = [CarInfo globCarInfo];
            if (recordService) {
                recordLoaded = NO;
                [recordService queryTrafRecordFromPush:array];
            }
        } else {
            fromPush = YES;
            donotLoadRecord = NO;
            [self autoRefresh];
        }
    } else if([msg.name isEqualToString:KNotification_GetAppInfo]){
        if ([TRAppDelegate appDelegate].appInfo.showScore == NO &&
            [TRAppDelegate appDelegate].appInfo.showAdView == YES) {
            if (adBanner == nil) {
                ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
                adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
                // 在父窗口下方表示
                adView.frame = CGRectMake(0, self.view.height - adView.height, self.view.width, adView.height);
                [self.view addSubview:adView];
                adBanner = adView;
            }
        }
    }
}

- (void)openActivityView:(UIGestureRecognizer*)gestureRecognizer {
    ActivityViewController *webView = [[ActivityViewController alloc] init];
    NSString *unAddedUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
    
    NSRange range = [unAddedUrl rangeOfString:@"?"];
    NSString *newUrl = nil;
    if (range.length == 0) {
        newUrl = [NSString stringWithFormat:@"%@?qd=%@&extend=%d&t=%d", unAddedUrl, KChannelId, [CarInfo globCarInfo].count, (int)[[NSDate date] timeIntervalSince1970]];
    } else {
        if ([unAddedUrl characterAtIndex:unAddedUrl.length -1] == '?') {
            newUrl = [NSString stringWithFormat:@"%@qd=%@&extend=%d&t=%d", unAddedUrl, KChannelId, [CarInfo globCarInfo].count, (int)[[NSDate date] timeIntervalSince1970]];
        } else {
            newUrl = [NSString stringWithFormat:@"%@&qd=%@&extend=%d&t=%d", unAddedUrl, KChannelId, [CarInfo globCarInfo].count, (int)[[NSDate date] timeIntervalSince1970]];
        }
    }
    webView.url = newUrl;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void) showActivityView{
    if (bannerView == nil) {
        UIImage *image = TRImage(@"banner.png");
        UrlImageView *imageView = [[UrlImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, image.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:KActivityImgUrl]] placeholderImage:image];
        bannerView = imageView;
        [self.view addSubview:bannerView];
        bannerView.hidden = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openActivityView:)];
        [imageView addGestureRecognizer:tap];
        
        UIImage *bg = TRImage(@"chazi.png");
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:bg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hiddenActivityView) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(imageView.width - 8 - 30, 8, 30, 30);
        [imageView addSubview:btn];
    }
    if (bannerView.hidden) {
        CGRect rect1 = headView.initRect;
        CGRect rect2 = self.myTableView.frame;
        rect1.origin.y += bannerView.height;
        rect2.origin.y += bannerView.height;
        rect2.size.height -= bannerView.height;
        [headView setInitRect:rect1];
        [self.myTableView setFrame:rect2];
        bannerView.hidden = NO;
    }
}

-(void) hiddenActivityView{
    if (bannerView && bannerView.hidden == NO) {
        CGRect rect1 = headView.initRect;
        CGRect rect2 = self.myTableView.frame;
        rect1.origin.y -= bannerView.height;
        rect2.origin.y -= bannerView.height;
        rect2.size.height += bannerView.height;
        [headView setInitRect:rect1];
        [self.myTableView setFrame:rect2];
        bannerView.hidden = YES;
        NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityTimestamp2];
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:KActivityTimestamp];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    visable = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark AreaDelegate Methods

-(void) selectedCitys:(NSArray *)array{
    if (array.count > 0) {
        City *city = [array objectAtIndex:0];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger cityId = [defaults integerForKey:KCurrentCityId];
        [MobClick event:@"city_change" label:city.name];
        if (city.cityId == cityId) {
            return;
        }
        [defaults setInteger:city.cityId forKey:KCurrentCityId];
        [defaults synchronize];
        
        currentCity = city;
        itemCount = 4;
//        if (weatherModule.air == -1) {//不支持pm2.5
//            itemCount--;
//        }
        LimitCityInfo *cityInfo = [LimitNumManager cityInfo:currentCity.cityId];
        if (cityInfo == nil) { //不支持限行
            itemCount--;
        }
        LuKuangCity *lukuang = [LuKuangCity getLuKuangCityById:currentCity.cityId];
        if (!lukuang.supportLuKuang) {//不支持路况
            itemCount--;
        }
        [self.myTableView reloadData];
        
        [self updateWheatherView];
        donotLoadRecord = YES;
        [self autoRefresh];
        [[TRAppDelegate appDelegate] sendToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CityChanged object:nil];
    }
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
//下拉刷新加载数据
-(void) loadData {
    [super loadData];
    if (service) {
        NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
        if (cityId == 0) {
            cityId = 110100;//北京
        }
        [service getWeatherInfo:(int)cityId];
        weatherLoaded = NO;
    }
    //如果仅选择城市，则不刷新违章记录
    NSArray *array = [CarInfo globCarInfo];
    if (recordService && !donotLoadRecord) {
        recordLoaded = NO;
        if (fromPush) {
            fromPush = NO;
            [recordService queryTrafRecordFromPush:array];
        } else {
            [recordService queryTrafRecord:array];
        }
        if (array.count > 0) {
            [MobClick event:@"nall_car_refesh" label:[NSString stringWithFormat:@"%lu", (unsigned long)array.count]];
        }
        int cityCount = 0;
        for (CarInfo * carM in array) {
            cityCount += carM.citys.count;
        }
        if (cityCount > 0) {
            [MobClick event:@"nall_car_refesh_city" label:[NSString stringWithFormat:@"%d", cityCount]];
        }
    }
    if (weatherLoaded && recordLoaded) {
        [self doneLoadData];
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceGetWeather) {
        NSDictionary *dic = service.responseDic;
        NSString * json = [dic JSONRepresentation];
        [TRUtility writecontent:json toFile:@"LastWeatherInfo.json"];
        for (WeatherModule * module in [service weatherArray]) {
            if (module.dateIndex == 0) {
                weatherModule = module;
                [self updateWheatherView];
            }
        }
        weatherLoaded = YES;
    } else if(EServiceGetTrafficRecord == tag){
        recordLoaded = YES;
        [myTableView reloadData];
        [self updateNoDataViews];
    }
    if (weatherLoaded && recordLoaded) {
        [self doneLoadData];
        
        int weizhangCount = 0;
        int authCount = 0;
        NSString *authCarId = nil;
        NSString *authCityId = nil;
        NSString *carName = nil;
        UIImage *authImage = nil;
        NSString *authInfo = nil;
        NSString *statusMsg = nil;
        for (CarInfo *carM in [CarInfo globCarInfo]) {
            weizhangCount += carM.totalNew;
            if (carM.status != 0 && statusMsg == nil) {
                if (carM.statusMsg.length > 0) {
                    statusMsg = [NSString stringWithFormat:@"%@:%@",carM.carnumber ,carM.statusMsg];
                } else{
                    statusMsg = [NSString stringWithFormat:@"因交管系统变更查询要求，您的牌照为%@的车辆信息需要更新",carM.carnumber];
                }
            }
            for (CityOfCar *cityM in carM.citys) {
                if (cityM.authurl.length > 0) {
                    authCount ++;
                    authCarId = carM.carid;
                    authCityId = cityM.cityid;
                    NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                    authImage = [UIImage imageWithData:data];
                    carName = carM.carname.length > 0 ? carM.carname : carM.carnumber;
                    if (cityM.authInfoMsg.length > 0) {
                        authInfo = cityM.authInfoMsg;
                    }
                    
                }
            }
        }
        
        //没有新的违章和验证码时，提示没有新的违章记录
        if ([CarInfo globCarInfo].count > 0 && !donotLoadRecord && statusMsg.length == 0) {
            if (authCount == 0) {
                if (weizhangCount > 0) {
                    [self showInfoView:[NSString stringWithFormat:@"您有%d条新的违章！", weizhangCount]];
                } else if(weizhangCount == 0){
                    [self showInfoView:@"恭喜你，没有新的违章！"];
                }

            } else if(authCount == 1){
                TRAutherAlertView *alertView = [[TRAutherAlertView alloc] initWithImage:authImage];
                alertView.textField.delegate = self;
                alertView.carId = authCarId;
                alertView.cityId = authCityId;
                alertView.titleView.text = carName;
                alertView.textField.placeholder = authInfo;
                [alertView show];
            } else if(authCount > 1){
                AuthCodeDefenceViewController *authView = [[AuthCodeDefenceViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:authView];
                [self presentViewController:navi animated:YES completion:nil];
            }
        } else if(statusMsg.length > 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:statusMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在修改", nil];
            [alert show];
            alert.tag = 200;
        }
    }
    donotLoadRecord = NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        for (CarInfo *carM in [CarInfo globCarInfo]) {
            if (carM.status != 0) {
                AddCarViewController * addCar = [[AddCarViewController alloc] init];
                addCar.carData = carM;
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
                [self presentViewController:navi animated:YES completion:nil];
                return;
            }
        }
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (tag == EServiceGetWeather) {
        weatherLoaded = YES;
    }else if(EServiceGetTrafficRecord == tag){
        recordLoaded = YES;

    }
    donotLoadRecord = NO;
//     [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:0];
    [self doneLoadData];
}

-(void) CityClick:(id)sender{
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    City *cityM = [AreaDBManager getCityByCityId:cityId];
    CityViewController *city = [[CityViewController alloc] init];
    city.controllerType = 1;
    city.areaDelegate = self;
    if (cityM) {
        [city setSelectCitys:[NSArray arrayWithObject:cityM]];
    }
    [MobClick event:@"city_change_click"];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:city];
    [self presentViewController:navi animated:YES completion:nil];
}


#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = [CarInfo globCarInfo].count;
    if (itemCount >= 2) {
        count++;
    }
    
    //2.2.0 FMMoveTableView新增
    // 1. A row is in a moving state
	// 2. The moving row is not in it's initial section
	if (tableView.movingIndexPath && tableView.movingIndexPath.section != tableView.initialIndexPathForMovingRow.section)
	{
		if (section == tableView.movingIndexPath.section) {
			count++;
		}
		else if (section == tableView.initialIndexPathForMovingRow.section) {
			count--;
		}
	}
    
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (itemCount >= 2 && indexPath.row == 0) {
        return 92;
    }
    return 105;
}

- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (itemCount >= 2 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        height -= 5;
        float lineH = [TRUtility lineHeight];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - lineH, tableView.width, lineH)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
        [cell.contentView addSubview:line];
        float itemW = tableView.width / itemCount;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, tableView.width, 5)];
        view.backgroundColor = [TRSkinManager bgColorLight];
        [cell.contentView addSubview:view];
        
        //添加分割线
        for (int i = 1; i < itemCount; i++) {
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(itemW * i, 0 , lineH, height)];
            line2.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
            
            [cell.contentView addSubview:line2];
        }
        int index = 0;
        LimitCityInfo *cityInfo = [LimitNumManager cityInfo:currentCity.cityId];
        LuKuangCity *lukuang = [LuKuangCity getLuKuangCityById:currentCity.cityId];
        
        if (YES) {
            CGRect rect = CGRectMake(itemW * index, 0, itemW, height);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager selectBgColor]] forState:UIControlStateHighlighted];
            //            [btn addTarget:self action:@selector(limitNumClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:TRImage(@"gaofadi.png")];
            imageView.frame = CGRectMake(btn.width/2 - imageView.width/2, 12, imageView.width, imageView.height);
            [btn addSubview:imageView];
            [btn setTitle:@"违章高发地" forState:UIControlStateNormal];
            [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [btn addTarget:self action:@selector(gaofadiClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:btn];
            index++;
        }
        
        if (lukuang.supportLuKuang) {//支持实时路况
            CGRect rect = CGRectMake(itemW * index, 0, itemW, height);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager selectBgColor]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(openLukuang) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:TRImage(@"lkItem.png")];
            imageView.frame = CGRectMake(btn.width/2 - imageView.width/2, 12, imageView.width, imageView.height);
            [btn addSubview:imageView];
            [btn setTitle:@"实时路况" forState:UIControlStateNormal];
            [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:btn];
            index++;
        }
        if (cityInfo != nil) { //支持限行
            CGRect rect = CGRectMake(itemW * index, 0, itemW, height);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager selectBgColor]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(limitNumClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:TRImage(@"limitItem.png")];
            imageView.frame = CGRectMake(btn.width/2 - imageView.width/2, 12, imageView.width, imageView.height);
            [btn addSubview:imageView];
            [btn setTitle:@"限行通知" forState:UIControlStateNormal];
            [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:btn];
            index++;
        }
        if (YES) {
            CGRect rect = CGRectMake(itemW * index, 0, itemW, height);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager selectBgColor]] forState:UIControlStateHighlighted];
            //            [btn addTarget:self action:@selector(limitNumClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:TRImage(@"AreaService.png")];
            imageView.frame = CGRectMake(btn.width/2 - imageView.width/2, 12, imageView.width, imageView.height);
            [btn addSubview:imageView];
            [btn setTitle:@"周边服务" forState:UIControlStateNormal];
            [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [btn addTarget:self action:@selector(areaRoundClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:btn];
            index++;
        }
        return cell;
    } else {
        CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarViewCell"];
        if (cell == nil) {
            cell = [CarViewCell loadFromXib];
        }
        if ([tableView indexPathIsMovingIndexPath:indexPath])
        {
            [cell prepareForMove];
        } else {
            [cell recoverFromMove];
            if (tableView.movingIndexPath != nil) {
                indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
            }
            NSUInteger index = indexPath.row;
            if (itemCount >= 2 ) {
                index--;
            }
            CarInfo *carM = [[CarInfo globCarInfo] objectAtIndex:index];
            [cell.brandImageView setImageWithURL:[NSURL URLWithString:carM.brandImageUrl] placeholderImage:TRImage(@"brandHolder.png")];
            cell.nameLabel.text = carM.carname.length > 0 ? carM.carname : carM.carnumber;
            cell.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)carM.trafficRecods.count];
            [cell.countLabel setWidth:[cell.countLabel.text sizeWithFont:cell.countLabel.font constrainedToSize:CGSizeMake(9999, 24)].width];
            [cell.ciLabel setLeft:cell.countLabel.right + 2];
            if (carM.unknownMoney) {
                cell.moneyLabel.text = @"未知";
            } else {
                cell.moneyLabel.text = [NSString stringWithFormat:@"-%ld",(long)carM.totalMoney];
            }
            if (carM.unknownScore) {
                cell.scoreLabel.text = @"未知";
            } else {
                cell.scoreLabel.text = [NSString stringWithFormat:@"-%ld",(long)carM.totalScore];
            }
            UIImage *bgImage = nil;
            if (carM.totalNew > 0) {
                bgImage = [TRImage(@"red.png") stretchableImageWithLeftCapWidth:23 topCapHeight:11];
                [cell.countflagLabel setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
            } else {
                bgImage = [TRImage(@"gray.png") stretchableImageWithLeftCapWidth:23 topCapHeight:11];
                [cell.countflagLabel setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
            }
            [cell.countflagLabel setBackgroundImage:bgImage forState:UIControlStateNormal];
            
            NSString *text = [NSString stringWithFormat:@"%ld",(long)carM.totalNew];
            float width = 44;
            float left = 256;
            if (text.length > 1) {
                width += (text.length - 1) * 6;
                left -= (text.length - 1) * 6;
            }
            [cell.countflagLabel setLeft:left];
            [cell.countflagLabel setWidth:width];
            [cell.countflagLabel setTitle:text forState:UIControlStateNormal];
            cell.notLeabel.text = @"未处理违章";
            cell.moneyImageView.image = TRImage(@"money.png");
            cell.scoreImageView.image = TRImage(@"score.png");
            
            cell.shouldIndentWhileEditing = NO;
            cell.showsReorderControl = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        return;
    }
    NSInteger index = indexPath.row ;
    if (itemCount >= 2) {
        index--;
    }
    CarInfo *carM = [[CarInfo globCarInfo] objectAtIndex:index];
    RecordListViewController *listView = [[RecordListViewController alloc] init];
    listView.carInfo = carM;
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:listView];
    [self presentViewController:navi animated:YES completion:nil];
    
   
}

- (BOOL)moveTableView:(FMMoveTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (itemCount >= 2 && indexPath.row == 0) {
        return NO;
    }
	return YES;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [MobClick event:@"carindex_changed"];
    NSMutableArray *cars = [CarInfo globCarInfo];
    NSInteger fromIndex = fromIndexPath.row ;
    NSInteger toIndex = toIndexPath.row ;
    if (itemCount >= 2) {
        fromIndex--;
        toIndex--;
    }
    NSLog(@"fromIndex = %d,toIndex =%d",fromIndex,toIndex);
    CarInfo *obj = [cars objectAtIndex:fromIndex];
    [cars removeObjectAtIndex:fromIndex];
    if (toIndex >= cars.count) {
        [cars addObject:obj];
    } else {
        [cars insertObject:obj atIndex:toIndex];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int sortIndex = 0;
        for (CarInfo *car in [CarInfo globCarInfo]) {
            car.sortIndex = sortIndex;
            sortIndex++;
            [CarInfo updateCarSortIndex:car];
        }
    });
}

- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (itemCount >= 2 && proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }
	return proposedDestinationIndexPath;
}



#pragma mark -
#pragma mark CLLocationManager代理
- (void)startLocaltion
{
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    [locationMgr startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [locationMgr stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    if (geoCoder == nil)
    {
        geoCoder = [[CLGeocoder alloc] init];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSDictionary *dic = placemark.addressDictionary;
            NSString *city = [dic objectForKey:@"City"];
            if (city.length == 0) {
                city = placemark.administrativeArea;
            }
            city = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            City * cityM = [AreaDBManager getCityByKeyWord:city];
            if (cityM) {
                [MobClick event:@"gps_city" label:cityM.name];
                [self selectedCitys:[NSArray arrayWithObject:cityM]];
            } else {
                [self handleLocationFailed];
            }
        } else {
            [self handleLocationFailed];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self handleLocationFailed];
}

- (void)handleLocationFailed{

}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    WeatherCell *cell = (WeatherCell *)myTableView.tableHeaderView;
    CGRect frame = self.view.bounds;
    float hiddenH = KHiddenHeight;
    if (frame.size.height > 480) {
        hiddenH -= 30;
    }
    if (scrollView.contentOffset.y >= -hiddenH && scrollView.contentOffset.y <= 0) {
        [cell.themeImageView setTop:hiddenH * KCompressFloat + scrollView.contentOffset.y * KCompressFloat];
    } else if(scrollView.contentOffset.y < -hiddenH){
        [cell.themeImageView setTop:0];
    } 
}
@end
