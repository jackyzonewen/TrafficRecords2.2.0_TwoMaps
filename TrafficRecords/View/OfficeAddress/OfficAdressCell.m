//
//  OfficAdressCell.m
//  TrafficRecords
//
//  Created by qiao on 14-3-13.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "OfficAdressCell.h"

@implementation OfficAdressCell

//@property (nonatomic, strong) UIImageView *bgFrameView;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *addressLabel;
//@property (nonatomic, strong) UILabel *phoneLabel;
//@property (nonatomic, strong) UIView *line2;
//@property (nonatomic, strong) UIImageView *addressIcon;
//@property (nonatomic, strong) UIImageView *phoneIcon;

@synthesize bgFrameView;
@synthesize titleLabel;
@synthesize addressLabel;
@synthesize phoneLabel;
@synthesize line1;
@synthesize line2;
@synthesize addressIcon;
@synthesize phoneIcon;
@synthesize btn1;
@synthesize btn2;
@synthesize line3;
@synthesize line4;
@synthesize cellId;
@synthesize observer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        float lineH = [TRUtility lineHeight];
        
        self.backgroundView = nil;
        self.backgroundColor = [TRSkinManager bgColorLight];
        self.bgFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 12, 292, 128)];
        bgFrameView.image = [TRImage(@"contentBg.png") stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [self addSubview:bgFrameView];
        bgFrameView.userInteractionEnabled = YES;
            
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 226, 42)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [TRSkinManager mediumFont3];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        [bgFrameView addSubview:titleLabel];
        self.line1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.height, bgFrameView.width, lineH)];
        line1.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [bgFrameView addSubview:line1];
        
        UIButton* rView = [UIButton buttonWithType:UIButtonTypeCustom];
        rView.frame = CGRectMake(0, line1.top + line1.height, bgFrameView.width, 42);
        [rView setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [rView setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager colorWithInt:0x88cccccc]] forState:UIControlStateHighlighted];
        rView.backgroundColor = [UIColor clearColor];
        [rView addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [bgFrameView addSubview:rView];
        self.btn1 = rView;
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0	, 226, 42)];
        addressLabel.textColor = [TRSkinManager colorWithInt:0x666666];
        addressLabel.font = [UIFont systemFontOfSize:15];
        addressLabel.numberOfLines = 0;
        addressLabel.backgroundColor = [UIColor clearColor];
        [self.btn1 addSubview:addressLabel];
        self.line2 = [[UIView alloc] initWithFrame:CGRectMake(15, addressLabel.height, bgFrameView.width - 15, lineH)];
        line2.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [self.btn1 addSubview:line2];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.btn1.width - 45, addressLabel.center.y- 12, lineH, 24)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [self.btn1 addSubview:line];
        self.line3 = line;
        self.addressIcon = [[UIImageView alloc] initWithImage:TRImage(@"addLocation.png")];
        addressIcon.frame = CGRectMake(line.left + 45/2 - addressIcon.width/2, addressLabel.center.y- addressIcon.height/2, addressIcon.width, addressIcon.height);
        [self.btn1 addSubview:addressIcon];

        
        rView = [UIButton buttonWithType:UIButtonTypeCustom];
        rView.frame = CGRectMake(0, self.btn1.top + self.btn1.height + line2.height, bgFrameView.width, 42);
        rView.backgroundColor = [UIColor clearColor];
        [rView setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [rView setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager colorWithInt:0x88cccccc]] forState:UIControlStateHighlighted];
        [rView addTarget:self action:@selector(btnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [bgFrameView addSubview:rView];
        self.btn2 = rView;
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 42)];
        phoneLabel.textColor = [TRSkinManager colorWithInt:0x666666];
        phoneLabel.font = [UIFont systemFontOfSize:15];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.numberOfLines = 0;
        [self.btn2 addSubview:phoneLabel];
        line = [[UIView alloc] initWithFrame:CGRectMake(self.btn1.width - 45, phoneLabel.center.y- 12, lineH, 24)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [self.btn2 addSubview:line];
        self.phoneIcon = [[UIImageView alloc] initWithImage:TRImage(@"phone.png")];
        phoneIcon.frame = CGRectMake(line.left + 45/2 - phoneIcon.width/2, phoneLabel.center.y- phoneIcon.height/2, phoneIcon.width, phoneIcon.height);
        [self.btn2 addSubview:phoneIcon];
        self.line4 = line;
    }
    return self;
}


-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self changeLayOut];
}

-(void) changeLayOut{
    CGRect frame = self.frame;
    if (frame.size.width !=0 && frame.size.height != 0 && titleLabel && addressLabel) {
        CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(999999, titleLabel.font.lineHeight)];
        if (size.width <= 0) {
            size.width = 1;
        }
        int lineCount = size.width/titleLabel.width;
        if ((int)size.width %  (int)titleLabel.width != 0) {
            lineCount++;
        }
        float height = 42 + (lineCount - 1) * titleLabel.font.lineHeight;
        [self.titleLabel setHeight:height];
        [self.line1 setTop:titleLabel.top + titleLabel.height];
        [self.btn1 setTop:line1.top + line1.height];
        [self.btn2 setTop:btn1.top + btn1.height + line2.height];
        
        size = [addressLabel.text sizeWithFont:addressLabel.font constrainedToSize:CGSizeMake(999999, addressLabel.font.lineHeight)];
        if (size.width <= 0) {
            size.width = 1;
        }
        lineCount = size.width/addressLabel.width;
        if ((int)size.width %  (int)addressLabel.width != 0) {
            lineCount++;
        }
            height = 42 + (lineCount - 1) * addressLabel.font.lineHeight;
            [self.btn1 setHeight:height];
            [self.addressLabel setHeight:height];
            [self.line2 setTop:addressLabel.top + addressLabel.height];
            [self.line3 setTop:addressLabel.center.y- 12];
            [self.addressIcon setTop:addressLabel.center.y - addressIcon.height/2];
            [self.btn2 setTop:btn1.top + btn1.height+ line2.height];
        self.bgFrameView.frame = CGRectMake(bgFrameView.left, bgFrameView.top, bgFrameView.width, self.height - 12);
    }
}

-(void) btnClick1:(id)sender
{
    if (observer && [observer respondsToSelector:@selector(cell:beClickBtnId:)]) {
        [observer cell:self.cellId beClickBtnId:1];
    }
}
-(void) btnClick2:(id)sender
{
    if (observer && [observer respondsToSelector:@selector(cell:beClickBtnId:)]) {
        [observer cell:self.cellId beClickBtnId:2];
    }
}
@end
