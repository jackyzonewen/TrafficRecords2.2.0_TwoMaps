//
//  RecordListViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-11-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "RecordListViewController.h"
#import "TRCarCell.h"
#import "BrandManager.h"
#import "TrafficRecordCell.h"
#import "TrafficRecord.h"
#import "TRDetailViewController2.h"
#import "CityOfCar.h"
#import "AuthCodeDefenceViewController.h"
#import "TRMainViewController.h"
#import "TRAutherAlertView.h"
#import "AddCarViewController.h"
#import "TRWebViewController.h"
#import "AddressPickViewController.h"

#define KBGViewTag ((int) 9100)

@interface RecordListViewController ()

@end

@implementation RecordListViewController

@synthesize myTableView;
@synthesize carInfo;
@synthesize fromPush;

-(NSString *) naviTitle{
    return @"违章记录";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) naviRightIcon{
    return @"infoIcon.png";
}

-(void)tapGestureCallback1:(UITapGestureRecognizer *)tapGesture{
    [self changeInfoViewState];
}

-(void) infoViewClick1{
    [MobClick event:@"wzdeal_address_click"];
    AddressPickViewController *pickView = [[AddressPickViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pickView];
    [self presentViewController:navi animated:YES completion:nil];
    [self changeInfoViewState];
}

-(void) infoViewClick2{
    [MobClick event:@"wedeal_mustkonw_click"];
    TRWebViewController *webView = [[TRWebViewController alloc] init];
    webView.url = [NSString stringWithFormat:@"%@wz_info.html", KServerHost];
    webView.title = @"违章处理须知";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navi animated:YES completion:nil];
    [self changeInfoViewState];
}


-(void) naviRightClick:(id)sender{
    [MobClick event:@"recordlist_righticon_click"];
    UIButton *btn =  (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    UIView *remindView = [btn viewWithTag:100];
    if (remindView) {
        [remindView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"notReadRemindCount"];
//        [[NSUserDefaults standardUserDefaults] integerForKey:@"notReadRemindCount"]
    }
    if (infoView == nil) {
        infoView = [UIButton buttonWithType:UIButtonTypeCustom];
        infoView.frame = CGRectMake(0, KDefaultStartY, self.view.width, self.view.height);
        [(UIButton*)infoView addTarget:self action:@selector(tapGestureCallback1:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:infoView];
//        infoView = [[UIView alloc] initWithFrame:CGRectMake(0, KDefaultStartY + redline.height, self.view.width, self.view.height - redline.height)];
//        infoView.backgroundColor = [TRSkinManager colorWithInt:0x88000000];
//        [self.view addSubview:infoView];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback1:)];
//        [infoView addGestureRecognizer:tap];
        float lineH = [TRUtility lineHeight];
        float height = 49*2 + lineH;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -height, self.view.width, height)];
        bgView.backgroundColor = [TRSkinManager colorWithInt:0xebebeb];
        bgView.tag = KBGViewTag;
        [infoView addSubview:bgView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(37, 49, self.view.width - 37, lineH)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
        [bgView addSubview:line];
        
        UIImage *rArrow = TRImage(@"adressIcon.png");
        UIImageView *lefticon = [[UIImageView alloc] initWithImage:rArrow];
        lefticon.frame = CGRectMake(12, 49.0/2 - rArrow.size.height/2, rArrow.size.width, rArrow.size.height);
        [bgView addSubview:lefticon];
        rArrow = TRImage(@"zxIcon.png");
        lefticon = [[UIImageView alloc] initWithImage:rArrow];
        lefticon.frame = CGRectMake(12, 49 + lineH + 49.0/2 - rArrow.size.height/2, rArrow.size.width, rArrow.size.height);
        [bgView addSubview:lefticon];
        
        rArrow = TRImage(@"rArrow.png");
        UIImageView *icon = [[UIImageView alloc] initWithImage:rArrow];
        icon.frame = CGRectMake(bgView.width - 12 - rArrow.size.width, 49.0/2 - icon.size.height/2, icon.size.width, icon.size.height);
        [bgView addSubview:icon];
        icon = [[UIImageView alloc] initWithImage:rArrow];
        icon.frame = CGRectMake(bgView.width - 12 - rArrow.size.width, 49 + lineH + 49.0/2 - icon.size.height/2, icon.size.width, icon.size.height);
        [bgView addSubview:icon];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lefticon.width + lefticon.left + 9, 0, 260, 49)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x666666];
        label.font = [TRSkinManager mediumFont3];
        label.text = @"违章处理地址";
        [bgView addSubview:label];
        label = [[UILabel alloc] initWithFrame:CGRectMake(lefticon.width + lefticon.left + 9, 49 + lineH, 260, 49)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x666666];
        label.font = [TRSkinManager mediumFont3];
        label.text = @"违章处理须知";
        [bgView addSubview:label];
        
        UIImage *image2 = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcccccc]];
        
        UIButton *btnl = [UIButton buttonWithType:UIButtonTypeCustom];
        btnl.frame = CGRectMake(0, 0, bgView.width, bgView.height/2);
        btnl.backgroundColor = [UIColor clearColor];
        [btnl setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [btnl addTarget:self action:@selector(infoViewClick1) forControlEvents:UIControlEventTouchUpInside];
        [bgView insertSubview:btnl atIndex:0];
        
        btnl = [UIButton buttonWithType:UIButtonTypeCustom];
        btnl.frame = CGRectMake(0, bgView.height/2, bgView.width, bgView.height/2);
        btnl.backgroundColor = [UIColor clearColor];
        [btnl setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [btnl addTarget:self action:@selector(infoViewClick2) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:btnl];
        [bgView insertSubview:btnl atIndex:0];
    }
    [self changeInfoViewState];
}

-(void) changeInfoViewState
{
    if (locked) {
        [self performSelector:@selector(changeInfoViewState) withObject:nil afterDelay:0.1];
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeInfoViewState) object:nil];
    //正打开，则收起
    if (showInfoView) {
        showInfoView = !showInfoView;
        [UIView animateWithDuration:0.2 animations:^{
            UIView *bgView = [infoView viewWithTag:KBGViewTag];
            [bgView setTop:-bgView.height];
            infoView.backgroundColor = [UIColor clearColor];
            locked = YES;
        } completion:^(BOOL finshed){
            infoView.hidden = YES;
            infoView.backgroundColor = [TRSkinManager colorWithInt:0x88000000];
            UIButton *btn =  (UIButton *)self.navigationItem.rightBarButtonItem.customView;
            [btn setSelected:showInfoView];
            locked = NO;
        }];
    } else {
        showInfoView = !showInfoView;
        //正收起，则打开
        infoView.hidden = NO;
        infoView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.2 animations:^{
            UIView *bgView = [infoView viewWithTag:KBGViewTag];
            [bgView setTop:0];
            infoView.backgroundColor = [TRSkinManager colorWithInt:0x88000000];
            locked = YES;
        } completion:^(BOOL finshed){
            UIButton *btn =  (UIButton *)self.navigationItem.rightBarButtonItem.customView;
            [btn setSelected:showInfoView];
            locked = NO;
        }];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [btn addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIImage *sIcon = TRImage(@"infoIconS.png");
    UIButton *btn =  (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    int notReadRemindCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"notReadRemindCount"];
    if (notReadRemindCount < 2) {
        UIImage *num = TRImage(@"remind.png");
        CGPoint center = CGPointMake(btn.width/2 + 20/2, btn.height/2 - 19/2);
        if (kSystemVersion >= 7) {
            center.x = btn.width/2 + sIcon.size.width/2;
        }
        UIImageView * radius = [[UIImageView alloc] initWithFrame:CGRectMake(center.x - num.size.width/2, center.y - num.size.height/2, num.size.width, num.size.height)];
        radius.image = num;
        [btn addSubview:radius];
        radius.tag = 100;
        UILabel *label = [[UILabel alloc] initWithFrame:radius.bounds];
        label.text = [NSString stringWithFormat:@"%d", 2 - notReadRemindCount];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [radius addSubview:label];
    }
    [btn setImage:sIcon forState:UIControlStateSelected];
    
    CGRect frame = self.view.bounds;
    float hiddenH = KHiddenHeight;
    if (frame.size.height > 480) {
        hiddenH -= 30;
    }
    frame.origin.y = KDefaultStartY - hiddenH;
    frame.size.height -= (KHeightReduce - hiddenH);
    self.myTableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myScrollView = myTableView;
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, - myTableView.height, myTableView.width, myTableView.height)];
    view3.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
    [self.myTableView addSubview:view3];
    [self doneLoadData];
    
    TRCarCell *cell = [TRCarCell loadFromXib];
    [cell.themeImageView setTop:hiddenH *  KCompressFloat];
    cell.faqianLabel.text = [NSString stringWithFormat:@"%d", carInfo.totalMoney];
    cell.faqianLabel.textColor = [self naviColor];
    if (carInfo.unknownMoney) {
        cell.faqianLabel.text = @"未知";
    }
    cell.koufenLabel.text = [NSString stringWithFormat:@"%d", carInfo.totalScore];
    cell.koufenLabel.textColor = [self naviColor];
    if (carInfo.unknownScore) {
        cell.koufenLabel.text = @"未知";
    }
    myTableView.tableHeaderView = cell;

    recordService = [[QueryTrafRecordService alloc] init];
    recordService.delegate = self;
    [self updateNoDataViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KThemeImageChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_CarChanged object:nil];
    if (self.fromPush) {
        [self autoRefresh];
    }
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KThemeImageChanged object:nil];
}

- (void) notifyMessage:(NSNotification *) msg{
    if([msg.name isEqualToString:KThemeImageChanged]){
        TRCarCell *cell = (TRCarCell *)myTableView.tableHeaderView;
        NSString *lastUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KThemeImageChanged];
        if (lastUrl.length > 0) {
            [cell.themeImageView setImageWithURL:[NSURL URLWithString:lastUrl] placeholderImage:cell.themeImageView.image];
        }
    }else if([msg.name isEqualToString:KNotification_CarChanged]) {
        [self updateNoDataViews];
        [myTableView reloadData];
    }
}

-(void) updateNoDataViews{
    TRCarCell *cell = (TRCarCell*)myTableView.tableHeaderView;
    UIImage *bgHold = [TRUtility bgimage:TRImage(@"brandBg.png") withFontImage:TRImage(@"brandHolder.png")];
    [cell.brandImageView setImageWithURL:[NSURL URLWithString:self.carInfo.brandImageUrl] placeholderImage:bgHold];
    if (carInfo.trafficRecods.count > 0) {
        cell.line.hidden = NO;
    } else {
        cell.line.hidden = YES;
    }
    cell.carNumLabel.text = carInfo.carname.length > 0 ? carInfo.carname : carInfo.carnumber;
    UIImage *bgImage = nil;
    if (carInfo.totalNew > 0) {
        bgImage = [TRImage(@"red.png") stretchableImageWithLeftCapWidth:23 topCapHeight:11];
        [cell.timesCountBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
    } else {
        bgImage = [TRImage(@"gray.png") stretchableImageWithLeftCapWidth:23 topCapHeight:11];
        [cell.timesCountBtn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
    }
    [cell.timesCountBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    NSString *text = [NSString stringWithFormat:@"%ld",(long)carInfo.totalNew];
    
    cell.faqianLabel.text = [NSString stringWithFormat:@"%d", carInfo.totalMoney];
    if (carInfo.unknownMoney) {
        cell.faqianLabel.text = @"未知";
    }
    cell.koufenLabel.text = [NSString stringWithFormat:@"%d", carInfo.totalScore];
    if (carInfo.unknownScore) {
        cell.koufenLabel.text = @"未知";
    }

    
    float width = 42;
    float left = 261;
    if (text.length > 1) {
        width += (text.length - 1) * 6;
        left -= (text.length - 1) * 6;
    }
//    [cell.timesCountBtn setLeft:left];
    [cell.timesCountBtn setWidth:width];
    [cell.timesCountBtn setTitle:text forState:UIControlStateNormal];
    if (self.carInfo.trafficRecods.count > 0) {
        //添加线条
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        self.myTableView.backgroundView = view;
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(28, 0, 2,view.height)];
        view2.backgroundColor = [TRSkinManager colorWithInt:0xe6e6e6];
        view2.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [view addSubview:view2];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, - myTableView.height, myTableView.width, myTableView.height)];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        myTableView.tableFooterView = nil;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        self.myTableView.backgroundView = view;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.width, 90)];
        view.backgroundColor = [TRSkinManager colorWithInt:0xf5f2f0];
        UIImage *image = TRImage(@"noRecord.png");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width/2 - image.size.width/2, 15, image.size.width, image.size.height)];
        imageView.image = image;
        [view addSubview:imageView];
        
        UILabel *tableFoot = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, view.width, view.height - imageView.bottom)];
        tableFoot.backgroundColor = [UIColor clearColor];
        tableFoot.text = @"~恭喜您，没有违章记录~";
        tableFoot.textAlignment = NSTextAlignmentCenter;
        tableFoot.font = [TRSkinManager mediumFont3];
        tableFoot.textColor = [TRSkinManager textColorLightDark];
        [view addSubview:tableFoot];
        
        self.myTableView.tableFooterView = view;
    }
}

//-(void) viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //更新carInfo
//    BOOL found = NO;
//    for (CarInfo *carM in [CarInfo globCarInfo]) {
//        if ([carM.carid isEqualToString:carInfo.carid]) {
//            self.carInfo = carM;
//            found = YES;
//            break;
//        }
//    }
//    if (hasShowAuthCode) {
//        return;
//    }
//    
//    
//    int authCount = 0;
//    NSString *authCarId = nil;
//    NSString *authCityId = nil;
//    UIImage *authImage = nil;
//    for (CityOfCar *cityM in carInfo.citys) {
//        NSTimeInterval time = [cityM.authovertime doubleValue];
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        //验证码存在且过期时间大于现在时间
//        if (cityM.authurl.length > 0 && [date compare:[NSDate date]] == NSOrderedDescending) {
//            authCount++;
//            authCarId = carInfo.carid;
//            authCityId = cityM.cityid;
//            NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
//            authImage = [UIImage imageWithData:data];
//        }
//    }
//    if(authCount == 1){
//        TRAutherAlertView *alertView = [[TRAutherAlertView alloc] initWithImage:authImage];
//        alertView.textField.delegate = self;
//        alertView.carId = authCarId;
//        alertView.cityId = authCityId;
//        alertView.titleView.text = self.carInfo.carname.length > 0 ? self.carInfo.carname : self.carInfo.carnumber;
//        [alertView show];
//    } else if(authCount > 1){
//        AuthCodeDefenceViewController *authView = [[AuthCodeDefenceViewController alloc] init];
//        authView.theCarid = self.carInfo.carid;
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:authView];
//        [self presentViewController:navi animated:YES completion:nil];
//        hasShowAuthCode = YES;
//    }
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = carInfo.trafficRecods.count ;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TrafficRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficRecordCell"];
    if (cell == nil) {
        cell = [TrafficRecordCell loadFromXib];
    }
    NSInteger index = indexPath.row;
    if (index < carInfo.trafficRecods.count) {
        TrafficRecord *record = [carInfo.trafficRecods objectAtIndex:index];
        if (record.isNew) {
            cell.placeIcon.image = TRImage(@"placeRed.png");
        } else {
            cell.placeIcon.image = TRImage(@"placeBlue.png");
        }
        cell.addressLabel.text = record.location;
        cell.actionLabel.text = record.content;
        cell.timeLabel.text = record.time;
        if (record.money < 0) {
            cell.moneyLabel.text = @"未知";
        } else {
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%d", record.money];
        }
        if (record.score < 0) {
            cell.scoreLabel.text = @"未知";
        } else {
            cell.scoreLabel.text = [NSString stringWithFormat:@"-%d", record.score];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    if (carInfo.trafficRecods.count > index) {
        TrafficRecord *record = [carInfo.trafficRecods objectAtIndex:index];
        TRDetailViewController2 *detailView = [[TRDetailViewController2 alloc] init];
        detailView.detailRecord = record;
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:detailView];
        [self presentViewController:navi animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(void) loadData {
    [super loadData];
    if (recordService) {
        [MobClick event:@"single_car_refesh"];
        if (self.fromPush) {
            self.fromPush = NO;
            [recordService queryTrafRecordFromPush:[NSArray arrayWithObject:carInfo]];
        } else {
            [recordService queryTrafRecord:[NSArray arrayWithObject:carInfo]];
        }
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if(EServiceGetTrafficRecord == tag){
        BOOL found = NO;
        for (CarInfo *carM in [CarInfo globCarInfo]) {
            if ([carM.carid isEqualToString:carInfo.carid]) {
                self.carInfo = carM;
                found = YES;
                break;
            }
        }
        int authCount = 0;
        NSString *authCarId = nil;
        NSString *authCityId = nil;
        UIImage *authImage = nil;
        NSString *authInfo = nil;
        NSString *statusMsg = nil;
        if (carInfo.status != 0 && statusMsg == nil) {
            if (carInfo.statusMsg.length > 0) {
                statusMsg = [NSString stringWithFormat:@"%@:%@",carInfo.carnumber ,carInfo.statusMsg];
            } else{
                statusMsg = [NSString stringWithFormat:@"因交管系统变更查询要求，您的牌照为%@的车辆信息需要更新",carInfo.carnumber];
            }
        }
        for (CityOfCar *cityM in carInfo.citys) {
            NSTimeInterval time = [cityM.authovertime doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            //验证码存在且过期时间大于现在时间
            if (cityM.authurl.length > 0 && [date compare:[NSDate date]] == NSOrderedDescending) {
                authCount++;
                authCarId = carInfo.carid;
                authCityId = cityM.cityid;
                NSData *data = [TRUtility dataWithBase64EncodedString:cityM.authurl];
                authImage = [UIImage imageWithData:data];
                authInfo = cityM.authInfoMsg;
            }
        }
        hasShowAuthCode = NO;
        if (statusMsg.length > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:statusMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在修改", nil];
            [alert show];
            alert.tag = 201;
        } else {
            if (authCount == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
                if (!found) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该车辆已被删除，您的账号可能在其他设备上登录，请注意账号安全！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
                    [alert show];
                    alert.tag = 200;
                    return;
                }
                [self updateNoDataViews];
                [myTableView reloadData];
                if (carInfo.totalNew == 0) {
                    [self showInfoView:@"恭喜你，没有新的违章！"];
                } else {
                    [self showInfoView:[NSString stringWithFormat:@"您有%ld条新的违章！", (long)carInfo.totalNew]];
                }
            } else if(authCount == 1){
                TRAutherAlertView *alertView = [[TRAutherAlertView alloc] initWithImage:authImage];
                alertView.textField.delegate = self;
                alertView.carId = authCarId;
                alertView.cityId = authCityId;
                alertView.textField.placeholder = authInfo;
                alertView.titleView.text = self.carInfo.carname.length > 0 ? self.carInfo.carname : self.carInfo.carnumber;
                [alertView show];
            } else if(authCount > 1){
                [MobClick event:@"car_refesh_sign_pop"];
                AuthCodeDefenceViewController *authView = [[AuthCodeDefenceViewController alloc] init];
                authView.theCarid = self.carInfo.carid;
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:authView];
                [self presentViewController:navi animated:YES completion:nil];
                hasShowAuthCode = YES;
            }
        }
    }
//    [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:0];
    [self doneLoadData];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self doneLoadData];
//    [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:0];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200){
        [self naviLeftClick:nil];
    } else if(alertView.tag == 201){
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            if (carInfo.status != 0) {
                AddCarViewController * addCar = [[AddCarViewController alloc] init];
                addCar.carData = carInfo;
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
                [self presentViewController:navi animated:YES completion:nil];
                return;
            }
        }
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    TRCarCell *cell = (TRCarCell *)myTableView.tableHeaderView;
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
