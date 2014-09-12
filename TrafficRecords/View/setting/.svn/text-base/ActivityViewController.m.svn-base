//
//  ActivityViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-6-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "ActivityViewController.h"
#import "UMSocial.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController


-(NSString *) naviTitle{
    return @"精彩活动";
}

-(NSString *) naviRightIcon{
    return @"share.png";
}

- (void) naviRightClick:(id) sender{
    NSString *shareText = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareText];
    NSString *shareUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareUrl];
    NSString *shareIconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareIconUrl];
    NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareTitle];
    NSString *key = [TRUtility md5Value:shareIconUrl];
    NSString *path = [TRUtility cacheFullPathByAppend:key];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    UIImage *image = [UIImage imageWithData:data];
    if (image == nil) {
        NSURL *url = [NSURL URLWithString:shareIconUrl];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@&qd=qzone",shareUrl];
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qd=weixin",shareUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qd=weixin",shareUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:KUMengAppKey
                                      shareText:shareText
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina]
                                       delegate:self];

}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    if ([UMShareToSina isEqualToString:platformName]) {
        NSString *shareText = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareText];
        NSString *shareUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KActivityShareUrl];
        shareUrl = [NSString stringWithFormat:@"%@&qd=sina",shareUrl];
        socialData.shareText = [NSString stringWithFormat:@"%@%@", shareText, shareUrl];
    }
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
