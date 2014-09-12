//
//  TRLoadingView.m
//  TrafficRecords
//
//  Created by qiao on 14-3-24.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRLoadingView.h"

@implementation TRLoadingView
{
    float                   angle;
    NSTimer                 *myTimer;
    float                   myInterval;
}

@synthesize circleLayer;
@synthesize centerImage;

-(id) initWithParentView:(UIView *) parent{
    self = [super init];
    if (self) {
        [self construct:parent];
    }
    return self;
}
//构建视图
-(void) construct:(UIView *) parent
{
    myInterval = 0.02;
    self.frame = parent.bounds;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    angle = 0;
    
    UIImage *image = TRImage(@"loading_circle.png");
    self.circleLayer = [CALayer layer];
    circleLayer.frame = CGRectMake(self.width/2 - image.size.width/2, self.height/2 - image.size.height/2, image.size.width, image.size.height);
    circleLayer.contentsGravity = kCAGravityResizeAspect;
    circleLayer.contents = (id)image.CGImage;
    [self.layer addSublayer:self.circleLayer];
    
    image = TRImage(@"loading_center.png");
    self.centerImage = [[UIImageView alloc] initWithImage:image];
    self.centerImage.frame = CGRectMake(self.width/2 - image.size.width/2, self.height/2 - image.size.height/2, image.size.width, image.size.height);
    [self addSubview:centerImage];
    [parent addSubview:self];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (circleLayer) {
        circleLayer.frame = CGRectMake(self.width/2 - circleLayer.frame.size.width/2, self.height/2 - circleLayer.frame.size.height/2, circleLayer.frame.size.width, circleLayer.frame.size.height);
    }
    if (centerImage) {
        centerImage.frame = CGRectMake(self.width/2 - centerImage.width/2, self.height/2 - centerImage.height/2, centerImage.width, centerImage.height);
    }
}

-(void) start{
    [self startWithInterval:myInterval];
}

-(void) startWithInterval:(float) interval{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
    myInterval = interval;
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];//创建对象，指定首次启动的时间
    myTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:interval target:self selector:@selector(runl) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
}

-(void) stop{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}

-(void) removeFromSuperview{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
    [super removeFromSuperview];
}

-(void) runl{
    if ([CATransaction disableActions]) {
        [CATransaction setDisableActions:NO];
    }
    angle += 0.1;
    circleLayer.transform =  CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
}

-(void) dealloc
{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}

-(void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        [self stop];
    } else {
        [self startWithInterval:myInterval];
    }
}

@end
