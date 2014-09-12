//
//  TRScrollCarView.m
//  TrafficRecords
//
//  Created by qiao on 14-5-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRScrollCarView.h"

#define KGapOfTwoItem 155

@implementation TRScrollCarView

@synthesize carNumArray;
@synthesize contentArray;
@synthesize pageControl;
@synthesize limitBgView;
@synthesize limitLabel;
@synthesize delegate;

- (void)createContent
{
    self.contentArray = [NSMutableArray array];
    
    UIImage *image = TRImage(@"limitCar.png");
    
    for (NSString *carnum in carNumArray) {
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        bgView1.backgroundColor = [UIColor clearColor];
        UIImageView *imageview1 = [[UIImageView alloc] initWithImage:image];
        imageview1.frame = CGRectMake(bgView1.center.x - image.size.width/2 + 10, 76, image.size.width, image.size.height);
        [bgView1 addSubview:imageview1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.bottom - 20, bgView1.width, 22)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [TRSkinManager mediumFont3];
        label.textColor = [TRSkinManager textColorWhite];
        label.text = carnum;
        label.textAlignment = NSTextAlignmentCenter;
        [bgView1 addSubview:label];
        [self addSubview:bgView1];
        [contentArray addObject:bgView1];
    }
}

- (id)initWithFrame:(CGRect)frame carnums:(NSArray *) carNums
{
    self = [super initWithFrame:frame];
    if (self) {
        self.carNumArray = carNums;
        self.backgroundColor = [TRSkinManager colorWithInt:0x2c92db];
        self.userInteractionEnabled = YES;
//        self.exclusiveTouch = YES;
        
        [self createContent];
        UIImage *mask = [TRUtility centeRoundImage:[TRSkinManager colorWithInt:0xf5f2f0] size: frame.size rect:CGRectMake(frame.size.width/2 - 70, 20, 140, 140)];
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mask.size.width, mask.size.height)];
        maskView.image = mask;
        [self addSubview:maskView];
//        maskView.userInteractionEnabled = NO;
        
        self.limitBgView = [[UIImageView alloc] initWithImage:TRImage(@"limitBg2.png")];
        [self.limitBgView setTop:21];
        [self.limitBgView setLeft:190];
        [self addSubview:limitBgView];
        self.limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(limitBgView.width/2 - 16, 0, 32, limitBgView.height)];
        limitLabel.backgroundColor = [UIColor clearColor];
        limitLabel.font = [TRSkinManager smallFont2];
        limitLabel.textColor = [TRSkinManager textColorWhite];
        limitLabel.text = @"今日限行";
        limitLabel.numberOfLines = 0;
        limitLabel.textAlignment = NSTextAlignmentCenter;
        [limitBgView addSubview:limitLabel];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 45, self.width, 45)];
        self.pageControl.numberOfPages = contentArray.count;
        [self addSubview:self.pageControl];
        if ([pageControl respondsToSelector:@selector(pageIndicatorTintColor)]) {
            self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
            self.pageControl.currentPageIndicatorTintColor = [TRSkinManager colorWithInt:0xdb325a];
        }
        self.pageControl.userInteractionEnabled = NO;
        [self layoutCotentView];
        
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];
        // Initialization code
    }
    return self;
}

-(void) setCurrentIndex:(NSUInteger) index{
    if (index < contentArray.count) {
        centerIndex = index;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutCotentView];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    CGPoint currentTouchPoint = [recognizer locationInView:self];
//    CGPoint velocity = [recognizer velocityInView:self.contentView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = currentTouchPoint;
        currentPoint = startPoint;
    } else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        currentPoint = currentTouchPoint;
        [self layoutCotentView];
    } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        currentPoint = currentTouchPoint;
        float len = currentPoint.x - startPoint.x;
        float centerGap = KGapOfTwoItem;
        if (ABS(len) > centerGap/2) {
            //滑动了1/2以上   index改变
            int lastindex = centerIndex;
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
            if (lastindex != centerIndex && delegate && [delegate respondsToSelector:@selector(indexChanged:)]) {
                [delegate indexChanged:centerIndex];
            }
        }
        startPoint = CGPointZero;
        currentPoint = startPoint;
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutCotentView];
        }];
    }
}

-(void) layoutCotentView{
    self.pageControl.currentPage = centerIndex;
    float centerGap = KGapOfTwoItem;
    float moveLen = currentPoint.x - startPoint.x;
    CGPoint firstCenter = CGPointMake(self.center.x - centerIndex * centerGap + moveLen, 54);
    for (int i = 0; i < contentArray.count; i++) {
        CGPoint center = CGPointMake(firstCenter.x + i * centerGap, firstCenter.y);
        UIView *view = [contentArray objectAtIndex:i];
        view.frame = CGRectMake(center.x - view.width / 2, center.y - view.height  / 2, view.width , view.height );
    }
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
//    UITouch *touch = [touches anyObject];
//    startPoint = [touch locationInView:self];
//    currentPoint = startPoint;
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//     NSLog(@"touchesMoved");
//    UITouch *touch = [touches anyObject];
//    currentPoint = [touch locationInView:self];
//    [self layoutCotentView];
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesEnded");
//    UITouch *touch = [touches anyObject];
//    currentPoint = [touch locationInView:self];
//    float len = currentPoint.x - startPoint.x;
//    float centerGap = KGapOfTwoItem;
//    if (ABS(len) > centerGap/2) {
//        //滑动了1/2以上   index改变
//        if (len > 0) {
//            centerIndex --;
//        } else {
//            centerIndex ++;
//        }
//        if (centerIndex < 0) {
//            centerIndex = 0;
//        } else if(centerIndex >= contentArray.count - 1){
//            centerIndex = contentArray.count - 1;
//        }
//    }
//    startPoint = CGPointZero;
//    currentPoint = startPoint;
//    [UIView animateWithDuration:0.2 animations:^{
//        [self layoutCotentView];
//    }];
//}
//
//-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesCancelled");
//    UITouch *touch = [touches anyObject];
//    currentPoint = [touch locationInView:self];
//    float len = currentPoint.x - startPoint.x;
//    float centerGap = KGapOfTwoItem;
//    if (ABS(len) > centerGap/2) {
//        //滑动了1/2以上   index改变
//        if (len > 0) {
//            centerIndex --;
//        } else {
//            centerIndex ++;
//        }
//        if (centerIndex < 0) {
//            centerIndex = 0;
//        } else if(centerIndex > contentArray.count){
//            centerIndex = contentArray.count - 1;
//        }
//    }
//    startPoint = CGPointZero;
//    currentPoint = startPoint;
//    [UIView animateWithDuration:0.2 animations:^{
//        [self layoutCotentView];
//    }];
//}


@end
