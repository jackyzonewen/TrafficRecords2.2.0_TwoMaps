//
//  LoginSelectViewController.m
//  TrafficRecords
//
//  Created by 张小桥 on 13-11-29.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "UINavigationController+ViewAnimation.h"
#import "CarInfo.h"
#import "Des.h"
#import "OpenUDID.h"
#import "TRWebViewController.h"

@interface LoginSelectViewController ()

@end

@implementation LoginSelectViewController

@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize lineTop;
@synthesize lineBottom;

-(NSString *) naviTitle{
    return @"登录";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIImage *image1 = [TRUtility imageWithColor:[UIColor clearColor]];
    UIImage *image2 = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xe9e7e5]];
    [btn1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn1 setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn2 setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:image1 forState:UIControlStateNormal];
    [btn3 setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [lineTop setHeight:0.5];
    [lineBottom setTop:lineBottom.top + 0.5];
    [lineBottom setHeight:0.5];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnClick1:(id)sender{
    [MobClick event:@"login_sina_click"];
    UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToSina];
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina] && account && account.usid.length > 0) {
        [self loginWithSNSPlatForm:UMShareToSina];
    } else {
        @try {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self loginWithSNSPlatForm:UMShareToSina];
                } else {
                    [self showInfoView:@"新浪微博授权失败"];
                }
            });
        }
        @catch (NSException *exception) {
            [self showInfoView:@"新浪微博发生异常"];
        }
        @finally {
            
        }

    }
}

-(IBAction)btnClick2:(id)sender{
//    TRWebViewController *web = [[TRWebViewController alloc] init];
//    web.url = @"http://wz.m.autohome.com.cn";
//    web.title = @"服务协议";
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:web];
//    [self presentViewController:navi animated:YES completion:nil];
    
    
    [MobClick event:@"login_qq_click"];
    UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToQzone];
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToQzone] && account && account.usid.length > 0) {
        [self loginWithSNSPlatForm:UMShareToQzone];
    } else {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [self loginWithSNSPlatForm:UMShareToQzone];
            } else {
                [self showInfoView:@"腾讯账号授权失败"];
            }
        });
    }

//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:KWXAPPKey
//                                      shareText:@"友盟社会化分享让您快速实现分享等社会化功能，www.umeng.com/social"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite]
//                                       delegate:self];
}

-(IBAction)btnClick3:(id)sender{
    [MobClick event:@"login_autohome_click"];
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
//    [self presentViewController:navi animated:YES completion:nil];
    [self.navigationController pushViewController:login animatedWithTransition:UIViewAnimationTransitionCurlUp];
}


-(void) loginWithSNSPlatForm:(NSString *) platType{
    UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:platType];
    NSString *type = @"1";	//sina
    if ([platType isEqualToString:UMShareToQzone]) {
        type = @"2";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: account.usid, @"third_user_id",
                         type, @"third_platform_ident",
                         account.iconURL.length > 0 ? account.iconURL : @"", @"third_user_iconurl",
                         account.accessToken, @"third_user_accesstoken",
                         account.userName.length > 0 ? account.userName : @"", @"third_user_nickname",
                         account.profileURL.length > 0 ? account.profileURL : @"", @"third_user_profileurl",
                         account.openId.length > 0 ? account.openId : @"", @"third_user_openid",
                         [OpenUDID value], @"deviceid",
                         nil];
    if (loginService == nil) {
        loginService = [[ThirdLoginService alloc] init];
        loginService.delegate = self;
    }
    [loginService loginWithThirdInfo:dic];
    [self showLoadingAnimated:YES];
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceThirdLogin) {
        if (loginService.firstLogin == 0) {
            //流程未完，继续 绑定本地车辆到服务器
            if (bindingService == nil) {
                bindingService = [[BindingCarService alloc] init];
                bindingService.delegate = self;
            }
            NSMutableString *str = [NSMutableString string];
            for (CarInfo * carM in [CarInfo globCarInfo]) {
                if (str.length > 0) {
                    [str appendString:@","];
                }
                [str appendString:carM.carid];
            }
            [bindingService binding:loginService.userId withCars:str];
        } else {
            [self LoginSucess];
            [self hideLoadingViewAnimated:YES];
        }
    } else if(EServiceBindingCars == tag){
        [self hideLoadingViewAnimated:YES];
        //将bindingService.carTimeStamp传到loginService中
        loginService.carTimeStamp = bindingService.carTimeStamp;
        NSMutableArray *carItems = [NSMutableArray array];
        for (CarInfo *carM in [CarInfo globCarInfo]) {
            [carItems addObject:[carM copyCar]];
        }
        loginService.carsItems = carItems;
        [CarInfo deleteAllCars];
        [self LoginSucess];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
}

- (void)LoginSucess {
    if ([TRAppDelegate appDelegate].userId == 0) {
        [CarInfo resetAllCars];
    }
    
    NSString *miniPic = [loginService.reqUserDic objectForKey:@"third_user_iconurl"];
    if (miniPic == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KUserPicUrl];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:miniPic forKey:KUserPicUrl];
    }
    
    NSString * carTimestamp = loginService.carTimeStamp;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:carTimestamp forKey:KCarsTimestamp];
    [defaults setObject:[loginService.reqUserDic objectForKey:@"third_user_nickname"] forKey:KUserName];
    [defaults setObject:[Des encryptStr:@""  key:gKey_addCar iv:gIv_addCar] forKey:KPassword];
    [defaults setObject:[Des encryptStr:loginService.userId key:gKey_addCar iv:gIv_addCar] forKey:KUserId];
    [defaults synchronize];
    [TRAppDelegate appDelegate].userId = [loginService.userId intValue];
    [TRAppDelegate appDelegate].userName = [loginService.reqUserDic objectForKey:@"third_user_nickname"];
    [TRAppDelegate appDelegate].password = @"";
    [CarInfo deleteAllCars];//删除掉旧的数据
    [[TRAppDelegate appDelegate] sendToken];
    NSMutableArray *globCars = [CarInfo globCarInfo];
    NSArray * cars = loginService.carsItems;
    for (int i = 0; i < cars.count; i++) {
        //将车辆插入数据库，加入全局数组
        CarInfo *car = [cars objectAtIndex:i];
        [CarInfo insertCar:car];
        [globCars addObject:car];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:[NSNumber numberWithBool:YES]];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_SetteingView object:[NSNumber numberWithBool:YES]];
    if (bindingService && bindingService.toBindingCars.length > 0) {
        [self showInfoView:@"您本地的车辆已同步到云端，方便您随时随地查询！"];
    } else {
        [self showInfoView:@"登录成功！"];
    }
    [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:nil afterDelay:0.2];
}


@end
