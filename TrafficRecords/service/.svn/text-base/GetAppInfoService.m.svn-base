//
//  GetAppInfoService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-9.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//
#import "GetAppInfoService.h"
#import "JSON.h"
#import "OpenUDID.h"

@implementation GetAppInfoService

@synthesize newestVersion;
@synthesize updateUrl;
@synthesize updateInfo;
@synthesize showScore;
@synthesize citysTimestamp;
@synthesize productionDBtimestamp;
@synthesize imageUrl;
@synthesize luKuangTimeStamp;
@synthesize activityImgUrl;
@synthesize activityUrl;
@synthesize activityTimestamp;
@synthesize commentUrl;
@synthesize showAdView;

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isShowNetHint = NO;
        self.isAddCache = YES;
        self.cacheTime = 60*5;
        self.reqTag = EServiceGetAppInfo;
        self.isUserKnow = NO;
        self.isSafeTranfer = YES;
		return self;
	}
	else
    {
		return nil;
	}
}

- (void) getAppInfo{
    NSString *limitNumTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:KLimitNumsTimestamp];
    if (limitNumTimeStamp == nil) {
        limitNumTimeStamp = @"";
    }
    else {
        limitNumTimeStamp = [TRUtility URLEncodedString:limitNumTimeStamp];
    }
    NSString * url = [NSString stringWithFormat:@"%@ashx/getAppInfo.ashx?limitNums_timestamp=%@&mac=%@&idfa=%@&deviceid=%@", KServerHost, limitNumTimeStamp, [TRUtility getMacAddress],[TRUtility IDFAString], [OpenUDID value]];
    if (KChannelId.length > 0) {
        url = [NSString stringWithFormat:@"%@&channel=%@", url,   [TRUtility URLEncodedString:KChannelId]];
    }
    if (self.isAddCache) {
        self.cacheKey = [TRUtility md5Value:url];
        NSString *ret = nil;
        BOOL getCacheSucess = NO;
        if (self.cacheKey.length > 0) {
            ret = [[EGOCache globalCache] stringForKey:self.cacheKey];
        }
        if (ret.length > 0){
            self.responseDic = ret.JSONValue;
            getCacheSucess  = [self parseJSON:self.responseDic];
        }
        if (getCacheSucess) {
            //需要异步通知
            [self performSelector:@selector(reqFinshed) withObject:nil afterDelay:0.0];
        } else {
            [self getData:url];
        }
    } else {
        [self getData:url];
    }
}

- (void) reqFinshed{
    if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:)])
    {
        [self.delegate netServiceFinished:self.reqTag];
    }
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSString * response = self.request.responseString;
//    response = [response stringByReplacingOccurrencesOfString:@"\\r\\n" withString:KChangeLine];
    NSDictionary *dic = [response JSONValue];
    
    NSDictionary * result = [dic objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    self.newestVersion = [result objectForKey:@"nowversion"];
    self.updateUrl = [result objectForKey:@"update_url"];
    self.updateInfo = [result objectForKey:@"info"];
    self.commentUrl = [result objectForKey:@"ioscomment_url"];
    NSString *show = [result objectForKey:@"showscore"];
    NSString *showad = [result objectForKey:@"showadview"];
    self.baoyangCitys = [result objectForKey:@"baoyang"];
    show = [show lowercaseString];
    if ([show isEqualToString:@"true"]) {
        self.showScore = YES;
    } else {
        self.showScore = NO;
    }
    showad = [showad lowercaseString];
    if ([showad isEqualToString:@"true"]) {
        self.showAdView = YES;
    } else {
        self.showAdView = NO;
    }
    self.citysTimestamp = [result objectForKey:@"citys_timestamp"];
    self.luKuangTimeStamp = [result objectForKey:@"map_timestamp"];
    NSString *limitNumTimeStamp = [result objectForKey:@"limitnums_timestamp"];
    self.productionDBtimestamp = [result objectForKey:@"productiondb_timestamp"];
    NSString *localLimitNum = [[NSUserDefaults standardUserDefaults] objectForKey:KLimitNumsTimestamp];
    
    self.activityImgUrl = [result objectForKey:@"activityimg_url"];
    self.activityUrl = [result objectForKey:@"activity_url"];
    self.activityTimestamp = [result objectForKey:@"activity_timestamp"];
    NSString *shareText = [result objectForKey:@"acrivityshare_info"];
    NSString *shareURL = [result objectForKey:@"acrivityshare_url"];
    NSString *shareIcon = [result objectForKey:@"acrivityshare_icon"];
    NSString *sharetitle = [result objectForKey:@"acrivityshare_title"];
    NSString *noPushInfo = [result objectForKey:@"nopushcity"];
    [[NSUserDefaults standardUserDefaults] setObject:(noPushInfo.length > 0 ? noPushInfo : @"") forKey:KNoPushCity];
    [[NSUserDefaults standardUserDefaults] setObject:(shareText.length > 0 ? shareText : @"") forKey:KActivityShareText];
    [[NSUserDefaults standardUserDefaults] setObject:(shareURL.length > 0 ? shareURL : @"") forKey:KActivityShareUrl];
    [[NSUserDefaults standardUserDefaults] setObject:(shareIcon.length > 0 ? shareIcon : @"") forKey:KActivityShareIconUrl];
    [[NSUserDefaults standardUserDefaults] setObject:(sharetitle.length > 0 ? sharetitle : @"") forKey:KActivityShareTitle];
    //缓存图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:shareIcon];
        if (url) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *key = [TRUtility md5Value:shareIcon];
            NSString *path = [TRUtility cacheFullPathByAppend:key];
            [data writeToFile:path atomically:YES];
        }
    });

    
    [[NSUserDefaults standardUserDefaults] setObject:(self.activityImgUrl.length > 0 ? self.activityImgUrl : @"") forKey:KActivityImgUrl];
    [[NSUserDefaults standardUserDefaults] setObject:(self.activityUrl.length > 0 ? self.activityUrl : @"") forKey:KActivityUrl];
    [[NSUserDefaults standardUserDefaults] setObject:(self.activityTimestamp.length > 0 ? self.activityTimestamp : @"") forKey:KActivityTimestamp2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.activityUrl.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_HaveActivity object:self];
    }
    
    NSString *imageURL = [result objectForKey:@"image_url"];
    NSString *lastUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KThemeImageChanged];
    if (imageURL.length > 0 && ![imageURL isEqualToString:lastUrl]) {
        self.imageUrl = imageURL;
        [[NSUserDefaults standardUserDefaults] setObject:imageURL forKey:KThemeImageChanged];
        //发送主题照片修改的广播
        [[NSNotificationCenter defaultCenter] postNotificationName:KThemeImageChanged object:self];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //本地限行时间戳与服务器不一致
    if (![localLimitNum isEqualToString:limitNumTimeStamp]) {
        NSArray * items = [result objectForKey:@"items"];
        NSString *xianXing = [items JSONRepresentation];
        [TRUtility writecontent:xianXing toFile:@"limitNum2.json"];
        [[NSUserDefaults standardUserDefaults] setObject:limitNumTimeStamp forKey:KLimitNumsTimestamp];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //发送新的限行数据达到的广播
        [[NSNotificationCenter defaultCenter] postNotificationName:KLimitNumsTimestamp object:self];
    }
    return YES;
}

@end
