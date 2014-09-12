//
//  UrlImageButton.m
//  test image
//
//  Created by Xuyan Yang on 8/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UrlImageView.h"
#import "NSURLAdditions.h"
#import "SDWebImageManager.h"
#import <QuartzCore/QuartzCore.h>

@interface UIImage (scale)  

-(UIImage*)scaleToSize:(CGSize)size;  

@end  

@implementation UIImage (scale)  

-(UIImage*)scaleToSize:(CGSize)size  
{  
    // 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
	
    // 绘制改变大小的图片  
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];  
	
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
	
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
	
    // 返回新的改变大小后的图片  
    return scaledImage;  
}  

@end  

@implementation UrlImageView

@synthesize iconIndex;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		iconIndex = -1;

		isScale= NO;
		_animated = NO;
		scaleSize = CGSizeZero;
	}
    return self;
}

- (void)dealloc {
	
	[super dealloc];
}

//todo:zj这段代码统统改掉
-(UIImage*) getDefaultImage
{
	return TRImage(@"brandHolder.png");
}


- (void) setImageFromUrl:(BOOL)animated withUrl:(NSString *)iconUrl;
{       	

	_animated = animated;
	
	NSURL* tempUrl = [NSURL URLWithString:iconUrl];
	
	NSURL* finallyUrl = nil;
	if([NSURL isWebURL:tempUrl])
	{
		finallyUrl = tempUrl;
	}
	else {
		//SingletonState* mySingle = [SingletonState sharedStateInstance];
		//finallyUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mySingle.letaoConstants.imageHostName, iconUrl]];
	}

	
	[self setImageWithURL:finallyUrl placeholderImage:[self getDefaultImage]];
	
}	

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
	
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
	
    self.image = placeholder;
	
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
	
}

- (void)cancelCurrentImageLoad
{
	[[SDWebImageManager sharedManager] cancelForDelegate:self];
}

-(void)scaleToSize:(CGSize)size 
{
	isScale= YES;
	scaleSize =size;
	UIImage* newImage = [self.image scaleToSize:size];
	self.image = newImage;
}
	

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
	if(_animated)
	{
        CATransition *animation = [CATransition animation];
		[animation setDuration:0.9f];   
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		[animation setType:kCATransitionFade];
		[animation setSubtype: kCATransitionFromBottom];
		[self.layer addAnimation:animation forKey:@"Reveal"];
	}
}




@end
