/*!
 @header    TableViewEx.m
 @abstract  扩展的TableView
 @author    张洁
 @version   2.5.0 2013/05/07 Creation
 */

#import "TableViewEx.h"
#import "UIView+ViewFrameGeometry.h"


@interface TableViewEx()
{
    CGPoint oldOrigin;      //老的起始坐标
    CGPoint touchBeganPoint;
}

/*!
 @property
 @abstract 老的起始坐标
 */
@property (nonatomic, assign) CGPoint oldOrigin;

@end


@implementation TableViewEx

@synthesize oldOrigin;
@synthesize moveSuperView;


- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.delaysContentTouches = NO;
        oldOrigin = self.origin;
        moveSuperView = self;
    }
    
    return self;
}


- (void)setMoveSuperView:(UIView *)superView
{
    moveSuperView = superView;
    oldOrigin = superView.origin;
}


- (void)BeganMove:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.scrollEnabled = NO;
    UITouch *touch = [touches anyObject];
    touchBeganPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
    firstMove = YES;
//    [super touchesBegan:touches withEvent:event];
}


- (void)Moving:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.scrollEnabled = NO;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
    float movX = touchPoint.x - touchBeganPoint.x;
    float movY = touchPoint.y - touchBeganPoint.y;
    movX = ABS(movX) *1.5;
    movY = ABS(movY);
    if (movX > movY && firstMove) {
        self.scrollEnabled = NO;
    } else if(movX <= movY && firstMove){
        self.scrollEnabled = YES;
    }
    if (self.scrollEnabled) {
        return;
    }
    firstMove = NO;
    CGFloat xOffSet = touchPoint.x - touchBeganPoint.x + oldOrigin.x;
    if (xOffSet < moveSuperView.width / 2)
    {
        return;
    }
    if (xOffSet > 2)
    {
//        self.scrollEnabled = NO;
    }
    moveSuperView.frame = CGRectMake(xOffSet, 
                                     moveSuperView.origin.y, 
                                     moveSuperView.size.width, 
                                     moveSuperView.size.height);
//    [super touchesMoved:touches withEvent:event];
}


- (void)EndedMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (moveSuperView.frame.origin.x > oldOrigin.x + moveSuperView.width / 2)
    {
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             [moveSuperView setHidden:YES];
                             self.superview.superview.frame =
                             CGRectMake(oldOrigin.x + moveSuperView.width, oldOrigin.y,
                                        moveSuperView.size.width,
                                        moveSuperView.size.height);
                         }
                         completion:^(BOOL finished){
                             [moveSuperView setHidden:YES];
                             //取消选中
                             //[self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
                         }];
    }
    else
    {
        [self restoreViewLocation];
    }
    self.scrollEnabled=YES;
//    [super touchesEnded:touches withEvent:event];
}


- (void)restoreViewLocation
{
    [moveSuperView setHidden:NO];
    inShowing = YES;
    [moveSuperView becomeFirstResponder];
    [UIView animateWithDuration:0.3 
                     animations:^{
                         moveSuperView.frame =
                         CGRectMake(oldOrigin.x, oldOrigin.y,
                                    moveSuperView.size.width, 
                                    moveSuperView.size.height);
                     }
                     completion:^(BOOL finished){
                         inShowing = NO;
                     }];
}


- (void)contractionRestoreViewLocation
{    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [moveSuperView setHidden:YES];
                         moveSuperView.frame =
                         CGRectMake(oldOrigin.x + moveSuperView.width, oldOrigin.y,
                                    moveSuperView.size.width, 
                                    moveSuperView.size.height);
                     }
                     completion:^(BOOL finished){
                         if (!inShowing) {
                             [moveSuperView setHidden:YES];
                         }
                         //取消选中
                         //[sef deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
                     }];
}

- (void)contractionNoAnimation{
    [moveSuperView setHidden:YES];
    moveSuperView.frame = CGRectMake(oldOrigin.x + moveSuperView.width, oldOrigin.y,
               moveSuperView.size.width,
               moveSuperView.size.height);
}

@end
