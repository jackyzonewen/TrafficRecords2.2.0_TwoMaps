//
//  TRPercentView.m
//  TrafficRecords
//
//  Created by qiao on 14-8-11.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRPercentView.h"
#import <math.h>



@implementation TRPercentView

@synthesize fgColor;
@synthesize bgColor;
@synthesize percent;
@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgColor = [TRSkinManager colorWithInt:0xdb325a];
        //self.bgColor = [TRSkinManager colorWithInt:0xf09609];
        self.fgColor = [TRSkinManager colorWithInt:0xe5e5e5];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x666666];
        label.font = [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.textLabel = label;
    }
    return self;
}

-(void)setPercent:(float)apercent{
    if (apercent < 0 ) {
        percent = 0;
    } else if(apercent > 1.0){
        percent = 1.0;
    }
    percent = apercent;
    NSString *text = [NSString stringWithFormat:@"%d", (int)(percent * 100)];
    text = [text stringByAppendingString:@"%"];
    self.textLabel.text = text;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
    CGContextSetLineWidth(context, 3.0);
    float radius = self.width < self.height ? self.width : self.height;
    radius /= 2.0;
    radius -= 1.5;
    float len = 2 * M_PI *  percent;
    float start = -M_PI/2;
    
    CGContextAddArc(context, self.width/2, self.height/2, radius, start, start + len , 0);
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGContextSetStrokeColorWithColor(context, fgColor.CGColor);
    CGContextAddArc(context, self.width/2, self.height/2, radius, start + len, 3 * M_PI /2 , 0);
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    // Drawing code
}


@end
