//
//  DAСontextMenuCell.h
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DAContextMenuCell;

@protocol DAContextMenuCellDelegate <NSObject>

@required
- (BOOL)shouldShowMenuOptionsViewInCell:(DAContextMenuCell *)cell;

@optional
- (void)contextMenuDidHideInCell:(DAContextMenuCell *)cell;
- (void)contextMenuDidShowInCell:(DAContextMenuCell *)cell;
- (void)contextMenuWillHideInCell:(DAContextMenuCell *)cell;
- (void)contextMenuWillShowInCell:(DAContextMenuCell *)cell;
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell;
- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell;
- (void)cellWillShow:(DAContextMenuCell *) cell;
-(void) cellDidSelect:(DAContextMenuCell *) cell;
@end


@interface DAContextMenuCell : UIView

@property (strong, nonatomic) IBOutlet UIView *actualContentView;
@property (nonatomic, retain) IBOutlet UIView      *contentView;
@property (nonatomic, assign) BOOL  selected;

@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;

@property (weak, nonatomic) id<DAContextMenuCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;

@end
