//
//  TRTextField.m
//  TrafficRecords
//
//  Created by qiao on 13-9-17.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRTextField.h"

@implementation TRTextField
@synthesize moveSuperView;
@synthesize jiaozhengY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) setMoveSuperView:(UIView *) aMoveSuperView{
    moveSuperView = aMoveSuperView;
    originalContentViewFrame = aMoveSuperView.frame;
}

- (BOOL)becomeFirstResponder{
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    if (backBtn == nil) {
//        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setBackgroundColor:[UIColor clearColor]];
//        backBtn.frame = CGRectMake(0, 0, window.width, window.height);
//        [backBtn addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
//    }
//    [window addSubview:backBtn];
    [self registerForKeyboardNotifications];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
//    [backBtn removeFromSuperview];
    BOOL res = [super resignFirstResponder];
    [self unregisterForKeyboardNotifications];
    return res;
}

-(void) dealloc{
    [self unregisterForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWasShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillBeHidden:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

- (void)unregisterForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
}

-(void) hiddenKeyBoard{
    [self resignFirstResponder];
}

- (void)keyboardWasShow:(NSNotification *)notification {
    // 取得键盘的高度
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    UIView *superView = self.superview;
    CGRect myrect = self.frame;
    /**
     *	计算自身相对与window的坐标
     */
    while (superView != nil && ![superView isKindOfClass:[UIWindow class]]) {
        myrect.origin.y += superView.origin.y;
        if ([superView isKindOfClass:[UIScrollView class]]) {
            myrect.origin.y -= [(UIScrollView *)superView contentOffset].y;
        }
        superView = superView.superview;
    }

    CGFloat adjustHeight = endRect.size.height - ([TRAppDelegate appDelegate].window.height - myrect.origin.y - myrect.size.height) + 8 + jiaozhengY;
    if ( adjustHeight > 0) {
        CGRect newRect = moveSuperView.frame;
        newRect.origin.y -= adjustHeight;
        [UIView beginAnimations:@"high" context:nil];
        [UIView setAnimationDuration:0.2];
        [moveSuperView setFrame:newRect];
        [UIView commitAnimations];
    }
//    if (adjustHeight > 0) {
////        adjustHeight += 74;
//        CGRect newRect = originalContentViewFrame;
//        newRect.origin.y -= adjustHeight;
//        [UIView beginAnimations:@"high" context:nil];
//        [UIView setAnimationDuration:0.2];
//        [moveSuperView setFrame:newRect];
//        [UIView commitAnimations];
//    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    // 恢复原理的大小
    [UIView beginAnimations:@"low" context:nil];
    [UIView setAnimationDuration:0.2];
    [moveSuperView setFrame:originalContentViewFrame];
    [UIView commitAnimations];
}
@end
