//
//  AboutUsViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-23.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TRWebViewController.h"

#import "TRProxyTask.h"


@interface AboutUsViewController ()

@end

@implementation AboutUsViewController


-(NSString *) naviTitle{
    return @"关于我们";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    if (kSystemVersion >= 7.0) {
        for (UIView *subView in self.view.subviews) {
            [subView setTop:subView.top + KDefaultStartY];
        }
    }
    NSString *version = [TRUtility clientVersion];
    self.version.text = [NSString stringWithFormat:@"V%@", version];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)agreeBtnClick:(id)sender{
    TRWebViewController *webView = [[TRWebViewController alloc] init];
    webView.url = [NSString stringWithFormat:@"%@info.html", KServerHost];
    webView.title = @"服务协议";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navi animated:YES completion:nil];
    
//    NSString *str = @"GET http://www.hbgajg.com/phone/szjj/srhJdc?hphm=%E5%86%80ALK739&hphm_4=%E5%B0%8F%E5%9E%8B%E6%B1%BD%E8%BD%A6&yzm=52447&sshyzm=pNgd4UYPlFwl4EvZnBvPpBvs HTTP/1.1\r\nHost: www.hbgajg.com\r\nConnection: close\r\nUser-Agent: Apache-HttpClient/UNAVAILABLE (java 1.4)\r\n\r\n";
//    TRProxyTask *task = [[TRProxyTask alloc] init];
//    task.carID = @"12345";
//    task.cityId = @"10010";
//    task.step = @"1";
//    task.taskHost = @"www.hbgajg.com";
//    task.taskPort = @"80";
//    task.taskData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [task startTask];
//    myTask = task;
}
@end
