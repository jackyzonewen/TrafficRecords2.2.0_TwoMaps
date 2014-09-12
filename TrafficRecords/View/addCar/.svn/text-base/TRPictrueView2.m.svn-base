//
//  TRPictrueView2.m
//  TrafficRecords
//
//  Created by qiao on 14-5-21.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRPictrueView2.h"

@implementation TRPictrueView2

-(id) initTitle:(NSString *)title content:(NSString *) content URL:(NSString *) url{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame: frame];
    if (self) {
        regUrl = url;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [TRSkinManager colorWithInt:0x40000000];
        UIFont *contentFont = [TRSkinManager mediumFont3];
        float height = [content sizeWithFont:contentFont constrainedToSize:CGSizeMake(274, 9999999)].height;
        height = (height/contentFont.lineHeight) * 32 + 38 * 2;
        bgH = height;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 302, height)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 4;
        bgView.layer.borderColor = [TRSkinManager colorWithInt:0x000000].CGColor;
        bgView.layer.borderWidth = 1;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 274, 38)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [TRSkinManager colorWithInt:0x666666];
        titleLabel.font = [TRSkinManager mediumFont3];
        [bgView addSubview:titleLabel];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, bgView.width, [TRUtility lineHeight])];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        line.backgroundColor = [TRSkinManager colorWithInt:0xcacaca];
        [bgView addSubview:line];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, titleLabel.bottom, 274, height - 38 *2)];
        contentLabel.text = content;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = [TRSkinManager colorWithInt:0x999999];
        contentLabel.font = contentFont;
        contentLabel.numberOfLines = 0;
        [bgView addSubview:contentLabel];
        
        bottomLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(14, contentLabel.bottom, 146, 38)];
        bottomLabel1.text = @"还没有账号，现在去";
        bottomLabel1.backgroundColor = [UIColor clearColor];
        bottomLabel1.textColor = [TRSkinManager colorWithInt:0x999999];
        bottomLabel1.font = [TRSkinManager mediumFont3];
        [bgView addSubview:bottomLabel1];
        
        bottomLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(bottomLabel1.right, contentLabel.bottom, 36, 38)];
        bottomLabel2.text = @"注册";
        bottomLabel2.backgroundColor = [UIColor clearColor];
        bottomLabel2.textColor = [TRSkinManager colorWithInt:0x627aaf];
        bottomLabel2.font = [TRSkinManager mediumFont3];
        [bgView addSubview:bottomLabel2];
        
        UIGraphicsBeginImageContextWithOptions(bgView.frame.size, NO, [TRUtility deviceIsHDScreen] ? 2.0:1.0);
        [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - image.size.width/2, 44 + (frame.size.height - 44 ) / 2 - image.size.height/2, image.size.width, image.size.height)];
        [self addSubview:view];
        view.image = image;
        imageView = view;
        imageView.userInteractionEnabled = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor blueColor];
        btn.frame = CGRectMake(0, view.height - 38, 302, 38);
        [view addSubview:btn];
        [btn addTarget:self action:@selector(openUrl:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10023;
    }
    return self;
}

-(void) openUrl:(id) sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:regUrl]];
}

-(void) setFrame:(CGRect) aframe{
    [super setFrame:aframe];
    if (imageView) {
        float scale = bgH/[[UIScreen mainScreen] bounds].size.height;
        float newH = scale * self.height;
        imageView.frame = CGRectMake(self.width * 9/320.0, self.height/2 -  newH/2, self.width * 302/320.0, newH);
        UIButton *btn = (UIButton *)[imageView viewWithTag:10023];
        if (btn) {
            btn.frame = CGRectMake(0, imageView.height - 38, 302, 38);
        }
    }
}

-(void) show{
    [[TRAppDelegate appDelegate].window addSubview:self];
}

-(void) showAtFrame:(CGRect) rect{
    self.frame = rect;
    initRect = rect;
    
    [[TRAppDelegate appDelegate].window addSubview:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.frame = frame;
    [UIView commitAnimations];
}

-(void) hiddenView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = initRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    isDraged = YES;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (isDraged == NO) {
        [self hiddenView];
    }
    isDraged = NO;
}


@end
