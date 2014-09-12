//
//  MyWindow.m
//  UsedCar2
//
//  Created by qiao on 13-7-23.
//  Copyright (c) 2013年 che168. All rights reserved.
//

#import "MyWindow.h"
#import "TableViewEx.h"

@implementation MyWindow

- (void) sendEvent:(UIEvent *)event{
    if (UIEventTypeTouches == event.type) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GlobTouchEvent object:event];
    }
    [super sendEvent:event];
}

@end
