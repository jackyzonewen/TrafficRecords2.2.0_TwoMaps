/*!
 @header    AHMultiViewCell.m
 @abstract  多样选择的View的cell
 @author    张洁
 @version   2.5.0 2013/04/17 Creation
 */

#import "AHMultiViewCell.h"
//#import "Constants.h"


@implementation AHMultiViewCell

@synthesize selectView;
@synthesize isSelected;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellFrame:frame];
    if (self)
    {
        self.frame = frame;
        isSelected = NO;
        
        UIImage * select = [UIImage imageNamed:@"CheckSel.png"];
        self.selectView = [[UIImageView alloc] initWithImage:select];
        selectView.frame = CGRectMake(self.frame.size.width - selectView.frame.size.width - 35, (self.frame.size.height - selectView.frame.size.height) / 2, selectView.frame.size.width, selectView.frame.size.height);
        selectView.hidden = YES;
        [self addSubview:selectView];
        [self.accessoryView setHidden:YES];
        [self.textLabel setHighlightedTextColor:[UIColor blackColor]];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    selectView.frame = CGRectMake(self.frame.size.width - selectView.frame.size.width - 35, (self.frame.size.height - selectView.frame.size.height) / 2, selectView.frame.size.width, selectView.frame.size.height);
}

-(void) setIsSelected:(BOOL)aSelected{
    isSelected = aSelected;
    selectView.hidden = !isSelected;
    [self bringSubviewToFront:selectView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    isSelected = selected;

}


+ (CGFloat)getCellDefaultHeight
{
    return 40;
}


- (void)dealloc
{
    self.selectView = nil;
}

@end
