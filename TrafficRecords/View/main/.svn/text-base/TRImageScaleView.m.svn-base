//
//  TRImageScaleView.m
//  TrafficRecords
//
//  Created by qiao on 14-5-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRImageScaleView.h"

@implementation TRImageScaleView

-(id) initWithFrame:(CGRect)frame Image:(UIImage *) image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // Initialization code
        float imageH = (image.size.height/image.size.width) * self.width;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height/2 - imageH/2, self.width, imageH)];
        imageView.image = image;
        [self addSubview:imageView];
        
        imgStartWidth=imageView.frame.size.width;
        imgStartHeight=imageView.frame.size.height;
        
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];
        
        UIImage *closeiamge = TRImage(@"closePic.png");
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.width - 12 - 44, 12, 44, 44);
        [btn setImage:closeiamge forState:UIControlStateNormal];
//        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void) closeBtnClick:(id) sender{
    [self removeFromSuperview];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
//    - (NSUInteger)numberOfTouches;                                          // number of touches involved for which locations can be queried
//    - (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(UIView*)view;
    CGPoint currentTouchPoint = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = currentTouchPoint;
        orginPoint = CGPointMake(imageView.left, imageView.top);
        beginTouchCount = [recognizer numberOfTouches];
    } else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint p1;
        CGPoint p2;
        CGFloat sub_x;
        CGFloat sub_y;
        CGFloat currentDistance;
        CGRect imgFrame;
        int touchCount = [recognizer numberOfTouches];
        //    NSLog(@"%@",touchesArr);
        
        if (touchCount >= 2) {
            beginTouchCount = touchCount;
            p1=  [recognizer locationOfTouch:0 inView:self];//[[touchesArr objectAtIndex:0] locationInView:self];
            p2=  [recognizer locationOfTouch:1 inView:self];
            
            sub_x=p1.x-p2.x;
            sub_y=p1.y-p2.y;
            
            currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y) ;
            
            if (lastDistance>0) {
                
                imgFrame=imageView.frame;
                
                if (currentDistance>lastDistance) {
                    
                    imgFrame.size.width += (currentDistance  - lastDistance)*2;
                    if (imgFrame.size.width>2000) {
                        imgFrame.size.width=2000;
                    }
                    
                    lastDistance=currentDistance;
                }
                if (currentDistance<lastDistance) {
                    imgFrame.size.width += (currentDistance  - lastDistance)*2;
                    
                    if (imgFrame.size.width < 50) {
                        imgFrame.size.width=50;
                    }
                    
                    lastDistance=currentDistance;
                }
                imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                
                float addwidth=imgFrame.size.width-imageView.frame.size.width;
                float addheight=imgFrame.size.height-imageView.frame.size.height;
                
                imageView.frame=CGRectMake(imageView.origin.x-addwidth/2.0f, imageView.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
                
            }else {
                lastDistance=currentDistance;
            }
            
        } else if(touchCount ==1 && beginTouchCount == 1){
            CGPoint point = currentTouchPoint;
            CGPoint newTl = CGPointMake(orginPoint.x + (point.x - startPoint.x), orginPoint.y + (point.y - startPoint.y));
            if (imageView.width >= self.width) {
                if (newTl.x > 0) {
                    newTl.x = 0;
                } else if(newTl.x < 0 && newTl.x + imageView.width < self.width){
                    newTl.x = self.width - imageView.width;
                }
            } else {
                if (newTl.x < 0) {
                    newTl.x = 0;
                }else if(newTl.x + imageView.width > self.width){
                    newTl.x = self.width - imageView.width;
                }
            }
            if (imageView.height >= self.height) {
                if (newTl.y > 0) {
                    newTl.y = 0;
                } else if(newTl.y < 0 && newTl.y + imageView.height < self.height){
                    newTl.y = self.height - imageView.height;
                }
            } else {
                if (newTl.y < 0) {
                    newTl.y = 0;
                } else if(newTl.y + imageView.height > self.height){
                    newTl.y = self.height - imageView.height;
                }
            }
            
            imageView.frame = CGRectMake(newTl.x, newTl.y, imageView.width, imageView.height);
        }

    } else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        lastDistance=0;
        beginTouchCount = 0;
    }
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//	CGPoint p1;
//	CGPoint p2;
//	CGFloat sub_x;
//	CGFloat sub_y;
//	CGFloat currentDistance;
//	CGRect imgFrame;
//	
//	NSArray * touchesArr=[[event allTouches] allObjects];
//	
//    //    NSLog(@"%@",touchesArr);
//	
//	if ([touchesArr count]>=2) {
//        beginTouchCount = [touchesArr count];
//		p1=[[touchesArr objectAtIndex:0] locationInView:self];
//		p2=[[touchesArr objectAtIndex:1] locationInView:self];
//		
//		sub_x=p1.x-p2.x;
//		sub_y=p1.y-p2.y;
//		
//		currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y) ;
//		
//		if (lastDistance>0) {
//			
//			imgFrame=imageView.frame;
//			
//			if (currentDistance>lastDistance) {
//				
//				imgFrame.size.width += (currentDistance  - lastDistance)*2;
//				if (imgFrame.size.width>2000) {
//					imgFrame.size.width=2000;
//				}
//				
//				lastDistance=currentDistance;
//			}
//			if (currentDistance<lastDistance) {
//				imgFrame.size.width += (currentDistance  - lastDistance)*2;
//				
//				if (imgFrame.size.width < 50) {
//					imgFrame.size.width=50;
//				}
//				
//				lastDistance=currentDistance;
//			}
//            imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
//            
//            float addwidth=imgFrame.size.width-imageView.frame.size.width;
//            float addheight=imgFrame.size.height-imageView.frame.size.height;
//            
//            imageView.frame=CGRectMake(imageView.origin.x-addwidth/2.0f, imageView.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
//			
//		}else {
//			lastDistance=currentDistance;
//		}
//        
//	} else if([touchesArr count] ==1 && beginTouchCount == 1){
//        UITouch *touch = [touches anyObject];
//        CGPoint point = [touch locationInView:self];
//        CGPoint newTl = CGPointMake(orginPoint.x + (point.x - startPoint.x), orginPoint.y + (point.y - startPoint.y));
//        if (imageView.width >= self.width) {
//            if (newTl.x > 0) {
//                newTl.x = 0;
//            } else if(newTl.x < 0 && newTl.x + imageView.width < self.width){
//                newTl.x = self.width - imageView.width;
//            }
//        } else {
//            if (newTl.x < 0) {
//                newTl.x = 0;
//            }else if(newTl.x + imageView.width > self.width){
//                newTl.x = self.width - imageView.width;
//            }
//        }
//        if (imageView.height >= self.height) {
//            if (newTl.y > 0) {
//                newTl.y = 0;
//            } else if(newTl.y < 0 && newTl.y + imageView.height < self.height){
//                newTl.y = self.height - imageView.height;
//            }
//        } else {
//            if (newTl.y < 0) {
//                newTl.y = 0;
//            } else if(newTl.y + imageView.height > self.height){
//                newTl.y = self.height - imageView.height;
//            }
//        }
//
//        imageView.frame = CGRectMake(newTl.x, newTl.y, imageView.width, imageView.height);
//    }
//}
//
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    startPoint = [touch locationInView:self];
//    orginPoint = CGPointMake(imageView.left, imageView.top);
//    beginTouchCount = [[event allTouches] allObjects].count;
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//	lastDistance=0;
//    beginTouchCount = 0;
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    lastDistance=0;
//    beginTouchCount = 0;
//}
@end
