//
//  LoadingViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-12-31.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = TRImage(@"themeImage.png");
    imageView.alpha = 0;
    [self.view addSubview:imageView];
    
    
    UIImage *image = TRImage(@"Splash_Logo.png");
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    [imageView2 setTop:self.view.height - image.size.height];
    [self.view addSubview:imageView2];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        imageView.alpha = 1;
    } completion: ^(BOOL finished){
        [UIView animateWithDuration:15 animations:^{
            imageView.frame = CGRectMake(-self.view.width/2, -self.view.height/2, self.view.width*2, self.view.height*2);
        }];
    }];
    
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    imageView.frame = self.view.bounds;
//    imageView.alpha = 1;
//    [UIView commitAnimations];
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.alpha = 1;
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
