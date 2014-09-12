//
//  TRAutherAlertView.h
//  TrafficRecords
//
//  Created by qiao on 13-12-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlImageView.h"
#import "TRTextField.h"
#import "AHNetDelegate.h"
#import "ChangAuthCodeService.h"
#import "AuthCodeQueryService.h"
#import "CarInfo.h"
#import "AddAuthCodeServices.h"

@interface TRAutherAlertView : UIView<AHServiceDelegate, UITextFieldDelegate>{
    ChangAuthCodeService *services;
    BOOL                  inLoading;
    UIActivityIndicatorView *loading;
    AuthCodeQueryService            *queryService;
    AddAuthCodeServices             *addAuthCodeServices;
    UIView                          *contentView;
}

-(id) initWithImage:(UIImage *) authCodeImg;

//修改车牌号，车辆的改变前的carid
@property (nonatomic, strong)NSString *modifyCarId;
//newCar默认为空，有newCar时表示为添加、修改车辆时输入验证码
@property (nonatomic, strong)CarInfo *carInfoNew;

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UrlImageView *authView;
@property (nonatomic, weak) UILabel *titleView;
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIButton *okBtn;
@property (nonatomic, weak) UIButton *changBtn;

@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *cityId;

-(void) show;
-(void) startLoading;
-(void) endLoading;
- (void)showHintView:(NSString *)message;
@end
