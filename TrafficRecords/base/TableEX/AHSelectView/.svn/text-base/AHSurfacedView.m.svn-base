/*!
 @header    AHSurfacedView.m
 @abstract  浮出效果的View
 @author    张洁
 @version   2.5.0 2013/04/19 Creation
 */

#import "AHSurfacedView.h"
#import "UIView+ViewFrameGeometry.h"


@interface AHSurfacedView()
{
}

/*!
 @property
 @abstract 背景
 */
@property (nonatomic, weak) UIButton *backGroundView;

@end


@implementation AHSurfacedView

@synthesize instructionImage;
@synthesize backGroundView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBackground];
        //[self initInstructionView];
    }
    return self;
}


//创建指示图效果
- (void)initInstructionView
{
    instructionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RadioSel.png"]];
    instructionImage.frame = CGRectMake((self.width - instructionImage.width) / 2, 0, instructionImage.width, instructionImage.height);
    [self addSubview:instructionImage];
}


//创建半透明背景效果
- (void)initBackground
{
    UIButton * backG = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [backG setBackgroundColor:[UIColor darkGrayColor]];
    [backG setAlpha:0.5];
    
    [backG addTarget:self action:@selector(performClose) forControlEvents:UIControlEventTouchUpInside];
    
    backG.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [self addSubview:backG];
    self.backGroundView = backG;
}


- (void)performClose
{
    [self removeFromSuperview];
}


- (void)dealloc
{
    self.backGroundView = nil;
    self.instructionImage = nil;
}

@end







