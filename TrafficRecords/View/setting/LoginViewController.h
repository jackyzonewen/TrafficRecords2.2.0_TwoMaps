//
//  LoginViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-22.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "TRTextField.h"
#import "LoginService.h"
#import "BindingCarService.h"

@interface LoginViewController : TRBaseViewController{
    LoginService         *service;
    BindingCarService    *bindingService;
}

@property (nonatomic, weak)IBOutlet TRTextField *userName;
@property (nonatomic, weak)IBOutlet TRTextField *passWord;
@property (nonatomic, weak)IBOutlet UIButton *loginBtn;
@property (nonatomic, weak)IBOutlet UIView *line1;
@property (nonatomic, weak)IBOutlet UIView *line2;
@property (nonatomic, weak)IBOutlet UIView *line3;

-(IBAction) login:(id)sender;

@end
