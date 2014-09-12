//
//  CallOutAnnotationVifew.m
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 8

@interface CallOutAnnotationView ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationView
@synthesize contenText;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;

        
    }
    return self;
}

-(void) setContenText:(NSString *) aContenText{
    contenText = nil;
    contenText = aContenText;
    CGSize size = [aContenText sizeWithFont:[UIFont systemFontOfSize:14]];
    if (size.width < 300) {
        size.width += 12;
        if (size.width < 130) {
            size.width = 130;
        } else if (size.width > 300) {
            size.width = 300;
        }
        size.height = 42 + Arror_height;
    } else {
        size = [aContenText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(286, 999999)];
        size.height += 16 + Arror_height;
    }
    self.frame = CGRectMake(0, 0, size.width, size.height);
    self.centerOffset = CGPointMake(0, -size.height/2 - 20);
//    UIImage *bgImage = [TRImage(@"calloutViewBg.png") stretchableImageWithLeftCapWidth:28 topCapHeight:3];
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
//    bgView.image = bgImage;
//    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    [self addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, size.width - 12, size.height - Arror_height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = contenText;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
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
