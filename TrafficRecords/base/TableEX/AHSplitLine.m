/*!
 @header    AHSplitLine.m
 @abstract  普通分隔线
 @author    兰春红
 @version   2.1.0 2012/11/02 Creation
 */

#import "AHSplitLine.h"

@implementation AHSplitLine

@synthesize firstLine;
@synthesize secondLine;


- (id)init
{
    if (self=[super init])
    {
        [self initSplitLineFirstLineColor:nil secondLineColor:nil];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame orientation:(NSInteger)orientation firstLineColor:(UIColor *)firstColor secondLineColor:(UIColor *)secondColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSplitLineFirstLineColor:firstColor secondLineColor:secondColor];
        int width;
        if (orientation==Landscape)
        {
            width=frame.size.width;
        }else
        {
            width=frame.size.height;
        }
        [self setLineWidth:width orientation:orientation];
        
    }
    return self;
}


- (void)initSplitLineFirstLineColor:(UIColor *)firstColor secondLineColor:(UIColor *)secondColor
{
    firstLine = [[UIView alloc] init];
    [self addSubview:firstLine];
    
    secondLine = [[UIView alloc] init];
    [self addSubview:secondLine];
    
    [self setFirstLineColor:firstColor secondLineColor:secondColor];
}


- (void)setLineWidth:(float)width orientation:(NSInteger)orientation
{
    if (orientation==Landscape)//水平分隔线
    {
        firstLine.frame=CGRectMake(0, 0, width, 1);
        secondLine.frame=CGRectMake(0, 1, width, 1);
        
    }else if(orientation==Portrait)//纵向分隔线
    {
        firstLine.frame=CGRectMake(0, 0, 1, width);
        secondLine.frame=CGRectMake(1, 0, 0.5, width);
    }
}

- (void)setFirstLineColor:(UIColor *)firstColor secondLineColor:(UIColor *)secondColor
{
    if(firstColor&&secondColor)
    {
        [firstLine setBackgroundColor:firstColor];
        [secondLine setBackgroundColor:secondColor];
        
    }else
    {
        [firstLine setBackgroundColor:[TRSkinManager borderColor]];
        [secondLine setBackgroundColor:[TRSkinManager borderColor]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
