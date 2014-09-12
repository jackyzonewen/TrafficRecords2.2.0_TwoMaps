//
//  UINavigationController+ViewAnimation.m
//  TrafficRecords
//
//  Created by qiao on 13-10-21.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "UINavigationController+ViewAnimation.h"

@implementation UINavigationController (ViewAnimation)


- (void)pushAnimationDidStop {
}

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition {
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return poppedController;
}


@end
