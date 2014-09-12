//
//  AHToastView.h
//  Autohome
//
//  Created by 王俊 on 12-12-3.
//  Copyright (c) 2012年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
enum AnimationType{
    AnimationDefault
};

@interface AHToastView : UIView {
    UIImageView *_iconView;
    UIColor *_color;
    CGGradientRef _gradient;
    UIView *target;
    
    CGFloat bottomEdge;//控件底部距离父窗口的高
    
    NSTimer *timer;
}
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat bottomEdge; 

-(void)animationByType:(enum AnimationType)type delayTime:(NSInteger)time;
- (id)initWithWidth:(CGFloat)width target:(UIView*)_target;
- (id)initWithTitle:(NSString *)title detail:(NSString *)detail target:(UIView*)_target;
- (UIColor *)lightenColor:(UIColor *)oldColor value:(float)value;
- (void) updateHeight;
-(void)showDelayTime:(NSInteger)time andAnimationType:(enum AnimationType)type;
-(void)show;
-(void)hiddenView;
@end
