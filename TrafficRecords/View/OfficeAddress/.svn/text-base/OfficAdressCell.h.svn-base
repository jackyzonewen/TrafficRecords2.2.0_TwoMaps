//
//  OfficAdressCell.h
//  TrafficRecords
//
//  Created by qiao on 14-3-13.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfficAdressCellEventObserver <NSObject>

@optional
//btnId == 1 address ，btnId == 2，phone
-(void) cell:(int) cellId beClickBtnId:(int) btnId;

@end

////////

@interface OfficAdressCell : UITableViewCell
{
}
@property (nonatomic, strong) UIImageView *bgFrameView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIImageView *addressIcon;
@property (nonatomic, strong) UIImageView *phoneIcon;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, assign) int cellId;
@property (nonatomic,weak)id<OfficAdressCellEventObserver> observer;

-(void) changeLayOut;
@end
