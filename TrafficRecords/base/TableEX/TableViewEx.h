/*!
 @header    TableViewEx.h
 @abstract  扩展的TableView
 @author    张洁
 @version   2.5.0 2013/05/07 Creation 
 */

#import <UIKit/UIKit.h>


@interface TableViewEx : UITableView<UIGestureRecognizerDelegate>
{
    BOOL    inShowing;
    BOOL    firstMove;
}

/*!
 @property
 @abstract 可同时被移动的父View
 */
@property (nonatomic, weak) UIView *moveSuperView;

/*!
 @method
 @abstract  列表收缩到原位
 */
- (void)restoreViewLocation;
/*!
 @method
 @abstract  列表展开
 */
- (void)contractionRestoreViewLocation;

- (void)contractionNoAnimation;

- (void)BeganMove:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)Moving:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)EndedMove:(NSSet *)touches withEvent:(UIEvent *)event;
@end


