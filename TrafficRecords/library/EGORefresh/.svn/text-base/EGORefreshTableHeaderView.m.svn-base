//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define KIndicatorHeight 36

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize initRect;
@synthesize delegate;

//-(void) dealloc {
//    NSLog(@"EGORefreshTableHeaderView dealloc");
//}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (id)initWithFrame:(CGRect)frame ImageName:(UIImage *)indicator{
    if (self = [super initWithFrame:frame]) {
        initRect = frame;
        CALayer *layer = [CALayer layer];
		layer.frame = self.bounds;
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)indicator.CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
    }
    return self;
}


#pragma mark -
#pragma mark Setters

-(void) setInitRect:(CGRect)ainitRect{
    initRect = ainitRect;
    [self setState:_state];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
            if (self.timer != nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
			break;
		case EGOOPullRefreshNormal:
        {
            [UIView beginAnimations:@"sart" context:nil];
            [UIView setAnimationDuration:0.3];
            self.frame = initRect;
            degrees += 0.3489723;
            _arrowImage.transform =  CATransform3DMakeRotation(degrees, 0.0, 0.0, 1.0);
            [UIView commitAnimations];
            if (self.timer != nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
			break;
        }
		case EGOOPullRefreshLoading:
        {
            self.frame = CGRectMake(initRect.origin.x, initRect.origin.y + KIndicatorHeight, initRect.size.width, initRect.size.height);
            if (self.timer != nil) {
                [self.timer invalidate];
                self.timer = nil;
            }
            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];//创建对象，指定首次启动的时间
            self.timer = [[NSTimer alloc] initWithFireDate:fireDate interval:0.03 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        } break;
		default:
			break;
	}
	_state = aState;
}

-(void) runTime{
    if ([CATransaction disableActions]) {
        [CATransaction setDisableActions:NO];
    }
    degrees += 0.3489723;
    _arrowImage.transform =  CATransform3DMakeRotation(degrees, 0.0, 0.0, 1.0);
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
        if (scrollView.contentOffset.y > 0) {
            self.frame = CGRectMake(initRect.origin.x, initRect.origin.y + KIndicatorHeight - scrollView.contentOffset.y, initRect.size.width, initRect.size.height);
        }
	} else if (scrollView.isDragging) {
        if (scrollView.contentOffset.y < 0) {
            float lenY = ABS(scrollView.contentOffset.y);
            if (lenY >= KIndicatorHeight) {
                self.frame = CGRectMake(initRect.origin.x, initRect.origin.y + KIndicatorHeight, initRect.size.width, initRect.size.height);
            } else {
                self.frame = CGRectMake(initRect.origin.x, initRect.origin.y + lenY, initRect.size.width, initRect.size.height);
            }
            [CATransaction setDisableActions:YES];
//            degrees = (4.9 * scrollView.contentOffset.y * 3.14159265)/180.0;
            float len = scrollView.contentOffset.y - lastY;
            lastY = scrollView.contentOffset.y;
            float change = 0.2;
            if (abs(len) > 2) {
                change = 0.15;
            }else if (abs(len) > 3) {
                change = 0.2;
            }else if (abs(len) > 4) {
                change = 0.22;
            }else if (abs(len) > 5) {
                change = 0.26;
            }else {
                change = 0.32;
            }
            change -= 0.1;
            if (len < 0) {
                degrees += change;
                lastChange = change;
            } else {
                degrees -= change;
                lastChange = -change;
            }
            
            _arrowImage.transform =  CATransform3DMakeRotation(degrees, 0.0, 0.0, 1.0);
        }
        
		BOOL _loading = NO;
		if ([((NSObject*)self.delegate) respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [self.delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}

	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
//    [CATransaction setDisableActions:NO];
//    degrees += lastChange;
//    _arrowImage.transform =  CATransform3DMakeRotation(degrees, 0.0, 0.0, 1.0);
    
	BOOL _loading = NO;
	if ([((NSObject*)self.delegate) respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		if ([((NSObject*)self.delegate) respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		[self setState:EGOOPullRefreshLoading];
	} else if(!_loading){
        [self setState:EGOOPullRefreshNormal];
    }
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	[self setState:EGOOPullRefreshNormal];

}

@end
