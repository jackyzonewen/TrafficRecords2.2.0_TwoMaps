//
//  TRImageView.m
//  TrafficRecords
//
//  Created by qiao on 13-11-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRImageView.h"

@implementation TRImageView

@synthesize cornerRadius;

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    cornerRadius = 10;
    return self;
}

-(id) initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    cornerRadius = 10;
    return self;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
//    self.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
//    self.layer.shadowOpacity = 0.3;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, self.height - 1)];
//    [path addLineToPoint:CGPointMake(self.width - 1, self.height - 1)];
//    [path addLineToPoint:CGPointMake(self.width - 1,  1)];
//    [path stroke];
//    self.layer.shadowPath = path.CGPath;
    if (cornerRadius == 0) {
        cornerRadius = 10;
    }
    UIImage *other = [TRUtility image:image withCornerRadius:cornerRadius < 0 ? image.size.width/2 : cornerRadius];
    self.image = other;
	if(_animated)
	{
        CATransition *animation = [CATransition animation];
		[animation setDuration:0.9f];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		[animation setType:kCATransitionFade];
		[animation setSubtype: kCATransitionFromBottom];
		[self.layer addAnimation:animation forKey:@"Reveal"];
	}
}

@end
