//
//  UISectionTitles.m
//  TrafficRecords
//
//  Created by qiao on 13-10-28.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "UISectionTitles.h"

@implementation UISectionTitles

@synthesize selectedBgView;
@synthesize delegate;

-(id) initWith:(UIView *) view andTitles:(NSArray *) titleArray{
    UIView *superView = view.superview;
    if (superView == nil) {
        NSLog(@"UISectionTitles初始化失败");
        return nil;
    }
    float width = 32;
    CGRect rect = CGRectMake(view.right - width, view.top, width, view.height);
    self = [super initWithFrame:rect];
    if (self) {
        titles = titleArray;
        self.backgroundColor = [UIColor clearColor];
        [superView insertSubview:self aboveSubview:view];
        
        self.selectedBgView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 24, view.height)];
        self.selectedBgView.backgroundColor = [TRSkinManager colorWithInt:0x99000000];
        self.selectedBgView.layer.cornerRadius = 8;
        [self addSubview:self.selectedBgView];
        self.selectedBgView.hidden = YES;
        
        bigTitle = [[UILabel alloc] initWithFrame:view.frame];
        bigTitle.backgroundColor = [UIColor clearColor];
        bigTitle.textColor = [TRSkinManager colorWithInt:KSelectedTextColor];
        bigTitle.font = [UIFont systemFontOfSize:40];
        [bigTitle setTextAlignment:NSTextAlignmentCenter];
        [superView addSubview:bigTitle];
        bigTitle.hidden = YES;
        
    }
    return self;
}

-(void) setSelectedBgView:(UIView *)aselectedBgView{
    if (selectedBgView) {
        [selectedBgView removeFromSuperview];
        selectedBgView = nil;
    }
    selectedBgView = aselectedBgView;
    [self addSubview:selectedBgView];
}

-(void) drawRect:(CGRect)arect{
    [super drawRect:arect];
    if (titles.count == 0) {
        return;
    }
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 0.4, 0.4, 0.4, 1.0);
    
    [[TRSkinManager colorWithInt:0x666666] set];
    CGRect rect = self.frame;
    CGPoint start = CGPointZero;
    float height = rect.size.height / titles.count;
    for (NSString *text in titles) {
        [text drawInRect:CGRectMake(start.x, start.y, rect.size.width, height) withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        start.y += height;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    selectedBgView.hidden = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleEvent:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    selectedBgView.hidden = YES;
    [self handleEvent:touches];
    [self hiddenBigTitle];
//    [self performSelector:@selector(hiddenBigTitle) withObject:nil afterDelay:0.5];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    selectedBgView.hidden = YES;
    [self hiddenBigTitle];
//    [self performSelector:@selector(hiddenBigTitle) withObject:nil afterDelay:0.5];
}

-(void) hiddenBigTitle{
//    bigTitle.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        bigTitle.alpha=0;
    } completion:^(BOOL finished) {
        bigTitle.hidden = YES;
        bigTitle.alpha = 1;
    }];
}

- (void)handleEvent:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float height = self.height / titles.count;
    float index = point.y / height;
    int indexM = index;
    if (abs(index - indexM) >= 0.0001) {
        indexM ++;
    }
    if (indexM < titles.count && delegate && [delegate respondsToSelector:@selector(sectionDidSelected:title:)]) {
        [delegate sectionDidSelected:indexM title:[titles objectAtIndex:indexM]];
        bigTitle.text = [titles objectAtIndex:indexM];
        bigTitle.hidden = NO;
    }
}

@end
