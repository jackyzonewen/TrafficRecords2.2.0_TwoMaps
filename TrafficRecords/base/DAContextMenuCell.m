//
//  DAСontextMenuCell.m
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAContextMenuCell.h"

@interface DAContextMenuCell () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIButton *moreOptionsButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end


@implementation DAContextMenuCell

@synthesize contentView;
@synthesize selected;

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    self.contextMenuView = [[UIView alloc] initWithFrame:self.actualContentView.bounds];
    self.contextMenuView.backgroundColor = self.contentView.backgroundColor;
    [self.contentView insertSubview:self.contextMenuView belowSubview:self.actualContentView];
    self.contextMenuHidden = self.contextMenuView.hidden = YES;
    self.shouldDisplayContextMenuView = NO;
    self.editable = YES;
//    self.moreOptionsButtonTitle = @"置顶";
    self.deleteButtonTitle = @"编辑";
    self.menuOptionButtonTitlePadding = 25.;
    self.menuOptionsAnimationDuration = 0.3;
    self.bounceValue = 30.;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
//    UIView * alphaView = [[UIView alloc] initWithFrame:CGRectZero];
    UIButton *alphaView = [UIButton buttonWithType:UIButtonTypeCustom];
    [alphaView addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    alphaView.backgroundColor = [UIColor clearColor];
    alphaView.tag = 100;
    [self.actualContentView addSubview:alphaView];
    [alphaView addGestureRecognizer:panRecognizer];
    [self setNeedsLayout];
}

#pragma mark - Public

-(void) btnclick:(id) sender{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidSelect:)]) {
        [_delegate cellDidSelect:self];
    }
}

- (CGFloat)contextMenuWidth
{
    return CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.moreOptionsButton.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView * alphaView = [self viewWithTag:100];
    alphaView.frame = CGRectMake(0, 0, self.bounds.size.width - 30, self.bounds.size.height);
    self.contextMenuView.frame = self.actualContentView.bounds;
    [self.contentView sendSubviewToBack:self.contextMenuView];
    [self.contentView bringSubviewToFront:self.actualContentView];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat menuOptionButtonWidth = [self menuOptionButtonWidth];
    self.moreOptionsButton.frame = CGRectMake(width - menuOptionButtonWidth * 2, 0., menuOptionButtonWidth, height);
    self.deleteButton.frame = CGRectMake(width - menuOptionButtonWidth, 0., menuOptionButtonWidth, height);
    if (_delegate && [_delegate respondsToSelector:@selector(cellWillShow:)]) {
        [_delegate cellWillShow:self];
//        [(NSObject*) _delegate performSelector:@selector(cellWillShow:) withObject:self afterDelay:0.3];
    }
}

- (CGFloat)menuOptionButtonWidth
{
    NSString *string = ([self.deleteButtonTitle length] > [self.moreOptionsButtonTitle length]) ? self.deleteButtonTitle : self.moreOptionsButtonTitle;
    CGFloat width = roundf([string sizeWithFont:self.deleteButton.titleLabel.font].width + 2. * self.menuOptionButtonTitlePadding);
    width = MIN(width, CGRectGetWidth(self.bounds) / 2. - 10.);
    if ((NSInteger)width % 2) {
        width += 1.;
    }
    return width;
}

- (void)setDeleteButtonTitle:(NSString *)deleteButtonTitle
{
    _deleteButtonTitle = deleteButtonTitle;
    [self.deleteButton setTitle:deleteButtonTitle forState:UIControlStateNormal];
    [_deleteButton.titleLabel setFont:[TRSkinManager mediumFont2]];
    [_deleteButton setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];

    [_deleteButton setImageEdgeInsets:UIEdgeInsetsMake( -28, 0.0,0.0, -_deleteButton.titleLabel.bounds.size.width)];
    [self setNeedsLayout];
}

- (void)setEditable:(BOOL)editable
{
    if (_editable != editable) {
        _editable = editable;
        [self setNeedsLayout];
    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    if (self.contextMenuHidden) {
//        self.contextMenuView.hidden = YES;
//        [super setHighlighted:highlighted animated:animated];
//    }
//}

- (void)setMenuOptionButtonTitlePadding:(CGFloat)menuOptionButtonTitlePadding
{
    if (_menuOptionButtonTitlePadding != menuOptionButtonTitlePadding) {
        _menuOptionButtonTitlePadding = menuOptionButtonTitlePadding;
        [self setNeedsLayout];
    }
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{
    if (self.selected) {
        [self setSelected:NO];
    }
    CGRect frame = CGRectMake((hidden) ? 0 : -[self contextMenuWidth], 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? self.menuOptionsAnimationDuration : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.actualContentView.frame = frame;
//         self.contextMenuView.hidden = hidden;
     } completion:^(BOOL finished) {
         self.contextMenuHidden = hidden;
         self.shouldDisplayContextMenuView = !hidden;
         
         if (!hidden) {
             [self.delegate contextMenuDidShowInCell:self];
         } else {
             [self.delegate contextMenuDidHideInCell:self];
         }
         if (completionHandler) {
             completionHandler();
         }
     }];
}

- (void)setMoreOptionsButtonTitle:(NSString *)moreOptionsButtonTitle
{
    _moreOptionsButtonTitle = moreOptionsButtonTitle;
    [self.moreOptionsButton setTitle:self.moreOptionsButtonTitle forState:UIControlStateNormal];
    [_moreOptionsButton.titleLabel setFont:[TRSkinManager mediumFont2]];
    [_moreOptionsButton setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
    [_moreOptionsButton setImageEdgeInsets:UIEdgeInsetsMake( -28, 0.0,0.0, -_moreOptionsButton.titleLabel.bounds.size.width)];
    [self setNeedsLayout];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    if (self.contextMenuHidden) {
//        self.contextMenuView.hidden = YES;
//        [super setSelected:selected animated:animated];
//    }
//}

#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.initialTouchPositionX = currentTouchPositionX;
            if (velocity.x > 0) {
                [self.delegate contextMenuWillHideInCell:self];
            } else {
                [self.delegate contextMenuDidShowInCell:self];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint velocity = [recognizer velocityInView:self.contentView];
            if (!self.contextMenuHidden || (velocity.x > 0. || [self.delegate shouldShowMenuOptionsViewInCell:self])) {
                if (self.selected) {
                    [self setSelected:NO];
                }
                self.contextMenuView.hidden = NO;
                CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                self.initialTouchPositionX = currentTouchPositionX;
                CGFloat minOriginX = -[self contextMenuWidth] - self.bounceValue;
                CGFloat maxOriginX = 0.;
                CGFloat originX = CGRectGetMinX(self.actualContentView.frame) + panAmount;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                
                if ((originX < -0.5 * [self contextMenuWidth] && velocity.x < 0.) || velocity.x < -100) {
                    self.shouldDisplayContextMenuView = YES;
                } else if ((originX > -0.3 * [self contextMenuWidth] && velocity.x > 0.) || velocity.x > 100) {
                    self.shouldDisplayContextMenuView = NO;
                }
                self.actualContentView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completionHandler:nil];
        }
    }
}

- (void)deleteButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)]) {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

- (void)moreButtonTapped
{
    [self.delegate contextMenuCellDidSelectMoreOption:self];
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
//}

#pragma mark * Lazy getters

- (UIButton *)moreOptionsButton
{
    return nil;
    if (!_moreOptionsButton) {
        CGRect frame = CGRectMake(0., 0., 100., CGRectGetHeight(self.actualContentView.frame));
        _moreOptionsButton = [[UIButton alloc] initWithFrame:frame];
        _moreOptionsButton.backgroundColor = [TRSkinManager bgColorDark];
        UIImage *image = TRImage(@"gotop.png");
        [_moreOptionsButton setImage:image forState:UIControlStateNormal];
        [_moreOptionsButton setTitleEdgeInsets:UIEdgeInsetsMake( 28, -image.size.width, 0.0,0.0)];
        [self.contextMenuView addSubview:_moreOptionsButton];
        [_moreOptionsButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreOptionsButton;
}

- (UIButton *)deleteButton
{
    if (self.editable) {
        if (!_deleteButton) {
            CGRect frame = CGRectMake(0., 0., 100., CGRectGetHeight(self.actualContentView.frame));
            _deleteButton = [[UIButton alloc] initWithFrame:frame];
            _deleteButton.backgroundColor = [TRSkinManager colorWithInt:0x5e5e5e];
            [_deleteButton setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager colorWithInt:0x4d4c4c]] forState:UIControlStateHighlighted];
            UIImage *image = TRImage(@"edit.png");
            [_deleteButton setImage:image forState:UIControlStateNormal];
            [_deleteButton setImage:image forState:UIControlStateHighlighted];
            [_deleteButton setTitleEdgeInsets:UIEdgeInsetsMake( 28, -image.size.width, 0.0,0.0)];
            [_deleteButton setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
            
            
            [self.contextMenuView addSubview:_deleteButton];
            [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _deleteButton;
    }
    return nil;
}

#pragma mark * UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

@end