//
//  LoadingView.m
//  TrafficRecords
//
//  Created by qiao on 13-9-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGSize size = CGSizeMake(210, 210);
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - size.width/2, frame.size.height/2 - size.height/2, size.width, size.height)];
        view.backgroundColor = [TRSkinManager colorWithInt:KTransBgColor];
        view.layer.cornerRadius = 6;
        [self addSubview:view];
        //总共21张
        NSString *imageName = [NSString stringWithFormat:@"loading%d.png", count%21 + 1];
        UIImage *image = TRImage(imageName);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width/2 - image.size.width/2, 26, image.size.width, image.size.height)];
        [view addSubview:imageView];
        imageView.image = image;
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, imageView.bottom + 12, 120, 44)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[TRSkinManager textColorWhite]];
        [textLabel setFont:[TRSkinManager mediumFont2]];
        textLabel.text = @"正在读取.";
        [view addSubview:textLabel];
        
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];//创建对象，指定首次启动的时间
        myTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:0.075 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void) runTime{
    count ++;
    NSString *imageName = [NSString stringWithFormat:@"loading%d.png", count%21 + 1];
    UIImage *image = TRImage(imageName);
    imageView.image = image;
    int textnum = count%60;
    if (textnum < 20) {
        textLabel.text = @"正在读取.";
    } else if(textnum < 40){
        textLabel.text = @"正在读取..";
    } else {
        textLabel.text = @"正在读取...";
    }
}

-(void) removeFromSuperview{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
    [super removeFromSuperview];
}

@end
