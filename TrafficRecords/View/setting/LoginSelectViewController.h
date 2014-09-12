//
//  LoginSelectViewController.h
//  TrafficRecords
//
//  Created by 张小桥 on 13-11-29.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "ThirdLoginService.h"
#import "BindingCarService.h"


@interface LoginSelectViewController : TRBaseViewController{
    ThirdLoginService    *loginService;
    BindingCarService    *bindingService;
}

@property(nonatomic, weak) IBOutlet UIButton *btn1;
@property(nonatomic, weak) IBOutlet UIButton *btn2;
@property(nonatomic, weak) IBOutlet UIButton *btn3;
@property(nonatomic, weak) IBOutlet UIView *lineTop;
@property(nonatomic, weak) IBOutlet UIView *lineBottom;

-(IBAction)btnClick1:(id)sender;
-(IBAction)btnClick2:(id)sender;
-(IBAction)btnClick3:(id)sender;

@end
