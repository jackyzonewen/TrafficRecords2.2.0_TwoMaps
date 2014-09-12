//
//  CarViewCell.m
//  TrafficRecords
//
//  Created by qiao on 13-11-7.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "CarViewCell.h"
#import "AHSplitLine.h"

@implementation CarViewCell

@synthesize brandImageView;
@synthesize contentImageView;
@synthesize nameLabel;
@synthesize countLabel;
@synthesize ciLabel;
@synthesize moneyLabel;
@synthesize scoreLabel;
@synthesize countflagLabel;

@synthesize notLeabel;
@synthesize moneyImageView;
@synthesize scoreImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CarViewCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CarViewCell" owner:self options:nil];
    CarViewCell *cell = [array objectAtIndex:0];
    UIImage *image = TRImage(@"contentBg.png");
    image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    cell.contentImageView.image = image;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [TRSkinManager setCellSelectBgColor:cell];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(85, 5, [TRUtility lineHeight], 95)];
    view.image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xe6e6e6]];
    [cell.contentView addSubview:view];
    
    return cell;
}
@end
