//
//  FAQTableViewCell.m
//  TrafficRecords
//
//  Created by qiao on 14-6-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "FAQTableViewCell.h"

@implementation FAQTableViewCell

@synthesize titleBtn;
@synthesize contentLabel;
@synthesize downIcon;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(FAQTableViewCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FAQTableViewCell" owner:self options:nil];
    FAQTableViewCell *cell = [array objectAtIndex:0];
//    [TRSkinManager setCellSelectBgColor:cell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIImage *image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcccccc]];
    [cell.titleBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    
    float lineH = [TRUtility lineHeight];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.titleBtn.height - lineH, cell.width, lineH)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
    [cell addSubview:line];
    
    return cell;
}

@end
