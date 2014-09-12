//
//  TRSettingViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRSettingViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "UMFeedbackViewController.h"
#import "CarInfo.h"
#import "CarManagerViewController.h"
#import "Des.h"
#import "TRImageView.h"
#import "LoginSelectViewController.h"
#import "UMSocial.h"
#import "LuKuangViewController.h"
#import "TRAppViewController.h"
#import "TRWebViewController.h"
#import "ActivityViewController.h"
#import "TRSettingPushViewController.h"

@interface TRSettingViewController ()

@end

@implementation TRSettingViewController
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([TRAppDelegate appDelegate].appInfo.showScore) {
        NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
        NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况", @"精品应用", @"保养优惠", @"推送设置", @"鼓励一下",  @"关于我们" , nil];
        if (text.length > 0) {
            [texts insertObject:@"抽奖活动" atIndex:1];
        }
        textArray = texts;
        NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png",  @"setting2.png", @"setting4.png",@"setting11.png",@"setting10.png", @"setting8.png",  @"setting7.png",   nil];
        if (text.length > 0) {
            [icons insertObject:@"setting9.png" atIndex:1];
        }
        iconArray = icons;
    } else {
        NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
        NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况",@"保养优惠", @"推送设置", @"关于我们",  nil];
        if (text.length > 0) {
            [texts insertObject:@"抽奖活动" atIndex:1];
        }
        textArray = texts;
        NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png", @"setting2.png",@"setting11.png",@"setting10.png", @"setting7.png", nil];
        if (text.length > 0) {
            [icons insertObject:@"setting9.png" atIndex:1];
        }
        iconArray = icons;
    }
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId <= 0) {
        cityId = 110100;
    }
    NSString *cityIdstr = [NSString stringWithFormat:@"%d", cityId];
    if ([[TRAppDelegate appDelegate].appInfo.baoyangCitys rangeOfString:cityIdstr].length <= 0) {
        [textArray removeObject:@"保养优惠"];
        [iconArray removeObject:@"setting11.png"];
    }

    CGRect frame = self.view.bounds;
    frame.origin.y -= 20;
    frame.size.height += 20;
    float height = 0;
    if (kSystemVersion >= 7.0) {
        height = 20;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:TRImage(@"settingBg.png")];
    imageView.frame =  frame;
    [self.view addSubview:imageView];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, frame.size.width, self.view.height - height) style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.myTableView.backgroundView = view;
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_SetteingView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_GetAppInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_CityChanged object:nil];
}


-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_SetteingView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GetAppInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_CityChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
    return textArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 102;
    }
    return 48;
}

-(void) logout{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
    [alert show];
    alert.tag = 200;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell1"];
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            TRImageView *icon = [[TRImageView alloc] initWithFrame:CGRectMake(20, 35, 44, 44)];
            icon.cornerRadius = -1;
            [cell addSubview:icon];
            icon.tag = 200;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 9, icon.top, 170, icon.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [TRSkinManager colorWithInt:0x33ffffff];
            label.font = [TRSkinManager mediumFont3];
            [cell addSubview:label];
            label.tag = 201;
            
            UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(194, icon.top, 60, icon.height);
            [logoutBtn setImage:TRImage(@"logout.png") forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
            [logoutBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            logoutBtn.titleLabel.font = [TRSkinManager mediumFont3];
            logoutBtn.tag = 202;
            [logoutBtn setTitleColor:[TRSkinManager colorWithInt:0x33ffffff] forState:UIControlStateNormal];
            [cell addSubview:logoutBtn];
            logoutBtn.hidden = YES;
            [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            
            float lineH = [TRUtility lineHeight];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - lineH, KSettingViewWidth , lineH)];
            line.backgroundColor = [TRSkinManager colorWithInt:0x363636];
            [cell addSubview:line];
        }
        TRImageView *icon = (TRImageView*)[cell viewWithTag:200];
        NSString *str = [iconArray objectAtIndex:indexPath.row];
        icon.image = TRImage(str);
        UILabel *label = (UILabel*)[cell viewWithTag:201];
        label.text = [textArray objectAtIndex:indexPath.row];
        UIButton *logoutBtn = (UIButton*)[cell viewWithTag:202];
        if ([TRAppDelegate appDelegate].userId != 0) {
            NSString * name = [TRAppDelegate appDelegate].userName;
            label.text = name;
            [icon setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:KUserPicUrl]] placeholderImage:icon.image];
            logoutBtn.hidden = NO;
        } else {
            label.text = @"登录";
            logoutBtn.hidden = YES;
        }
        return cell;
    } else { // 其他行的cell
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = [TRSkinManager colorWithInt:0x1f1f1f];
            
            TRImageView *icon = [[TRImageView alloc] initWithFrame:CGRectMake(30, height/2 - 7.5, 15, 15)];
            [cell addSubview:icon];
            icon.tag = 200;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + 15, 0, 170, height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [TRSkinManager colorWithInt:0x33ffffff];
            label.font = [TRSkinManager mediumFont3];
            [cell addSubview:label];
            label.tag = 201;
            
            float lineH = [TRUtility lineHeight];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - lineH, KSettingViewWidth, lineH)];
            line.backgroundColor = [TRSkinManager colorWithInt:0x363636];
            [cell addSubview:line];
            
            UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *iconBtn = [[UIImage imageNamed:@"new.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:18];
            newBtn.frame = CGRectMake(140, height/2 - iconBtn.size.height/2, iconBtn.size.width, iconBtn.size.height);
            [newBtn setBackgroundImage:iconBtn forState:UIControlStateNormal];
            [newBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
            newBtn.titleLabel.font = [TRSkinManager smallFont1];
            newBtn.tag = 203;
            newBtn.hidden = YES;
            [cell addSubview:newBtn];
        }
        
        TRImageView *icon = (TRImageView*)[cell viewWithTag:200];
        NSString *str = [iconArray objectAtIndex:indexPath.row];
        icon.image = TRImage(str);
        
        UILabel *label = (UILabel*)[cell viewWithTag:201];
        label.text = [textArray objectAtIndex:indexPath.row];
        UIView *new = [cell viewWithTag:203];
        if ([label.text isEqualToString:@"检查更新"]) {
            NSString *deviceVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            NSString *newestVersion = [TRAppDelegate appDelegate].appInfo.newestVersion;
            if ([newestVersion compare:deviceVersion options:NSNumericSearch]==NSOrderedDescending){
                new.hidden = NO;
            } else {
                new.hidden = YES;
            }
        } else if([label.text isEqualToString:@"实时路况"]){
            BOOL clicked = [[NSUserDefaults standardUserDefaults] boolForKey:KLuKuangBeClicked];
            if (clicked) {
                new.hidden = YES;
            } else {
                new.hidden = NO;
            }
        }
        else if([label.text isEqualToString:@"抽奖活动"]){
            BOOL clicked = [[NSUserDefaults standardUserDefaults] boolForKey:KActivityBeClicked];
            if (clicked) {
                new.hidden = YES;
            } else {
                new.hidden = NO;
            }
        }
//        else if([label.text isEqualToString:@"推送设置"]){
//            BOOL clicked = [[NSUserDefaults standardUserDefaults] boolForKey:KPushSettingBeClicked];
//            if (clicked) {
//                new.hidden = YES;
//            } else {
//                new.hidden = NO;
//            }
//        }
        else {
            new.hidden = YES;
        }
        return cell;
    }
}

-(void) logout:(id) sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
    [alert show];
    alert.tag = 200;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= textArray.count) {
        return;
    }
    NSString *text = [textArray objectAtIndex:indexPath.row];
    if ([text isEqualToString:@"登录"]) {
        if ([TRAppDelegate appDelegate].userId == 0) {
            LoginSelectViewController *selectLogin = [[LoginSelectViewController alloc] initWithNibName:@"LoginSelectViewController" bundle:nil];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:selectLogin];
            [self presentViewController:navi animated:YES completion:nil];
        }
    } else if([text isEqualToString:@"意见反馈"]){
        UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
        feedbackViewController.appkey = KUMengAppKey;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
        [self presentModalViewController:navigationController animated:YES];
    }
    else if([text isEqualToString:@"检查更新"]){
        [self showLoadingAnimated:YES];
        if (appInfoService == nil) {
            appInfoService = [[GetAppInfoService alloc] init];
            appInfoService.delegate = self;
            appInfoService.isUserKnow = YES;
            appInfoService.isAddCache = NO;
        }
        [appInfoService getAppInfo];
    } else if([text isEqualToString:@"关于我们"]){
        AboutUsViewController * aboutUs = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:aboutUs];
        [self presentViewController:navi animated:YES completion:nil];
    } else if([text isEqualToString:@"车辆管理"]){
        CarManagerViewController *carM = [[CarManagerViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:carM];
        [self presentViewController:navi animated:YES completion:nil];
    } else if ([text isEqualToString:@"鼓励一下"]){
        NSString *url = [TRAppDelegate appDelegate].appInfo.commentUrl;
        if (url.length == 0) {
            url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"708985992"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else if([text isEqualToString:@"实时路况"]){
        [MobClick event:@"lukuang_click"];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:KLuKuangBeClicked] == NO) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KLuKuangBeClicked];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myTableView reloadData];
        }
        LuKuangViewController * lukuang = [[LuKuangViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lukuang];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else if([text isEqualToString:@"精品应用"]){
        [MobClick event:@"recommend_app_click"];
        TRAppViewController *appView = [[TRAppViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:appView];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else if([text isEqualToString:@"抽奖活动"]){
        if ([[NSUserDefaults standardUserDefaults] boolForKey:KActivityBeClicked] == NO) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KActivityBeClicked];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myTableView reloadData];
        }
        
        ActivityViewController *webView = [[ActivityViewController alloc] init];
        webView.url = [NSString stringWithFormat:@"%@?qd=%@&extend=%d&t=%d", [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl], KChannelId, [CarInfo globCarInfo].count, (int)[[NSDate date] timeIntervalSince1970]];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webView];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else if([text isEqualToString:@"推送设置"]){
        if ([[NSUserDefaults standardUserDefaults] boolForKey:KPushSettingBeClicked] == NO) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KPushSettingBeClicked];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [myTableView reloadData];
        }
        TRSettingPushViewController *pushSetView = [[TRSettingPushViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pushSetView];
        [self presentModalViewController:navi animated:YES];
    } else if([text isEqualToString:@"保养优惠"]){
        [MobClick event:@"yangche_click"];
        TRWebViewController *webView = [[TRWebViewController alloc] init];
        webView.url = @"http://yc.m.autohome.com.cn";
        webView.title = @"保养优惠";
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webView];
        [self presentViewController:navi animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) notifyMessage:(NSNotification *) message{
    if ([message.name isEqualToString:KNotification_GetAppInfo] || [message.name isEqualToString:KNotification_CityChanged]) {
        if ([TRAppDelegate appDelegate].appInfo.showScore) {
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
            NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况", @"精品应用", @"保养优惠", @"推送设置", @"鼓励一下",  @"关于我们" , nil];
            if (text.length > 0) {
                [texts insertObject:@"抽奖活动" atIndex:1];
            }
            textArray = texts;
            NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png",  @"setting2.png", @"setting4.png",@"setting11.png",@"setting10.png", @"setting8.png",  @"setting7.png",   nil];
            if (text.length > 0) {
                [icons insertObject:@"setting9.png" atIndex:1];
            }
            iconArray = icons;
        } else {
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
            NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况",@"保养优惠", @"推送设置", @"关于我们",  nil];
            if (text.length > 0) {
                [texts insertObject:@"抽奖活动" atIndex:1];
            }
            textArray = texts;
            NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png", @"setting2.png",@"setting11.png",@"setting10.png", @"setting7.png", nil];
            if (text.length > 0) {
                [icons insertObject:@"setting9.png" atIndex:1];
            }
            iconArray = icons;
        }
        NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
        if (cityId <= 0) {
            cityId = 110100;
        }
        NSString *cityIdstr = [NSString stringWithFormat:@"%d", cityId];
        if ([[TRAppDelegate appDelegate].appInfo.baoyangCitys rangeOfString:cityIdstr].length <= 0) {
            [textArray removeObject:@"保养优惠"];
            [iconArray removeObject:@"setting11.png"];
        }
        [myTableView reloadData];
    }
    else if([KNotification_SetteingView isEqualToString:message.name]){
        [myTableView reloadData];
    }
}

#pragma mark -UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView{
    if (alertView.tag == 100) {
        for (UIView * view in alertView.subviews) {
            if([view isKindOfClass:[UILabel class]] && [[(UILabel *) view text] isEqualToString:alertView.message]){
                UILabel* label = (UILabel*) view;
                label.textAlignment = UITextAlignmentLeft;
                return;
            }
        }
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView{
    if (alertView.tag == 100) {
        for (UIView * view in alertView.subviews) {
            if([view isKindOfClass:[UILabel class]] && [[(UILabel *) view text] isEqualToString:alertView.message]){
                UILabel* label = (UILabel*) view;
                label.textAlignment = UITextAlignmentLeft;
                return;
            }
        }
    }
}
#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appInfoService.updateUrl]];
        }
    } else if(alertView.tag == 200) {
        if(buttonIndex != alertView.cancelButtonIndex) {
//            [[UMSocialDataService defaultDataService] requestUnBindToSnsWithCompletion:nil];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:nil];
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQzone completion:nil];
            [CarInfo deleteAllCars];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:KUserName];
            [defaults setObject:[Des encryptStr:@""  key:gKey_addCar iv:gIv_addCar] forKey:KPassword];
            [defaults setObject:[Des encryptStr:@"0"  key:gKey_addCar iv:gIv_addCar] forKey:KUserId];
            [defaults synchronize];
            [TRAppDelegate appDelegate].userId = 0;
            [TRAppDelegate appDelegate].userName = nil;
            [TRAppDelegate appDelegate].password = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
            [myTableView reloadData];
        }
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    if (tag == EServiceGetAppInfo) {
        if (appInfoService.showScore) {
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
            NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况", @"精品应用", @"保养优惠", @"推送设置", @"鼓励一下",  @"关于我们" , nil];
            if (text.length > 0) {
                [texts insertObject:@"抽奖活动" atIndex:1];
            }
            textArray = texts;
            NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png",  @"setting2.png", @"setting4.png",@"setting11.png",@"setting10.png", @"setting8.png",  @"setting7.png",   nil];
            if (text.length > 0) {
                [icons insertObject:@"setting9.png" atIndex:1];
            }
            iconArray = icons;
        } else {
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityUrl];
            NSMutableArray *texts = [NSMutableArray arrayWithObjects:@"登录", @"车辆管理",@"意见反馈",@"检查更新",@"实时路况",@"保养优惠", @"推送设置", @"关于我们",  nil];
            if (text.length > 0) {
                [texts insertObject:@"抽奖活动" atIndex:1];
            }
            textArray = texts;
            NSMutableArray *icons = [NSMutableArray arrayWithObjects:@"setting0.png",@"setting1.png", @"setting3.png", @"setting6.png", @"setting2.png",@"setting11.png",@"setting10.png", @"setting7.png", nil];
            if (text.length > 0) {
                [icons insertObject:@"setting9.png" atIndex:1];
            }
            iconArray = icons;
        }
        NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
        if (cityId <= 0) {
            cityId = 110100;
        }
        NSString *cityIdstr = [NSString stringWithFormat:@"%d", cityId];
        if ([[TRAppDelegate appDelegate].appInfo.baoyangCitys rangeOfString:cityIdstr].length <= 0) {
            [textArray removeObject:@"保养优惠"];
            [iconArray removeObject:@"setting11.png"];
        }
        NSString *newestVersion = appInfoService.newestVersion;
        NSString *msg = appInfoService.updateInfo;
        NSString *deviceVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if ([newestVersion compare:deviceVersion options:NSNumericSearch] == NSOrderedDescending){
            if (msg.length == 0) {
                msg = [NSString stringWithFormat:@"发现%@新版本，快去下载更新", newestVersion];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
            alert.tag = 100;
            [alert show];
            
        } else {
            [self showInfoView: @"当前已经是最新版本了！"];
        }
        [self.myTableView reloadData];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
}

@end
