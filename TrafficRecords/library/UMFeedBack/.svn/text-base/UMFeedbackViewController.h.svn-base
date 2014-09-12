//
//  UMFeedbackViewController.h
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"
//#import "UMEGORefreshTableHeaderView.h"
#import "TRRefreshViewController.h"
#import "FeedbackService.h"
#import "FAQService.h"

@class TRTextField;

@interface UMFeedbackViewController : TRRefreshViewController<UITableViewDelegate, UITableViewDataSource>{
    BOOL _reloading;
    CGFloat _tableViewTopMargin;
    BOOL _shouldScrollToBottom;
    FeedbackService     *feedBackGet;
    FeedbackService     *feedBackSend;
    FAQService          *faqService;
    
    UIButton            *feedBackBtn;
    UIButton            *faqBtn;
    UIView              *feedbackView;
    UIView              *faqListView;
}

@property(nonatomic, retain) UITableView *mTableView;
@property(nonatomic, retain) UITableView *mTableView2;
@property(nonatomic, retain) UIView *mToolBar;
@property(nonatomic, retain) UIView *mContactView;

@property(nonatomic, retain) TRTextField *mTextField;
@property(nonatomic, retain) UIBarButtonItem *mSendItem;
@property(nonatomic, retain) NSArray *mFeedbackData;
@property(nonatomic, retain) NSMutableArray *mFaqListArray;
@property(nonatomic, copy) NSString *appkey;

- (IBAction)sendFeedback:(id)sender;
@end
