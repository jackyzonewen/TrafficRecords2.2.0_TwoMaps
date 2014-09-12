//
//  TRAppTableViewCell.m
//  TrafficRecords
//
//  Created by qiao on 14-4-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRAppTableViewCell.h"
#import "AHSplitLine.h"

@implementation TRAppTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}


+(TRAppTableViewCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TRAppTableViewCell" owner:self options:nil];
    TRAppTableViewCell *cell = [array objectAtIndex:0];
    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [TRSkinManager setCellSelectBgColor:cell];
    float lineH = [TRUtility lineHeight];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, cell.height - lineH, cell.width - 10, lineH)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [cell.contentView insertSubview:line atIndex:0];
//    AHSplitLine *line = [[AHSplitLine alloc] initWithFrame:CGRectMake(10, cell.height - 2, cell.width - 20, 2) orientation:Landscape firstLineColor:[TRSkinManager colorWithInt:0xe6e6e6] secondLineColor:[TRSkinManager colorWithInt:0xfafafa]];
//    //    [cell addSubview:line];
//    [cell.contentView insertSubview:line atIndex:0];
    return cell;
}


@end
