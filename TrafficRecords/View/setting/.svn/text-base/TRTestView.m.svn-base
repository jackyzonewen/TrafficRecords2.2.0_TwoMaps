//
//  TRTestView.m
//  TrafficRecords
//
//  Created by qiao on 14-5-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRTestView.h"

@implementation TRTestView

@synthesize contentArray;
@synthesize pageControl;

- (void)createContent
{
    self.contentArray = [NSMutableArray array];
    UIImage *image = TRImage(@"test.png");
    itemSize = image.size;
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageview1];
    [contentArray addObject:imageview1];
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageview2];
    [contentArray addObject:imageview2];
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageview3];
    [contentArray addObject:imageview3];
    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageview4];
    [contentArray addObject:imageview4];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.userInteractionEnabled = YES;
        
        [self createContent];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 45, self.width, 45)];
        self.pageControl.numberOfPages = contentArray.count;
        [self addSubview:self.pageControl];
        
        centerIndex = 1;
        [self layoutCotentView];
        // Initialization code
    }
    return self;
}

-(void) layoutCotentView{
    self.pageControl.currentPage = centerIndex;
    float centerGap = self.width/2;
    float moveLen = currentPoint.x - startPoint.x;
    CGPoint firstCenter = CGPointMake(self.center.x - centerIndex * centerGap + moveLen, 88);
    for (int i = 0; i < contentArray.count; i++) {
        CGPoint center = CGPointMake(firstCenter.x + i * centerGap, firstCenter.y);
        float len = ABS(center.x - self.center.x);
        float scale = 1;
        if (len != 0) {
            scale = 1 / (len/centerGap + 1);
        }
        UIView *view = [contentArray objectAtIndex:i];
        view.frame = CGRectMake(center.x - itemSize.width * scale / 2, center.y - itemSize.height * scale / 2, itemSize.width * scale, itemSize.height * scale);
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:self];
    currentPoint = startPoint;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
    [self layoutCotentView];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
    float len = currentPoint.x - startPoint.x;
    float centerGap = self.width/2;
    if (ABS(len) > centerGap/2) {
        //滑动了1/2以上   index改变
        if (len > 0) {
            centerIndex --;
        } else {
            centerIndex ++;
        }
        if (centerIndex < 0) {
            centerIndex = 0;
        } else if(centerIndex >= contentArray.count - 1){
            centerIndex = contentArray.count - 1;
        }
    }
    startPoint = CGPointZero;
    currentPoint = startPoint;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutCotentView];
    }];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
    float len = currentPoint.x - startPoint.x;
    float centerGap = self.width/2;
    if (ABS(len) > centerGap/2) {
        //滑动了1/2以上   index改变
        if (len > 0) {
            centerIndex --;
        } else {
            centerIndex ++;
        }
        if (centerIndex < 0) {
            centerIndex = 0;
        } else if(centerIndex > contentArray.count){
            centerIndex = contentArray.count - 1;
        }
    }
    startPoint = CGPointZero;
    currentPoint = startPoint;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutCotentView];
    }];
}

@end
