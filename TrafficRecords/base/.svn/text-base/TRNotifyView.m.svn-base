//
//  UINotifyView.m
//  TrafficRecords
//
//  Created by qiao on 13-10-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRNotifyView.h"

@implementation TRNotifyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [TRSkinManager colorWithInt:0xfffbe2];
        UIImageView *icon = [[UIImageView alloc] initWithImage:TRImage(@"notify.png")];
        icon.frame = CGRectMake(10, self.height/2 - icon.height/2, icon.width, icon.height);
        [self addSubview:icon];
        
        icon = [[UIImageView alloc] initWithImage:TRImage(@"next.png")];
        icon.frame = CGRectMake(self.width - 10 - icon.width, self.height/2 - icon.height/2, icon.width, icon.height);
        [self addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, icon.left - 30, self.height)];
        label.text = @"为了您的信息安全，需输入验证码获得最新信息";
        label.font = [TRSkinManager mediumFont3];
        label.textColor = [TRSkinManager textColorDark];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
