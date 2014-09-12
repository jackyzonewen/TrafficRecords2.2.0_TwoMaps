//
//  CallOutAnnotationVifew.m
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "CallOutAnnotationView3.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 8

@interface CallOutAnnotationView3 ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationView3

@synthesize addresslabel;
@synthesize titlelabel;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;

        
    }
    return self;
}

-(void) setTitle:(NSString *)title Address:(NSString *)address{
    float width = 240;
    float gap = 12;
    float labelW = width - 16 * 2;
    UIFont *bigF = [UIFont systemFontOfSize:15];
    UIFont *smallF = [UIFont systemFontOfSize:14];
    CGSize size1 = [title sizeWithFont:bigF constrainedToSize:CGSizeMake(labelW, 999999)];
    CGSize size2 = [address sizeWithFont:smallF constrainedToSize:CGSizeMake(labelW, 999999)];
    float totalHeight = gap * 2 + 10 + size1.height + size2.height + Arror_height;
    self.frame = CGRectMake(0, 0, width, totalHeight);
//    self.centerOffset = CGPointMake(0, -totalHeight/2 - 80);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, gap, size1.width, size1.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = bigF;
    [self addSubview:label];
    self.titlelabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(16, label.bottom + 10, size2.width, size2.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = address;
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.font = smallF;
    [self addSubview:label];
    self.addresslabel = label;
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

-(void)drawInContext:(CGContextRef)context
{
	
   CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
   
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), 
    // midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
    

}
@end
