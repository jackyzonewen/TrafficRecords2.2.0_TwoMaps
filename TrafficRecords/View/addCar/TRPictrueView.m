//
//  XMPictrueView.m
//  XMXiangMai
//
//  Created by Kevin Zhang on 12-11-19.
//  Copyright (c) 2012年 Kevin Zhang. All rights reserved.
//

#import "TRPictrueView.h"

@implementation TRPictrueView

-(id) initWithImage:(NSString*) imageName{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [TRSkinManager colorWithInt:0x40000000];
        
        UIImage *image = TRImage(imageName);
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - image.size.width/2, 44 + (frame.size.height - 44 ) / 2 - image.size.height/2, image.size.width, image.size.height)];
        [self addSubview:view];
        view.image = image;
        imageView = view;
    }
    return self;
}

-(id) initWithImage2:(UIImage*) imageName{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [TRSkinManager colorWithInt:0x40000000];
        
        UIImage *image = imageName;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - image.size.width/2, 44 + (frame.size.height - 44 ) / 2 - image.size.height/2, image.size.width, image.size.height)];
        [self addSubview:view];
        view.image = image;
        imageView = view;
    }
    return self;
}

-(void) setFrame:(CGRect) aframe{
    [super setFrame:aframe];
    if (imageView) {
        float widthscale = imageView.image.size.width/aframe.size.width;
        float heightscale = imageView.image.size.height/aframe.size.height;
        CGSize imageSize = aframe.size;
        if (widthscale < heightscale) {
            imageSize.width = imageView.image.size.width/heightscale;
            imageSize.height = aframe.size.height;
        } else {
            imageSize.height = imageView.image.size.height/widthscale;
            imageSize.width = aframe.size.width;
        }
        imageView.frame = CGRectMake(self.width/2 - imageSize.width/2, self.height/2 - imageSize.height/2, imageSize.width, imageSize.height);
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
//        UITouch* touch = [touches anyObject];
//        if (imageView.superview == self) {
//            CGPoint pos = [touch locationInView:self];
//            if (CGRectContainsPoint(imageView.frame, pos) == NO) {
//                [self hiddenView];
//            }
//        } else {
//            [self hiddenView];
//        }
        [self hiddenView];
    }
    isDraged = NO;
}

@end
