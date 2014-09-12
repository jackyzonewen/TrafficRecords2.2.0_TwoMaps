//
//  UMContactViewController.h
//  Demo
//
//  Created by liuyu on 4/2/13.
//  Copyright (c) 2013 iOS@Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRBaseViewController.h"

@protocol UMContactViewControllerDelegate;

@interface UMContactViewController : TRBaseViewController

@property(nonatomic, retain) IBOutlet UITextField *textView;
@property(nonatomic, assign) id <UMContactViewControllerDelegate> delegate;

@end

@protocol UMContactViewControllerDelegate <NSObject>

@optional

- (void)updateContactInfo:(UMContactViewController *)controller contactInfo:(NSString *)info;

@end