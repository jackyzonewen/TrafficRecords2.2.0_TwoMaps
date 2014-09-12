//
//  TRBaseViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHNetDelegate.h"



@interface TRBaseViewController : UIViewController<AHServiceDelegate, UITextFieldDelegate>{
    UITextField     *focusTextField;
    //y坐标起点
    float            KDefaultStartY;
    //高度减量
    float            KHeightReduce;
    
    int            dragDirect; // 0为未知，1为x方向，2为y方向
    UIPanGestureRecognizer *recognizer;
    UIView          *noDataView;
    UIView          *networkErrView;
}

- (UIColor *) naviColor;
- (NSString *) naviTitle;
- (NSString *) naviLeftIcon;
- (NSString *) naviRightIcon;
- (void) naviLeftClick:(id) sender;
- (void) naviRightClick:(id) sender;
- (void)initNavigation;

-(UIView*) errorView;
-(UIView*) loadingView;
-(void) showLoadingAnimated:(BOOL) animated;
-(void) hideLoadingViewAnimated:(BOOL) animated;
-(void) showErrorViewAnimated:(BOOL) animated;
-(void) hideErrorViewAnimated:(BOOL) animated;
-(void) showInfoView:(NSString *) info;
-(void) hiddenKeyBoard;
-(void) makeCall:(NSString *)phoneNum;
-(void) addNodataView:(UIView *) tableView;
-(void) addNetworkErrView:(UIView *) parentView;
@end
