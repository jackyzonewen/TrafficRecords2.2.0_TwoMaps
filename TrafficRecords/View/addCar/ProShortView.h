//
//  ProShortView.h
//  TrafficRecords
//
//  Created by qiao on 13-9-17.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedProDelegate <NSObject>

@optional
-(void) proBeSelected:(NSString *) proName;

@end


/**
 *	
 */
@interface ProShortView : UIView{
    UIButton    *backBtn;
    CGRect       orginFrame;
}

@property(nonatomic, weak) id<SelectedProDelegate>          delegate;

-(void) showInView:(UIView *) superView;
-(void) hiddenKeyBoard;
@end
