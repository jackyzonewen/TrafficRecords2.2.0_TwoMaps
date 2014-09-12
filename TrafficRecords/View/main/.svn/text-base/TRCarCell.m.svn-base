//
//  TRCarCell.m
//  TrafficRecords
//
//  Created by qiao on 13-11-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRCarCell.h"
#import "SDImageCache.h"

@implementation TRCarCell

@synthesize brandImageView;
@synthesize carNumLabel;
@synthesize timesCountBtn;
@synthesize line;
@synthesize themeImageView;
@synthesize faqianLabel;
@synthesize koufenLabel;

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


+(TRCarCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TRCarCell" owner:self options:nil];
    TRCarCell *cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *lastUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KThemeImageChanged];
    UIImage *image = nil;
    if (lastUrl.length > 0) {
        image = [[SDImageCache sharedImageCache] imageFromKey:lastUrl];
    }
    if (image == nil) {
        image = TRImage(@"themeImage.png");
    }
    cell.themeImageView.image = image;
    return cell;
}


@end
