//
//  LoginViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-22.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LoginViewController.h"
#import "TRUtility.h"
#import "SIAlertView.h"
#import "Des.h"
#import "UMSocial.h"
#import "CarInfo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userName;
@synthesize passWord;
@synthesize loginBtn;
@synthesize line1;
@synthesize line2;
@synthesize line3;

-(NSString *) naviTitle{
    return @"汽车之家账号登录";
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
    
    if (kSystemVersion >= 7.0) {
        for (UIView *subView in self.view.subviews) {
            [subView setTop:subView.top + KDefaultStartY];
        }
    }
    float lineH =[TRUtility lineHeight];
    [line1 setHeight:lineH];
    [line2 setHeight:lineH];
    [line3 setHeight:lineH];
    self.loginBtn.layer.cornerRadius = 4;
    UIImage *bgImage = [TRImage(@"loginBg.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    UIImage *unEnableImage = [TRImage(@"loginBgHL.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    [self.loginBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:unEnableImage forState:UIControlStateDisabled];
    self.loginBtn.enabled = NO;
    [userName setTextColor:[TRSkinManager colorWithInt:0x666666]];
    [passWord setTextColor:[TRSkinManager colorWithInt:0x666666]];
    userName.delegate = self;
    passWord.delegate = self;
    TRAppDelegate *appDelegate = [TRAppDelegate appDelegate];
    if (appDelegate.userName.length > 0) {
        userName.text = appDelegate.userName;
    }
    if (appDelegate.password.length > 0) {
        passWord.text = appDelegate.password;
    }
    [MobClick event:@"login_arrive"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEvent:) name:KNotification_GlobTouchEvent object:nil];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
}

-(void) touchEvent:(NSNotification*) touchMsg{
    UIEvent *event = touchMsg.object;
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = touch.view;
    if ( ![view isKindOfClass:[UITextField class]] && view != nil) {
        [self hiddenKeyBoard];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) login:(id)sender{
    if (service == nil) {
        service = [[LoginService alloc] init];
        service.delegate = self;
    }
    NSString *name = userName.text;
    NSString *pwd = passWord.text;
    if (name.length < 2) {
        [self showInfoView:@"请输入正确的用户名！"];
        return;
    }
    if (pwd.length < 6 || pwd.length > 25) {
         [self showInfoView:@"密码长度必须在6~25位之间！"];
        return;
    }
    pwd = [TRUtility md5Value:pwd];
    [service loginWithUser:name pwd:pwd authCode:nil];
    [MobClick event:@"login_click"];
    [self showLoadingAnimated:YES];
}

#pragma mark -
#pragma mark AHServiceDelegate Methods

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (EServiceLogin == tag) {
        if (service.firstLogin == 0) {
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
            [bindingService binding:service.useId withCars:str];
        } else {
            [self LoginSucess];
            [self hideLoadingViewAnimated:YES];
        }
    } else if(EServiceBindingCars == tag){
        [self hideLoadingViewAnimated:YES];
        //将bindingService.carTimeStamp传到loginService中
        service.carTimeStamp = bindingService.carTimeStamp;
        NSMutableArray *carItems = [NSMutableArray array];
        for (CarInfo *carM in [CarInfo globCarInfo]) {
            [carItems addObject:[carM copyCar]];
        }
        service.carsItems = carItems;
        [CarInfo deleteAllCars];
        [self LoginSucess];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (EServiceLogin == tag) {
        [MobClick event:@"login_fail" label:[NSString stringWithFormat:@"%d", errorCode]];
        [self hideLoadingViewAnimated:YES];
        //需要输入验证码
        if (errorCode == -50) {
            [MobClick event:@"login_sign"];
            service.isShowNetHint = NO;
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"请输入验证码" andMessage:@""];
            
            [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {}];
            [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                UITextField *input = (UITextField *)[alertView viewWithTag:1929];
                NSString *text = [input text];
                NSString *name = userName.text;
                NSString *pwd = passWord.text;
                pwd = [TRUtility md5Value:pwd];
                [service loginWithUser:name pwd:pwd authCode:text];
                [self showLoadingAnimated:YES];
                [alertView dismissAnimated:YES];
            }];
            [alertView show];
            
            alertView.messageLabel.hidden = YES;
            UIImage *image = service.authImage;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.top = alertView.messageLabel.top + alertView.messageLabel.height/2 - image.size.height/2;
            imageView.left = alertView.messageLabel.left;
            [alertView.containerView addSubview:imageView];
            
            UIView *view = [alertView.buttons objectAtIndex:alertView.buttons.count - 1];
            UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(view.right  - image.size.width, imageView.top, image.size.width, image.size.height)];
            input.delegate = self;
            input.borderStyle = UITextBorderStyleNone;
            input.backgroundColor = [UIColor clearColor];
            input.background = TRImage(@"inputBg2.png");
            input.keyboardType = UIKeyboardTypeASCIICapable;
            input.autocorrectionType = UITextAutocorrectionTypeNo;
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            input.tag = 1929;
            [alertView.containerView addSubview:input];
        }
    }
}

- (void)LoginSucess {
    if ([TRAppDelegate appDelegate].userId == 0) {
        [CarInfo resetAllCars];
    }
    NSString * carTimestamp = service.carTimeStamp;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:carTimestamp forKey:KCarsTimestamp];
    [defaults setObject:userName.text forKey:KUserName];
    [defaults setObject:[Des encryptStr:passWord.text  key:gKey_addCar iv:gIv_addCar] forKey:KPassword];
    [defaults setObject:[Des encryptStr:service.useId key:gKey_addCar iv:gIv_addCar] forKey:KUserId];
    [defaults synchronize];
    [TRAppDelegate appDelegate].userId = [service.useId intValue];
    [TRAppDelegate appDelegate].userName = userName.text;
    [TRAppDelegate appDelegate].password = passWord.text;
    [CarInfo deleteAllCars];//删除掉旧的数据
    [[TRAppDelegate appDelegate] sendToken];
    
    NSMutableArray *globCars = [CarInfo globCarInfo];
    NSArray * cars = service.carsItems;
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

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if(buttonIndex == alertView.cancelButtonIndex)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (userName == textField) {
        if (self.passWord.text.length > 0) {
            [self login: nil];
        } else {
            [userName resignFirstResponder];
            [passWord becomeFirstResponder];
        }
    } else if(passWord == textField){
        if (self.userName.text.length > 0) {
            [self login: nil];
        } else {
            [passWord resignFirstResponder];
            [userName becomeFirstResponder];
        }
    } else {
        
    }
    return [super textFieldShouldReturn:textField];
}
//
//-(IBAction)shareToTXWeiBo:(id)sender{
////    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:KQQAppKey andDelegate:self];
////    NSArray *_permissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
////    [_tencentOAuth authorize:_permissions inSafari:NO];
//    
////    
////    account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToTencent];
////    NSLog(@"%@, %@, %@, %@, %@, %@, %d", account.userName, account.usid, account.iconURL, account.accessToken, account.profileURL, account.openId, account.isFirstOauth);
////    account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToQzone];
////    NSLog(@"%@, %@, %@, %@, %@, %@, %d", account.userName, account.usid, account.iconURL, account.accessToken, account.profileURL, account.openId, account.isFirstOauth);
////    account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToWechatSession];
////    NSLog(@"%@, %@, %@, %@, %@, %@, %d", account.userName, account.usid, account.iconURL, account.accessToken, account.profileURL, account.openId, account.isFirstOauth);
////    account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToWechatTimeline];
////    NSLog(@"%@, %@, %@, %@, %@, %@, %d", account.userName, account.usid, account.iconURL, account.accessToken, account.profileURL, account.openId, account.isFirstOauth);
////    account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToQQ];
////    NSLog(@"%@, %@, %@, %@, %@, %@, %d", account.userName, account.usid, account.iconURL, account.accessToken, account.profileURL, account.openId, account.isFirstOauth);
//////
////
////    [UMSocialSnsService presentSnsIconSheetView:self
////                                         appKey:nil
////                                      shareText:@"你要分享的文字"
////                                     shareImage:[UIImage imageNamed:@"icon.png"]
////                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession, UMShareToWechatTimeline,UMShareToQQ,nil]
////                                       delegate:nil];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *name = userName.text;
    NSString *pwd = passWord.text;
    if (textField == userName) {
        name = [name stringByReplacingCharactersInRange:range withString:string];
    } else if(textField == passWord){
        pwd = [pwd stringByReplacingCharactersInRange:range withString:string];
    }
    if (name.length >= 2 && (pwd.length >=6 && pwd.length <= 25)) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
    return YES;
}

@end
