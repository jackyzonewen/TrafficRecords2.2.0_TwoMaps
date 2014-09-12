//
//  AHToastView2.m
//  TrafficRecords
//
//  Created by qiao on 13-10-26.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AHToastView2.h"

@implementation AHToastView2

-(id) init{
    self = [super init];
    if (self) {
        self.backgroundColor = [TRSkinManager colorWithInt:KTransBgColor];
        self.font = [UIFont boldSystemFontOfSize:16.0];
        self.textColor = [TRSkinManager textColorWhite];
        self.layer.cornerRadius = 4;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [TRSkinManager colorWithInt:KTransBgColor];
        self.font = [UIFont boldSystemFontOfSize:16.0];
        self.textColor = [TRSkinManager textColorWhite];
        self.layer.cornerRadius = 4;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)show{
    [self animationBydelayTime:2.0];
}

-(void)animationBydelayTime:(NSInteger)time{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    float margineX = 10;
    float margineY = 5;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(window.width - margineX * 2, 999999)];
    self.alpha=0;
    self.frame=CGRectMake(margineX, window.origin.y - size.height, window.width - margineX * 2, size.height + margineY);
    [window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.frame=CGRectMake(margineX, window.origin.y + 64  + margineY, window.width - margineX * 2, size.height + 12);
        CGAffineTransform transform = self.transform;
        transform = CGAffineTransformScale(transform, 1,1);
        self.transform = transform;
        self.alpha=1;
    } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerCallBack) userInfo:nil repeats:NO];
    }];
}

-(void) timerCallBack{
    [timer invalidate];
    timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        CGAffineTransform transform = self.transform;
        transform = CGAffineTransformScale(transform, 1.1,1.3);
        self.transform = transform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // [self release];
    }];
}

-(void)hiddenView{
    [timer invalidate];
    timer = nil;
    [self removeFromSuperview];
}

@end
