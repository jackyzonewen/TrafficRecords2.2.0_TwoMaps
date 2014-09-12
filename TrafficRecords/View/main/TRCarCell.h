//
//  TRCarCell.h
//  TrafficRecords
//
//  Created by qiao on 13-11-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRImageView.h"

@interface TRCarCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UrlImageView *themeImageView;
@property (nonatomic,weak) IBOutlet TRImageView *brandImageView;
@property (nonatomic,weak) IBOutlet UILabel *carNumLabel;
@property (nonatomic,weak) IBOutlet UIButton *timesCountBtn;
@property (nonatomic,weak) IBOutlet UIView *line;
@property (nonatomic, weak) IBOutlet UILabel *faqianLabel;
@property (nonatomic, weak) IBOutlet UILabel *koufenLabel;
+(TRCarCell *) loadFromXib;
@end
