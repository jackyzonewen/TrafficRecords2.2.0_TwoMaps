//
//  ProShortView.m
//  TrafficRecords
//
//  Created by qiao on 13-9-17.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "ProShortView.h"

@implementation ProShortView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        orginFrame = self.frame;
        UIImageView *bg = [[UIImageView alloc] initWithImage:TRImage(@"keyboardbg.png")];
        bg.frame = self.bounds;
        [self addSubview:bg];
        NSArray *texts = [NSArray arrayWithObjects:@"京",@"沪",@"浙",@"苏",@"粤",@"鲁",@"晋",@"冀",@"豫",@"川",@"渝",@"辽",@"吉",@"黑",@"皖",@"鄂",@"湘",@"赣",@"闽",@"陕",@"甘",@"宁",@"蒙",@"津",@"贵",@"云",@"桂",@"琼",@"青",@"新",@"藏", nil];
        CGPoint start = CGPointMake(5, 9);
        UIImage *icon = TRImage(@"btnbg.png");
        for (NSString *text in texts) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(start.x, start.y, icon.size.width, icon.size.height);
            [btn setTitle:text forState:UIControlStateNormal];
            [btn setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
            [btn setBackgroundImage:icon forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            start.x += icon.size.width + 5;
            if (start.x >= self.width) {
                start.x = 5;
                start.y += icon.size.height + 12;
            }
        }
    }
    return self;
}

-(void) btnClick:(UIButton *) btn{
    NSString *text = [btn titleForState:UIControlStateNormal];
    if (delegate && [delegate respondsToSelector:@selector(proBeSelected:)]) {
        [delegate proBeSelected:text];
    }
}

-(void) showInView:(UIView *) superView{
    if (self.superview != nil) {
        return;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (backBtn == nil) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundColor:[UIColor clearColor]];
        backBtn.frame = CGRectMake(0, 0, window.width, window.height - self.height);
        [backBtn addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    [window addSubview:backBtn];
    [superView addSubview:self];
    
    [self setTop:self.top + self.height];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = orginFrame;
    [UIView commitAnimations];
}

-(void) hiddenKeyBoard{
    [UIView animateWithDuration:0.3 animations:^{
        [self setTop:self.top + self.height];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void) removeFromSuperview{
    [backBtn removeFromSuperview];
    [super removeFromSuperview];
}

@end
