//
//  AHToastView.m
//  Autohome
//
//  Created by 王俊 on 12-12-3.
//  Copyright (c) 2012年 autohome. All rights reserved.
//

#import "AHToastView.h"
#import <QuartzCore/QuartzCore.h>
static CGFloat maxHeight = 130.0;

@implementation AHToastView
@synthesize color = _color;
@synthesize iconSize;
@synthesize bottomEdge;

- (id) init {
    self = [super init];
    if (self) {
        [self setupSubviews];
        bottomEdge = 30;
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        bottomEdge = 60;
        [self setupSubviews];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        bottomEdge = 60;
        [self setupSubviews];
    }
    return self;
}

- (id)initWithWidth:(CGFloat)width target:(UIView *)_target {
    target=_target;
    return [self initWithFrame:CGRectMake(0.0, 0.0, width, 98.0)];
}

- (id)initWithTitle:(NSString *)title detail:(NSString *)detail target:(UIView *)_target
{
    target=_target;
    CGFloat defaultWidth = 250.0;
    CGFloat detailHeight = [[self detail] sizeWithFont:[_detailLabel font] constrainedToSize:CGSizeMake(defaultWidth-60.0, maxHeight-48.0) lineBreakMode:[_detailLabel lineBreakMode]].height;
    if (detailHeight < 20)
        detailHeight = 20.0;
    CGFloat notifHeight = detailHeight + 48.0;
    self = [self initWithFrame:CGRectMake(0.0, 0.0, defaultWidth, notifHeight)];
    if (self) {
        self.title=title;
        self.detail=detail;
        [_iconView setImage:[UIImage imageNamed:@"NetworkTips"]];
        self.color=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:65/255.0 alpha:1.0];
    }
    self.width=225;
    self.bottomEdge = 60;
    self.iconSize=CGSizeMake(30, 30);
    self.bottomEdge = 60;
    return self;
}

- (void) setupSubviews {
    // Initialization code
    self.layer.cornerRadius = 8;
    self.backgroundColor = [TRSkinManager colorWithInt:KTransBgColor];
//    self.color = [UIColor blackColor];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 17.0, 40.0, 40.0)];
    _iconView.clipsToBounds = YES;
    _iconView.layer.cornerRadius = 8.0;
    _iconView.backgroundColor = [UIColor clearColor];
    [self addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 4.0, self.frame.size.width-60.0, 24.0)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.shadowColor = [UIColor blackColor];
    _titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 30.0, self.frame.size.width-60.0, 20.0)];
    _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = [UIColor whiteColor];
//    _detailLabel.shadowColor = [UIColor whiteColor];
//    _detailLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _detailLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _detailLabel.numberOfLines = 0;
    [self addSubview:_detailLabel];
}

- (void) setColor:(UIColor *)color {
   _color = nil;
    _color = color;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor* border = [_color colorWithAlphaComponent:0.6];
    UIColor* topColor = [self lightenColor:border value:0.37];
    UIColor* midColor = [self lightenColor:border value:0.1];
    UIColor* bottomColor = [self lightenColor:border value:0.12];
    
    NSArray* newGradientColors = [NSArray arrayWithObjects:
                                  (id)topColor.CGColor,
                                  (id)midColor.CGColor,
                                  (id)border.CGColor,
                                  (id)border.CGColor,
                                  (id)bottomColor.CGColor, nil];
    CGFloat newGradientLocations[] = {0, 0.500, 0.501, 0.66, 1};
    
    CGGradientRelease(_gradient);
    _gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)newGradientColors, newGradientLocations);
    CGColorSpaceRelease(colorSpace);
    [self setNeedsDisplay];
}
-(void)setIconSize:(CGSize)_iconSize{
    
    _iconView.frame=CGRectMake(_iconView.frame.origin.x, _iconView.frame.origin.y, _iconSize.width, _iconSize.height);
}
- (UIColor *) color {
    return _color;
}

- (void) setIcon:(UIImage *)icon {
    if (_iconView) {
        [_iconView setImage:icon];
    }
}
- (UIImage *) icon {
    return [_iconView image];
}

- (void) setTitle:(NSString *)title {
    [_titleLabel setText:title];
}
- (NSString *)title {
    return [_titleLabel text];
}

- (void) setDetail:(NSString *)detail {
    [_detailLabel setText:detail];
    [self updateHeight];
}
- (NSString*)detail {
    return [_detailLabel text];
}

- (void) setWidth:(CGFloat)width {
    CGRect f = self.frame;
    f.size.width = width;
    [self setFrame:f];
    [self updateHeight];
}
- (CGFloat) width {
    return self.bounds.size.width;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    UIColor* border = [_color colorWithAlphaComponent:0.6];
//    
//    //// Shadow Declarations
//    UIColor* shadow = [self lightenColor:border value:0.65];
//    CGSize shadowOffset = CGSizeMake(0, 2);
//    CGFloat shadowBlurRadius = 0;
//    UIColor* shadow2 = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//    CGSize shadow2Offset = CGSizeMake(0.0, 2.0);
//    CGFloat shadow2BlurRadius = 4.0;
//    
//    //// Rounded Rectangle Drawing
//    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(4.5, 2.5, rect.size.width-8.0, rect.size.height-8.0) cornerRadius: 10];
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
//    CGContextSetFillColorWithColor(context, shadow2.CGColor);
//    [roundedRectanglePath fill];
//    [roundedRectanglePath addClip];
//    CGContextDrawLinearGradient(context, _gradient, CGPointMake(0.0, 2.5), CGPointMake(0.0, rect.size.height-5.5), 0);
//    
//    ////// Rounded Rectangle Inner Shadow
//    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
//    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
//    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
//    
//    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
//    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
//    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
//    
//    CGContextSaveGState(context);
//    {
//        CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
//        CGFloat yOffset = shadowOffset.height;
//        CGContextSetShadowWithColor(context,
//                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
//                                    shadowBlurRadius,
//                                    shadow.CGColor);
//        
//        [roundedRectanglePath addClip];
//        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
//        [roundedRectangleNegativePath applyTransform: transform];
//        [[UIColor grayColor] setFill];
//        [roundedRectangleNegativePath fill];
//    }
//    CGContextRestoreGState(context);
//    
//    CGContextRestoreGState(context);
//    
//    [border setStroke];
//    roundedRectanglePath.lineWidth = 1;
//    [roundedRectanglePath stroke];
//}


- (UIColor *)lightenColor:(UIColor *)oldColor value:(float)value {
    size_t   totalComponents = CGColorGetNumberOfComponents(oldColor.CGColor);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(oldColor.CGColor);
    CGFloat newComponents[4];
    
    if (isGreyscale) {
        newComponents[0] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[1] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[2] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]+value > 1.0 ? 1.0 : oldComponents[0]+value;
        newComponents[1] = oldComponents[1]+value > 1.0 ? 1.0 : oldComponents[1]+value;
        newComponents[2] = oldComponents[2]+value > 1.0 ? 1.0 : oldComponents[2]+value;
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
    return retColor;
}

- (void) updateHeight {
    CGRect f = self.frame;
    CGFloat detailHeight = [[self detail] sizeWithFont:[_detailLabel font] constrainedToSize:CGSizeMake(f.size.width-60.0, maxHeight-48.0) lineBreakMode:[_detailLabel lineBreakMode]].height;
    if (detailHeight < 20)
        detailHeight = 20.0;
    f.size.height = detailHeight + 40.0;
    self.frame = f;
    _iconView.center=CGPointMake(_iconView.center.x,self.center.y+2);
    [_detailLabel setFrame:CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y, f.size.width-60.0, detailHeight)];
}

- (void) dealloc {
    [self removeFromSuperview];
    CGGradientRelease(_gradient);
}

-(void)animationByType:(enum AnimationType)type delayTime:(NSInteger)time{
    if (type==AnimationDefault) {
        self.alpha=0;
        CGRect frame= self.frame;
        frame.origin.y=target.frame.size.height+10;
        self.frame=frame;
        self.center=CGPointMake(target.center.x, self.center.y);
        [target addSubview:self];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame= self.frame;
            frame.origin.y=target.frame.size.height-self.frame.size.height - bottomEdge;
            self.frame=frame;
            CGAffineTransform transform = self.transform;
            transform = CGAffineTransformScale(transform, 1,1);
            self.transform = transform;
            self.alpha=1;
        } completion:^(BOOL finished) {
            timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerCallBack) userInfo:nil repeats:NO];
        }];
    }
}

-(void) timerCallBack{
    [timer invalidate];
    timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        CGAffineTransform transform = self.transform;
        transform = CGAffineTransformScale(transform, 1.1,1.3);
        self.transform = transform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // [self release];
    }];
}

-(void)hiddenView{
    [timer invalidate];
    timer = nil;
    [self removeFromSuperview];
}

-(void)showDelayTime:(NSInteger)time andAnimationType:(enum AnimationType)type{
    [self animationByType:type delayTime:time];
}

-(void)show{
     [self animationByType:AnimationDefault delayTime:2.0];
}
@end
