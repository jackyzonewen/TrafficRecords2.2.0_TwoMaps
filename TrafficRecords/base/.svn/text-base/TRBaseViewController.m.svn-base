//
//  TRBaseViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "AHToastView.h"
#import "LoadingView.h"
#import "AHToastView2.h"
#import "MobClick.h"

@interface TRBaseViewController ()
{
    CALayer *lastScreenLayer;
    CGPoint startTouch;
}
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,retain) UIView *backgroundView;
@end

@implementation TRBaseViewController


#pragma mark -
#pragma mark SettingNavigation Methods

- (UIColor *) naviColor{
    return [TRSkinManager colorWithInt:0xdb325a];//219 50 90
}

- (NSString *) naviTitle{
    return @"";
}

- (NSString *) naviLeftIcon{
    return nil;
}

- (NSString *) naviRightIcon{
    return nil;
}

- (void) naviLeftClick:(id) sender{
    
}

- (void) naviRightClick:(id) sender{
    
}

-(void) dealloc{
    [self hideLoadingViewAnimated:YES];
    NSString *str = NSStringFromClass([self class]);
    NSLog(@"%@ dealloc", str);
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString *str = NSStringFromClass([self class]);
    [MobClick beginLogPageView:str];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSString *str = NSStringFromClass([self class]);
    [MobClick endLogPageView:str];
}

#pragma mark -
#pragma mark  UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIButton *)createButton:(UIImage *)leftIcon hl:(UIImage *)hlIcon left:(BOOL) isleft
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:leftIcon forState:UIControlStateNormal];
    [button setImage:hlIcon forState:UIControlStateHighlighted];

    button.frame = CGRectMake(0, 0, 44, 44);
    if (isleft) {
        [button addTarget:self action:@selector(naviLeftClick:) forControlEvents: UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(naviRightClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    return button;
}

-(NSString *) hlIconName:(NSString *)iconName{
    NSRange range = [iconName rangeOfString:@"."];
    NSMutableString *str = [NSMutableString stringWithString:iconName];
    [str insertString:@"HL" atIndex:range.location];
    return str;
}

- (void)initNavigation
{
    NSString *left = [self naviLeftIcon];
    if (left && left.length > 0) {
        UIImage *leftIcon = TRImage(left);
        UIImage *leftHLICon = TRImage([self hlIconName:left]);
        if (leftIcon != nil) {
            UIButton *contentView = [self createButton:leftIcon hl:leftHLICon left:YES];
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:contentView];
            self.navigationItem.leftBarButtonItem = item;
            if (kSystemVersion >= 7.0) {
                [contentView setImageEdgeInsets:UIEdgeInsetsMake(0, -23, 0, 0)];
            }
            if ([left isEqualToString:@"back.png"]) {
                [contentView setTitle:@"返回" forState:UIControlStateNormal];
                [contentView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [contentView setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
                [contentView setTitleEdgeInsets:UIEdgeInsetsMake(0, -28, 0, 0)];
                [contentView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                contentView.titleLabel.font = [UIFont systemFontOfSize:16];
                [contentView setWidth:64];
            }
        }
    }
    NSString *right = [self naviRightIcon];
    if (right && right.length > 0) {
        UIImage *rightIcon = TRImage(right);
        UIImage *rightHLICon = TRImage([self hlIconName:right]);
        if (rightIcon != nil) {
            UIButton *contentView = [self createButton:rightIcon hl:rightHLICon left:NO];
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:contentView];
            self.navigationItem.rightBarButtonItem = item;
            if (kSystemVersion >= 7.0) {
                [contentView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -23)];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [TRSkinManager bgColorLight];
    //设置navigationBar式样
    UINavigationController * naviCtrller = self.navigationController;
    if (naviCtrller) {
        UIImage *bg = [TRUtility imageWithColor:[self naviColor]];
        [naviCtrller.navigationBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
        if ([naviCtrller.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
            naviCtrller.navigationBar.shadowImage = [TRUtility imageWithColor:[UIColor clearColor]];
        }
        if (kSystemVersion >= 7.0) {
            naviCtrller.navigationBar.translucent = NO;
        }
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        t.font = [TRSkinManager largeFont2];
        t.textColor = [TRSkinManager textColorWhite];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = UITextAlignmentCenter;
        t.text = [self naviTitle];
        self.navigationItem.titleView = t;
        [self initNavigation];
    }
    if (![NSStringFromClass([self class]) isEqualToString:@"TRMainViewController"] ||
        self.navigationController.viewControllers.count > 1) {
        recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
        [recognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:recognizer];
    }
    if (kSystemVersion >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        KDefaultStartY = 0;
        KHeightReduce = 64;
    } else {
        KDefaultStartY = 0;
        if (self.view.height == [TRAppDelegate appDelegate].window.height - 20) {
            KHeightReduce = 44;
        } else {
            KHeightReduce = 0;
        }
    }
}

- (CALayer *)capture
{
    UIViewController *viewControll = self.presentingViewController;
    if (viewControll != [TRAppDelegate mmDrawerController]) {
        if (![viewControll isKindOfClass:[UINavigationController class]]) {
             viewControll = viewControll.navigationController;
        }
       
    }
    return viewControll.view.layer;
//    UIGraphicsBeginImageContextWithOptions(viewControll.view.bounds.size, viewControll.view.opaque, [UIScreen mainScreen].scale);
//    [viewControll.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return img;
}

- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.navigationController.view.frame;
    frame.origin.x = x;
    self.navigationController.view.frame = frame;
    [self.backgroundView setLeft:x/2 - self.backgroundView.width/2];
//    float scale = (x/6400)+0.95;
//    float alpha = 0.4 - (x/800);
//    
//    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
//    blackMask.alpha = alpha;
    
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
//    if (self.navigationController.viewControllers.count > 1) {
//        return;
//    }
    CGPoint touchPoint = [recoginzer locationInView:[[TRAppDelegate appDelegate] window]];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        dragDirect = 0;
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.navigationController.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.navigationController.view.superview insertSubview:self.backgroundView belowSubview:self.navigationController.view];
        }
        
        self.backgroundView.hidden = NO;
        
        CALayer *tempLayer = [CALayer layer];
        if (lastScreenLayer)
        {
            [self.backgroundView.layer replaceSublayer:lastScreenLayer with:tempLayer];
            lastScreenLayer = nil;
        } else {
            [self.backgroundView.layer addSublayer:tempLayer];
        }
        
        lastScreenLayer = [self capture];
        [self.backgroundView.layer replaceSublayer:tempLayer with:lastScreenLayer];
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 100 && dragDirect == 1)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self dismissModalViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        dragDirect = 0;
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        if (dragDirect == 0) {
            float lenx = touchPoint.x - startTouch.x;
            float leny = touchPoint.y - startTouch.y;
            // 0为未知，1为x方向，2为y方向
            if (abs(lenx) > abs(leny) * 1.5 + 4) {
                dragDirect = 1;
            } else if(abs(lenx) != abs(leny)){
                dragDirect = 2;
            }
        }
        if (dragDirect == 1) {
            [self moveViewWithX:touchPoint.x - startTouch.x];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark  Imple LoadingView, MessageView Methods

-(UIView*) errorView {
    
    return nil;
}

-(UIView*) loadingView {
    UIView * superView = [TRAppDelegate appDelegate].window;
    UIView *view = [superView viewWithTag:99];
    if (view == nil) {
        view = [[LoadingView alloc] initWithFrame:superView.bounds];
        view.tag = 99;
    }
    return view;
}

-(void) showLoadingAnimated:(BOOL) animated {
    
    UIView *loadingView = [self loadingView];
    loadingView.alpha = 0.0f;
    
    [[TRAppDelegate appDelegate].window addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 1.0f;
    }];
    
    [self performSelector:@selector(hideLoadingViewAnimated:) withObject:nil afterDelay:60];
}

-(void) hideLoadingViewAnimated:(BOOL) animated {
    
    UIView *loadingView = [self loadingView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLoadingViewAnimated:) object:nil];
}

-(void) showErrorViewAnimated:(BOOL) animated {
    
    UIView *errorView = [self errorView];
    errorView.alpha = 0.0f;
    [self.view addSubview:errorView];
    [self.view bringSubviewToFront:errorView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 1.0f;
    }];
}

-(void) hideErrorViewAnimated:(BOOL) animated {
    
    UIView *errorView = [self errorView];
    
    double duration = animated ? 0.4f:0.0f;
    [UIView animateWithDuration:duration animations:^{
        errorView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview]; 
    }]; 
}

-(void) showInfoView:(NSString *) info{
    UIWindow *window = [TRAppDelegate appDelegate].window;
    AHToastView2 *nv = (AHToastView2 *)[window viewWithTag:1019];
    if (nv) {
        [nv hiddenView];
    }
    nv = [[AHToastView2 alloc] init];
    nv.text = info;
    nv.tag = 1019;
    [nv show];
}

#pragma mark -
#pragma mark  Imple UITextFieldDelegate Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    focusTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    focusTextField = nil;
    [textField resignFirstResponder];
    return NO;
}

-(void) hiddenKeyBoard{
    if (focusTextField) {
        [focusTextField resignFirstResponder];
        focusTextField = nil;
    }
}

//-(void) presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//    globPreImage = [self capture:self.navigationController];
//    if (flag) {
////        [UIView beginAnimations:nil context:nil];
////        [UIView setAnimationDuration:0.5];
////        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////        [UIView setAnimationDelegate:self];
////        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[TRAppDelegate appDelegate].window cache:YES];
////        [UIView commitAnimations];
//        
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.3;
//        animation.timingFunction= [CAMediaTimingFunction
//                                   functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//UIViewAnimationCurveEaseIn;
//        animation.type = @"pageCurl";
//        animation.subtype = kCATransitionFromRight;
//        [[TRAppDelegate appDelegate].window.layer addAnimation:animation forKey:nil];
//    }
//}
//////
//////-(void) presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated{
//////    [super presentModalViewController:modalViewController animated:animated];
//////    if (animated) {
//////        [UIView beginAnimations:nil context:nil];
//////        [UIView setAnimationDuration:1.5];
//////        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//////        [UIView setAnimationDelegate:self];
//////        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//////        [UIView commitAnimations];
//////    }
//////}
////
//-(void) dismissModalViewControllerAnimated:(BOOL)animated{
//    [super dismissModalViewControllerAnimated:NO];
//    if (animated) {
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.3;
//        animation.timingFunction= [CAMediaTimingFunction
//                                   functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//UIViewAnimationCurveEaseIn;
//        animation.type = @"pageCurl";
//        animation.subtype = kCATransitionFromLeft;
//        [[TRAppDelegate appDelegate].window.layer addAnimation:animation forKey:nil];
//    }
//}
//
//-(void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
//    [super dismissViewControllerAnimated:NO completion:completion];
//    if (flag) {
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.3;
//        animation.timingFunction= [CAMediaTimingFunction
//                                   functionWithName:kCAMediaTimingFunctionEaseInEaseOut];//UIViewAnimationCurveEaseIn;
//        animation.type = @"pageCurl";
//        animation.subtype = kCATransitionFromLeft;
//        [[TRAppDelegate appDelegate].window.layer addAnimation:animation forKey:nil];
//    }
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if (UIInterfaceOrientationPortrait == toInterfaceOrientation) {
        return  YES;
    }
    return NO;
}

-(void) makeCall:(NSString *)phoneNum{
    if (phoneNum.length == 0) {
        [self showInfoView:@"电话号码不能为空！"];
        return;
    }
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNum];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    } else {
        telURL = [NSURL URLWithString:@"tel:10086"];
        //如果10086能拨打，则表示号码有问题
        if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
            [self showInfoView:@"您所拨打的电话号码为空号！"];
        } else{
            [self showInfoView:@"该设备不支持此功能！"];
        }
        return;
    }
}

-(void) addNetworkErrView:(UIView *) parentView{
    if (networkErrView != nil) {
        return;
    }
    UIView *cell = [[UIView alloc] initWithFrame:parentView.bounds];
    cell.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = YES;
    [parentView addSubview:cell];
    networkErrView = cell;
    networkErrView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.height/3, cell.width, 26)];
    label.text = @"~亲，网络不给力哦~";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.tag = 100;
    [cell addSubview:label];
    
    UIImage *bgImage = [TRImage(@"smallbtn.png") stretchableImageWithLeftCapWidth:6 topCapHeight:6];
    UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(cell.width/2 - 88/2, label.bottom + 24, 88, 40);
    [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [bgBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [bgBtn.titleLabel setFont:[TRSkinManager largeFont2]];
    [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
    bgBtn.tag = 101;
    [cell addSubview:bgBtn];
}

-(void) addNodataView:(UIView *) parentView;
{
    if (noDataView != nil) {
        return;
    }
    UIView *cell = [[UIView alloc] initWithFrame:parentView.bounds];
    cell.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = YES;
    [parentView addSubview:cell];
    noDataView = cell;
    noDataView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
    label.text = @"抱歉，暂无该地区交管部门详细地址";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [TRSkinManager textColorLightDark];
    label.backgroundColor = [UIColor clearColor];
    label.tag = 100;
    [cell addSubview:label];
}
@end
