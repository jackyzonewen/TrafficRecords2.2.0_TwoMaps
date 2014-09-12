//
//  WeatherCell.m
//  TrafficRecords
//
//  Created by qiao on 13-9-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "WeatherCell.h"
#import "SDImageCache.h"

@implementation WeatherCell

@synthesize weatherIcon;
@synthesize temLabel;
@synthesize xianXingLabel;
@synthesize cityBtn;
@synthesize themeImageView;

@synthesize weatherLabel;
@synthesize xiCheLabel;
@synthesize pmBg;
@synthesize pmLabel;
@synthesize pmIcon;
@synthesize dateLabel;
@synthesize xianXingSplitLine;
@synthesize xianXingBg;

+(WeatherCell *) loadFromXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
    WeatherCell *cell = [array objectAtIndex:0];
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

-(void) setHidden:(BOOL)hidden{
    
}


@end
