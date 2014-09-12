//
//  UMFeedbackViewController.m
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMFeedbackTableViewCellLeft.h"
#import "UMFeedbackTableViewCellRight.h"
#import "UMContactViewController.h"
#import "TRTextField.h"
#import "CarInfo.h"
#import "OpenUDID.h"
#import "JSON.h"
#import "FAQModel.h"
#import "FAQTableViewCell.h"

#define TOP_MARGIN 20.0f
#define kNavigationBar_ToolBarBackGroundColor  [UIColor colorWithRed:0.149020 green:0.149020 blue:0.149020 alpha:1.0]
#define kContactViewBackgroundColor  [UIColor colorWithRed:0.078 green:0.584 blue:0.97 alpha:1.0]


@interface UMFeedbackViewController ()
@property(nonatomic, copy) NSString *mContactInfo;
@end

@implementation UMFeedbackViewController

@synthesize mTextField = _mTextField, mTableView = _mTableView, mToolBar = _mToolBar, mFeedbackData = _mFeedbackData;
@synthesize mTableView2;
@synthesize mFaqListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [focusTextField resignFirstResponder];
    UMContactViewController *contactViewController = [[UMContactViewController alloc] initWithNibName:@"UMContactViewController" bundle:nil];

    contactViewController.delegate = (id <UMContactViewControllerDelegate>) self;
    [self.navigationController pushViewController:contactViewController animated:YES];
    if ([self.mContactInfo length]) {
        contactViewController.textView.text = self.mContactInfo;
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _mTextField.moveSuperView = self.mToolBar;
}

-(NSString *)naviTitle{
    return @"意见反馈";
}

-(NSString *)naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) swtichBtnClick:(UIButton *)sender{
    [focusTextField resignFirstResponder];
    if (sender == feedBackBtn) {
        feedBackBtn.selected = YES;
        faqBtn.selected = NO;
        feedbackView.hidden = NO;
        faqListView.hidden = YES;
    } else {
        feedBackBtn.selected = NO;
        faqBtn.selected = YES;
        feedbackView.hidden = YES;
        faqListView.hidden = NO;
    }
}

-(void) initFaqData{
    if (self.mFaqListArray == nil) {
        self.mFaqListArray = [NSMutableArray array];
    }
    
    faqService = [[FAQService alloc] init];
    faqService.delegate = self;
    [faqService getFaqListData];
    
    NSString *str = [TRUtility readcontentFromFile:KFAQSaveFileName];
    if (str.length == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"json"];
        NSStringEncoding encoding = NSUTF8StringEncoding;
        str = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:nil];
    }
    NSDictionary *dic = [str JSONValue];
    [self.mFaqListArray removeAllObjects];
    dic = [dic objectForKey:@"result"];
    NSArray *array = [dic objectForKey:@"items"];
    for (NSDictionary *temp in array) {
        FAQModel *model = [[FAQModel alloc] init];
        model.title = [temp objectForKey:@"title"];
        model.content = [temp objectForKey:@"content"];
        [self.mFaqListArray addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFaqData];
    
    NSDictionary *dic = [[TRUtility readcontentFromFile:KFeedbackFileName] JSONValue];
    if (dic != nil) {
        _mFeedbackData = [[dic objectForKey:@"result"] objectForKey:@"items"];
    }
    
    UIImage *bg = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xdb325a]];
    [self.navigationController.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
        self.navigationController.navigationBar.shadowImage = [TRUtility imageWithColor:[UIColor clearColor]];
    }
    if (kSystemVersion >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [TRSkinManager bgColorWhite];
    
    UIImage *image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcccccc]];
    feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBackBtn.backgroundColor = [TRSkinManager colorWithInt:0xebebeb];
    [feedBackBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [feedBackBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
    feedBackBtn.frame = CGRectMake(KDefaultStartY, 0, self.view.width/2, 48);
    [feedBackBtn setTitleColor:[TRSkinManager colorWithInt:0x666666] forState:UIControlStateNormal];
    [feedBackBtn setTitleColor:[self naviColor] forState:UIControlStateSelected];
    feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    feedBackBtn.selected = YES;
    [feedBackBtn addTarget:self action:@selector(swtichBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    faqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faqBtn.backgroundColor = [TRSkinManager colorWithInt:0xebebeb];
    [faqBtn setTitle:@"常见问题" forState:UIControlStateNormal];
    faqBtn.frame = CGRectMake(self.view.width/2, KDefaultStartY, self.view.width/2, 48);
    [faqBtn setTitleColor:[TRSkinManager colorWithInt:0x666666] forState:UIControlStateNormal];
    [faqBtn setTitleColor:[self naviColor] forState:UIControlStateSelected];
    [faqBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    faqBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [faqBtn addTarget:self action:@selector(swtichBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //初始化意见反馈界面
    feedbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.view.width, self.view.height - KHeightReduce - 48)];
    feedbackView.backgroundColor = [TRSkinManager bgColorWhite];
    [self.view addSubview:feedbackView];
    //创建mContactView
    self.mContactView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, feedbackView.width, 44)];
    self.mContactView.backgroundColor = [TRSkinManager bgColorWhite];
    
    UIView *view2 =[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.mContactView.width-25, 34)];
    view2.layer.cornerRadius = 10;
    view2.backgroundColor = [TRSkinManager colorWithInt:0xebebeb];
    [self.mContactView addSubview:view2];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.mContactView.width-25, 34)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"您的联系方式>";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [TRSkinManager colorWithInt:0x666666];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 11;
    [self.mContactView addSubview:label];
    float lineH = [TRUtility lineHeight];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.mContactView addGestureRecognizer:singleFingerTap];
    
    //创建mTableView
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mContactView.bottom, feedbackView.width, feedbackView.height - self.mContactView.height - 44) style:UITableViewStylePlain];
    self.mTableView.backgroundColor = [TRSkinManager bgColorWhite];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    //创建mToolBar
    self.mToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.mTableView.bottom, self.mContactView.width, 44)];
    self.mToolBar.backgroundColor = [TRSkinManager bgColorLight];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.frame = CGRectMake(256, 7, 57.0f, 30.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    [button setBackgroundColor:[self naviColor]];
    [button addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];
    [self.mToolBar addSubview:button];
    _mTextField = [[TRTextField alloc] initWithFrame:CGRectMake(6, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.backgroundColor = [UIColor whiteColor];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.textAlignment = NSTextAlignmentLeft;
    _mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mTextField.borderStyle = UITextBorderStyleNone;
    _mTextField.backgroundColor = [UIColor clearColor];
    _mTextField.background = TRImage(@"inputBg2.png");
    //    _mTextField.layer.borderColor =
    _mTextField.font = [UIFont systemFontOfSize:14.0f];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    _mTextField.leftView = paddingView;
    _mTextField.leftViewMode = UITextFieldViewModeAlways;
    _mTextField.delegate = (id <UITextFieldDelegate>) self;
    _mTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.mToolBar addSubview:_mTextField];
//    [self setupTextField];
//    [self setupTableView];
    BOOL contactViewHide = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UMFB_ShowContactView2"] length] > 0 ? YES : NO;
    [feedbackView addSubview:self.mTableView];
    myScrollView = self.mTableView;
    
    EGORefreshTableHeaderView *view = [self getHeadView:self.mTableView];
    [view removeFromSuperview];
    [feedbackView addSubview:view];
    if (!contactViewHide) {
        UIImage *indicator = TRImage(@"load.png");
        view.frame = CGRectMake(10,  self.mContactView.height - indicator.size.height -10, indicator.size.width, indicator.size.height);
        view.initRect = view.frame;
    } else {
        UIImage *indicator = TRImage(@"load.png");
        view.frame = CGRectMake(10, - indicator.size.height -10, indicator.size.width, indicator.size.height);
        view.initRect = view.frame;
    }
    [feedbackView addSubview:self.mContactView];
    [feedbackView addSubview:self.mToolBar];
    if (contactViewHide) {
        [self.mContactView removeFromSuperview];
        self.mTableView.frame = CGRectMake(0, 0, feedbackView.width, feedbackView.height  - 44);
    }
    
    [self setFeedbackClient];
    [self updateTableView:nil];
    [self handleKeyboard];
    _shouldScrollToBottom = YES;

    [self.view addSubview:feedBackBtn];
    [self.view addSubview:faqBtn];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width/2, 0, lineH, 48)];
    line1.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [self.view addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,  feedBackBtn.bottom - lineH, self.view.width, lineH)];
    line2.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [self.view addSubview:line2];
    
    
    //初始化意见反馈界面
    faqListView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, self.view.width, self.view.height - KHeightReduce - 48)];
    faqListView.backgroundColor = [TRSkinManager bgColorLight];
    [self.view addSubview:faqListView];
    faqListView.hidden = YES;
    
    //创建mTableView2
    self.mTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, feedbackView.width, faqListView.height - 20) style:UITableViewStylePlain];
    self.mTableView2.backgroundColor = [TRSkinManager bgColorLight];
    self.mTableView2.delegate = self;
    self.mTableView2.dataSource = self;
    self.mTableView2.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [faqListView addSubview:self.mTableView2];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,  20, faqListView.width, lineH)];
    line3.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [faqListView addSubview:line3];

    [self autoRefresh];
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEvent:) name:KNotification_GlobTouchEvent object:nil];
}


-(void) touchEvent:(NSNotification*) touchMsg{
    UIEvent *event = touchMsg.object;
    UITouch *touch = [[event allTouches] anyObject];
    UIView *view = touch.view;
    if (![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UITextField class]] && view != nil) {
        [self hiddenKeyBoard];
    }
}

- (void)setFeedbackClient {
    feedBackGet = [[FeedbackService alloc] init];
    feedBackGet.delegate = self;
    
    feedBackSend = [[FeedbackService alloc] init];
    feedBackSend.delegate = self;
    feedBackSend.reqTag = EServiceFeedBackSend;
}

- (void)setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [backBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backHL.png"] forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
}

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self.mTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationPortrait == interfaceOrientation) {
        return  YES;
    }
    return NO;
}


- (void)backToPrevious {

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendFeedback:(id)sender {
    if (self.mTextField.text.length > 0) {
        [self.mTextField resignFirstResponder];
        _shouldScrollToBottom = YES;
        [self showLoadingAnimated:YES];
        if (self.mContactInfo.length == 0) {
            self.mContactInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UMFB_ShowContactView2"];
        }
        [feedBackSend postFeedback:self.mTextField.text contacts:self.mContactInfo];
        if (self.mContactInfo.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:self.mContactInfo forKey:@"UMFB_ShowContactView2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.mTableView == tableView) {
        return [_mFeedbackData count];
    } else {
        return self.mFaqListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mTableView == tableView) {
        NSString *content = [[self.mFeedbackData objectAtIndex:(NSUInteger) indexPath.row] objectForKey:@"questioncontent"];
        CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                               constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        return labelSize.height + 40 + TOP_MARGIN;
    } else {
        FAQModel *model = [self.mFaqListArray objectAtIndex:(NSUInteger) indexPath.row];
        if (model.opened) {
            NSString *content = model.content;
            CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                   constrainedToSize:CGSizeMake(298.0, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
            return labelSize.height + 22 + 44;
        } else {
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mTableView == tableView) {
        static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
        static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";
        
        NSDictionary *data = [self.mFeedbackData objectAtIndex:(NSUInteger) indexPath.row];
        
        //wz团队回复的
        if ([[data objectForKey:@"replyflag"] integerValue] == 1) {//[[data valueForKey:@"type"] isEqualToString:@"dev_reply"]) {
            UMFeedbackTableViewCellLeft *cell = (UMFeedbackTableViewCellLeft *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
            if (cell == nil) {
                cell = [[UMFeedbackTableViewCellLeft alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
            }
            
            cell.textLabel.text = [data valueForKey:@"questioncontent"];
            cell.timestampLabel.text = [data valueForKey:@"createtime"];
            
            return cell;
        }
        else {
            
            UMFeedbackTableViewCellRight *cell = (UMFeedbackTableViewCellRight *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
            if (cell == nil) {
                cell = [[UMFeedbackTableViewCellRight alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
            }
            
            cell.textLabel.text = [data valueForKey:@"questioncontent"];
            cell.timestampLabel.text = [data valueForKey:@"createtime"];
            
            return cell;
            
        }
    } else {
//        FAQTableViewCell
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        FAQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQTableViewCell"];
        if (cell == nil) {
            cell = [FAQTableViewCell loadFromXib];
            [cell.titleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        FAQModel *model = [self.mFaqListArray objectAtIndex:(NSUInteger) indexPath.row];
        [cell.titleBtn setTitle:model.title forState:UIControlStateNormal];
        cell.titleBtn.tag = indexPath.row + 1000;
        cell.contentLabel.text = model.content;
        if (model.opened) {
            cell.downIcon.image = TRImage(@"faqup.png");
            cell.contentLabel.hidden = NO;
            [cell.contentLabel setHeight:height - 44];
        } else {
            cell.downIcon.image = TRImage(@"faqdown.png");
            cell.contentLabel.hidden = YES;
        }
        return cell;
    }
}

-(void) btnClick:(UIButton *) btn{
    FAQModel *model = [self.mFaqListArray objectAtIndex:(NSUInteger) btn.tag - 1000];
    model.opened = !model.opened;
    //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [self.mTableView2 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn.tag - 1000 inSection:0]] withRowAnimation:NO];
    [self.mTableView2 reloadData];
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.mTableView2) {
//        FAQModel *model = [self.mFaqListArray objectAtIndex:(NSUInteger) indexPath.row];
//        model.opened = !model.opened;
////        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
//    }
//}

#pragma mark ContactViewController delegate method

- (void)updateContactInfo:(UMContactViewController *)controller contactInfo:(NSString *)info {
    if ([info length]) {
        self.mContactInfo = info;
        UILabel *title = (UILabel *) [self.mContactView viewWithTag:11];
        title.text = [NSString stringWithFormat:@"%@ : %@", @"您的联系方式", info];
    }
}

#pragma mark Umeng Feedback delegate


- (void)updateTableView:(NSError *)error {
    if ([self.mFeedbackData count]) {
        [self.mTableView reloadData];
    }
}

- (void)updateTextField:(NSError *)error {
    if (!error) {
        self.mTextField.text = @"";
    }
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    if (tag == EServiceFeedBackGet) {
        [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:1.0];
        _mFeedbackData = [[feedBackGet.responseDic objectForKey:@"result"] objectForKey:@"items"];
        [self updateTableView:nil];
        if (_shouldScrollToBottom) {
            [self scrollToBottom];
        }
    } else if(EServiceFeedBackSend == tag){
        [self updateTextField:nil];
        _mFeedbackData = [[feedBackSend.responseDic objectForKey:@"result"] objectForKey:@"items"];
        [self updateTableView:nil];
        if (_shouldScrollToBottom) {
            [self scrollToBottom];
        }
    } else if(EServiceGetFAQList == tag){
        NSString *str = [TRUtility readcontentFromFile:KFAQSaveFileName];
        if (str.length == 0) {
            return;
        }
        NSDictionary *dic = [str JSONValue];
        [self.mFaqListArray removeAllObjects];
        dic = [dic objectForKey:@"result"];
        NSArray *array = [dic objectForKey:@"items"];
        for (NSDictionary *temp in array) {
            FAQModel *model = [[FAQModel alloc] init];
            model.title = [temp objectForKey:@"title"];
            model.content = [temp objectForKey:@"content"];
            [self.mFaqListArray addObject:model];
        }
        [self.mTableView2 reloadData];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
    if (tag == EServiceFeedBackGet) {
        [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:1.0];
    }
    if (_shouldScrollToBottom) {
        [self scrollToBottom];
    }
}

//
//- (void)getFinishedWithError:(NSError *)error {
//    [self hideLoadingViewAnimated:YES];
//    if (!error) {
//        [self updateTableView:error];
//    }
//
//    [self performSelector:@selector(doneLoadData) withObject:nil afterDelay:1.0];
//}
//
//- (void)postFinishedWithError:(NSError *)error {
//
//    [self hideLoadingViewAnimated:YES];
//    [self updateTextField:error];
//}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//
////自动刷新
//-(void) autoRefresh;
//下拉刷新的控件重新获取数据
- (void) loadData{
    [super loadData];
    [feedBackGet getFeedbackList];
}
////加载完数据后，scrollView恢复正常
//- (void)doneLoadData;
- (void)scrollToBottom {
    if ([self.mTableView numberOfRowsInSection:0] > 1) {
        long lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_GlobTouchEvent object:nil];
}

@end
