//
//  LimitNumViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-5-15.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "TRScrollCarView.h"

@interface LimitNumViewController : TRBaseViewController <TRScrollCarViewDelegate>
{
    TRScrollCarView *scrollcarView;
    UIScrollView    *contentScrollView;
}
@property (nonatomic, assign) NSInteger         cityId;
@property (nonatomic, strong) NSMutableArray    *dates;
@property (nonatomic, strong) NSMutableArray    *limitNums;
@property (nonatomic, strong) NSMutableArray    *part2Titles;
@property (nonatomic, strong) NSMutableArray    *part2Contents;
@property (nonatomic, strong) NSString          *picUrl;
@property (nonatomic, strong) NSMutableArray    *part3Titles;
@property (nonatomic, strong) NSMutableArray    *part3Contents;
@property (nonatomic, strong) NSMutableArray    *part4Titles;
@property (nonatomic, strong) NSMutableArray    *part4Contents;
@property (nonatomic, strong) NSMutableArray    *carNums;
@property (nonatomic, strong) NSMutableArray    *carLimitInfo;
@end
