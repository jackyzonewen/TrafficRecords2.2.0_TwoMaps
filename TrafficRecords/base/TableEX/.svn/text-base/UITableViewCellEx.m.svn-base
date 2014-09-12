/*!
 @header    UITableViewCellEx.m
 @abstract  封装下划线及Cell的点击效果
 @author    兰春红
 @version   2.1.0 2012/11/02 Creation
 */

#import "UITableViewCellEx.h"

@implementation UITableViewCellEx



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame=frame;
        [self drawCell];
    }
    return self;
}





- (void)drawCell{

//    
//    //默认与当前cell一样宽,并位于cell的最下面
//    [self setSplitLineFrame:CGRectMake(self.frame.origin.x, self.frame.size.height-1, self.frame.size.width, 1)];
//    splitLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [self addSubview:splitLine];
//    
//

    
    UIView *cellSelectedimageView = [[UIView alloc] initWithFrame:self.bounds];
    cellSelectedimageView.backgroundColor = [TRSkinManager colorWithInt:0xf0f0f0];
    cellSelectedimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.selectedBackgroundView=cellSelectedimageView;
};

-(void) layoutSubviews{
    [super layoutSubviews];
    UIView * line = [self viewWithTag:10100];
    line.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
