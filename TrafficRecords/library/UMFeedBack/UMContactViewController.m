//
//  UMContactViewController.m
//  Demo
//
//  Created by liuyu on 4/2/13.
//  Copyright (c) 2013 iOS@Umeng. All rights reserved.
//

#import "UMContactViewController.h"

@implementation UMContactViewController


-(NSString *) naviTitle{
    return @"填写联系信息";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(NSString *) naviRightIcon{
    return @"item_ok.png";
}

-(void) naviLeftClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) naviRightClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(updateContactInfo:contactInfo:)]) {
        [self.delegate updateContactInfo:self contactInfo:self.textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238.0 / 255 green:238.0 / 255 blue:238.0 / 255 alpha:1.0];

    self.textView.placeholder = @"请留下您的QQ，邮箱，电话等联系方式";
    [self.textView selectAll:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
