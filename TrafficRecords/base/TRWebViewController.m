//
//  TRWebViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-26.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRWebViewController.h"

@interface TRWebViewController ()

@end

@implementation TRWebViewController
@synthesize url;
@synthesize title;

-(NSString *) naviTitle{
    return title;
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= KHeightReduce;
    webView = [[UIWebView alloc] initWithFrame: frame];
    webView.delegate = self;
    [self.view addSubview:webView];
	// Do any additional setup after loading the view.
    if (url) {
        NSURL *myUrl = [NSURL URLWithString:self.url];
        NSURLRequest *req = [NSURLRequest requestWithURL:myUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
        [webView loadRequest:req];
    }
}

-(void) setUrl:(NSString *)aurl{
    url = nil;
    url = aurl;
    NSURL *myUrl = [NSURL URLWithString:self.url];
    NSURLRequest *req = [NSURLRequest requestWithURL:myUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [webView loadRequest:req];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingViewAnimated:YES];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [self showInfoView:@"页面加载失败"];
    [self hideLoadingViewAnimated:YES];
}
@end
