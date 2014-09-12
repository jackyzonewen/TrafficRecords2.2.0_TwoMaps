/*!
 @header    AHSingleSelectView.h
 @abstract  单个Table浮出效果的选择列表
 @author    张洁
 @version   2.5.0 2013/04/19 Creation
 */

#import "AHSingleSelectView.h"
#import "UIView+ViewFrameGeometry.h"
#import "AHMultiViewCell.h"


@implementation AHSingleSelectView

@synthesize instructionImage;
@synthesize backGroundView;


- (id)initWithRadioSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom
{
    self = [super initWithRadioSelectStyle:style initFrame:frame tableInsetBottom:insetBottom];
    if (self)
    {
        [self initBackground];
        //[self initInstructionView];
    }
    return self;
}


- (id)initWithMultiSelectStyle:(UITableViewStyle)style initFrame:(CGRect)frame tableInsetBottom:(NSInteger)insetBottom
{
    self = [super initWithMultiSelectStyle:style initFrame:frame tableInsetBottom:insetBottom];
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
    backGroundView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [backGroundView setBackgroundColor:[UIColor blackColor]];
    [backGroundView setAlpha:0.7];
    
    //[backGroundView addTarget:self action:@selector(performClose) forControlEvents:UIControlEventTouchUpInside];
    
    backGroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [self insertSubview:backGroundView atIndex:0];
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







