//
//  TrafficRecordCell.m
//  TrafficRecords
//
//  Created by qiao on 13-9-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "TrafficRecordCell.h"
#import "AHSplitLine.h"

@implementation TrafficRecordCell

@synthesize placeIcon;
@synthesize addressLabel;
@synthesize actionLabel;
@synthesize timeLabel;
@synthesize moneyLabel;
@synthesize scoreLabel;

+(TrafficRecordCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TrafficRecordCell" owner:self options:nil];
    TrafficRecordCell *cell = [array objectAtIndex:0];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [TRSkinManager setCellSelectBgColor:cell];
    
    UIImage *image =  [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xdbdbdb]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(28, 0, 2, cell.height);
    [cell.contentView insertSubview:imageView atIndex:0];
    
    float lineH = [TRUtility lineHeight];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - lineH, cell.width, lineH)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
    [cell.contentView insertSubview:line atIndex:0];
    return cell;
}

@end
