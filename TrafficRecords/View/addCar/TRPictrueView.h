//
//  XMPictrueView.h
//  XMXiangMai
//
//  Created by Kevin Zhang on 12-11-19.
//  Copyright (c) 2012年 Kevin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPictrueView : UIView{
    UIImageView*    imageView;
    BOOL             isDraged;
    CGRect           initRect;
}

-(id) initWithImage:(NSString*) imageName;
-(id) initWithImage2:(UIImage*) imageName;

-(void) show;
-(void) showAtFrame:(CGRect) rect;
@end
