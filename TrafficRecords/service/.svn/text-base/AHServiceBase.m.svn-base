/*!
 @header    AHServiceBase.m
 @abstract  网络服务基类
 @author    张洁
 @version   2.4.0 2013/03/14 Creation
 */

#import "AHServiceBase.h"
#import "ASIFormDataRequest.h"
#import "TRReachability.h"
#import "JSON.h"
#import "TRUtility.h"
#import "AHToastView2.h"
#import <Foundation/NSJSONSerialization.h>

static UIAlertView *globAlertView = nil;

@implementation AHServiceBase

@synthesize request;
@synthesize isAddCache;
@synthesize delegate;
@synthesize reqTag;
@synthesize isShowNetHint;
@synthesize cacheKey;
@synthesize responseDic;
@synthesize cacheTime;
@synthesize isSafeTranfer;
@synthesize isUserKnow;

- (id)init
{
    self = [super init];
	if (self)
	{
        isSafeTranfer = NO;
        isShowNetHint = YES;
        isAddCache = NO;
        isUserKnow = YES;
        self.cacheTime = 604800;//7day
        timeErrCount = 0;
		return self;
	}
	else
    {
		return nil;
	}
}

- (BOOL)parseJSON:(NSDictionary*)strJSON
{
    return YES;
}


//分发出错信息给委托
- (void)notifyNetServiceError:(AHServiceRequestTag) tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage
{
    PLog(@"error=====request=====%@",[request url]);
    //显示提示
    if (isShowNetHint)
    {
        if ( [errorMessage isKindOfClass:[NSNull class]] || errorMessage == nil || errorMessage.length == 0 || errorCode > -80)
        {
            [self showHintView:UNKNOWN_ERROR];
        }
        else
        {
            [self showHintView:errorMessage];
        }
    }
    
    if (delegate && [delegate respondsToSelector:@selector(netServiceError: errorCode: errorMessage:)])
    {
        //把错误传递出去
        if (errorMessage == nil
            || [errorMessage isKindOfClass:[NSNull class]]
            || errorMessage.length == 0)
        {
            [delegate netServiceError:tag errorCode:errorCode errorMessage:UNKNOWN_ERROR];
        }
        else
        {
            [delegate netServiceError:tag errorCode:errorCode errorMessage:errorMessage];
        }
    }
}


//显示提示信息
- (void)showHintView:(NSString *)message
{
    UIWindow *window = [TRAppDelegate appDelegate].window;
    AHToastView2 *nv = (AHToastView2 *)[window viewWithTag:1019];
    if (nv) {
        [nv hiddenView];
    }
    nv = [[AHToastView2 alloc] init];
    nv.text = message;
    nv.tag = 1019;
    [nv show];
}


#pragma mark ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)aRequest
{
    PLog(@"requestStarted    url: %@", aRequest.url);
	if(delegate && [delegate respondsToSelector:@selector(netServiceStarted:)]) {
		[delegate netServiceStarted:reqTag];
	}
}


- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    @try {
        NSString * response = aRequest.responseString;
        NSLog(@"%@", response);
        NSDictionary *dic = [response JSONValue];
        self.responseDic = dic;
        if (dic == nil)
        {
            //如果不是一个有效的json数据，则认为是出错了  禁驶 
            [self notifyNetServiceError:reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
            return;
        }
        
        int successFlag = [[dic valueForKey:@"returncode"] intValue];
        //时间戳超出误差范围
        if (successFlag == -71 && self.isSafeTranfer) {
            if (timeErrCount >= 1) {
                [self notifyNetServiceError:reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                timeErrCount++;
                NSString *serverTime = [AHServiceBase getServerTime];
                NSTimeInterval localTime = [[NSDate date] timeIntervalSince1970];
                NSTimeInterval timeDetal = [serverTime floatValue] - localTime;
                if (serverTime.length == 0) {
                    timeDetal = 0;
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (int)timeDetal] forKey:KLocalServerTimeDelta];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [parasDic setObject:[NSString stringWithFormat:@"%d", (int)(timeDetal + localTime)] forKey:@"_timestamp"];
                NSString *md5 = [self md5EncodeParas:parasDic];
                
                NSString *url = aRequest.url.absoluteString;
                NSRange range = [url rangeOfString:@"?"];
                NSString *parastr = [url substringFromIndex:range.location + range.length];
                url = [url substringToIndex:range.location + range.length];
                NSArray *array = [parastr componentsSeparatedByString:@"&"];
                for (NSString *str in array) {
                    if ([str hasPrefix:@"_timestamp"]) {
                        url = [url stringByAppendingFormat:@"&_timestamp=%@", [NSString stringWithFormat:@"%d", (int)(timeDetal + localTime)]];
                    } else if([str hasPrefix:@"_sign"]){
                        url = [url stringByAppendingFormat:@"&_sign=%@", md5];
                    } else {
                        url = [url stringByAppendingFormat:@"&%@", str];
                    }
                }
                [aRequest redirectToURL:[NSURL URLWithString:url]];
//                aRequest.url = [NSURL URLWithString:url];
//                [aRequest retryUsingNewConnection];
            });
            return;
        }
        if (0 != successFlag)
        {
            
            //如果服务器返回错误的代码，则处理为出错
            [self notifyNetServiceError:reqTag errorCode:successFlag errorMessage:[dic valueForKey:@"message"]];
            return;
        }
        
        if (self.isAddCache)
        {
            if ([dic isKindOfClass:[NSDictionary class]])
            {
                //添加缓存
                if (self.cacheKey.length > 0) {
                    [[EGOCache globalCache] setString:response forKey:self.cacheKey withTimeoutInterval:self.cacheTime];
                } else {
                    NSString *md5 = [TRUtility md5Value:aRequest.url.absoluteString];
                    [[EGOCache globalCache] setString:response forKey:md5 withTimeoutInterval:self.cacheTime];
                }
            }
        }
        if ([self parseJSON:self.responseDic])
        {
            if(delegate && [delegate respondsToSelector:@selector(netServiceFinished:)])
            {
                [delegate netServiceFinished:reqTag];
            }
        }
        else
        {
            [self notifyNetServiceError:reqTag errorCode:successFlag errorMessage:NETPARSER_BAD];
        }
    }
    @catch (NSException *exception) {
        //解析出错，把错误传递出去
        [self notifyNetServiceError:reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    //解析出错，把错误传递出去
    NSError *error = [aRequest error];
   // NSString *errorMessage = [NSString stringWithFormat:@"%@［错误码：%d］", NETWORK_BAD, [error code]];
    [self notifyNetServiceError:reqTag errorCode:((int)[error code]) errorMessage:NETWORK_BAD];
}

- (void)setRequest:(ASIFormDataRequest *)aRequest
{
    if (request != nil)
    {
        [request clearDelegatesAndCancel];
        request = nil;
    }
	request = aRequest;
}


- (void)cancelRequest
{
    if (request != nil)
    {
        [request cancel];
    }
}


- (NSString *)md5EncodeParas:(NSDictionary *)paras
{
    //保存，在returncode == -71时使用
    parasDic = nil;
    parasDic = [NSMutableDictionary dictionaryWithDictionary:paras];

    NSMutableString *parasText = [NSMutableString string];
    NSArray *keys = [paras allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *key in sortedArray) {
        [parasText appendString:key];
        NSString *value = [paras objectForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%d", [value intValue]];
        }
        NSString *decodeValue = [TRUtility URLDecodedString:value];
        [parasText appendString:decodeValue];
    }
    [parasText insertString:KSerctAppKey atIndex:0];
    [parasText appendString:KSerctAppKey];
    NSString *md5 = [TRUtility md5Value:parasText];
    return md5;
}

-(BOOL) checkNetWorkOpened{
    if([TRReachability reachabilityForInternetConnection].currentReachabilityStatus == kNotReachable)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate netServiceError:self.reqTag errorCode:-1 errorMessage:@""];
        });
        if (isUserKnow) {
            if (globAlertView == nil) {
                globAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您当前的网络尚未打开，请在设置中打开wifi或移动网络。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [globAlertView show];
            }
        }

        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    globAlertView = nil;
}

- (void)getData:(NSString *)postUrl
{
    if (![self checkNetWorkOpened]) {
        return ;
    }
    if (request != nil)
    {
        [request clearDelegatesAndCancel];
        request = nil;
    }
    NSString *url = [AHServiceBase addPublicPara:postUrl];
    
    if (self.isSafeTranfer) {
        NSDictionary *paras = [AHServiceBase getAllParas:url];
        NSString *md5 = [self md5EncodeParas:paras];
        url = [NSString stringWithFormat:@"%@&_sign=%@", url, md5];
    }
    NSURL *_url =[NSURL URLWithString:url];
	request = [[ASIFormDataRequest alloc]initWithURL:_url];
    [request addRequestHeader:@"USER_AGENT" value:KUserAgent];
    request.timeOutSeconds = 30;
    [request setShouldAttemptPersistentConnection:NO];
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
    [request startAsynchronous];
    
}


- (void)getData:(NSString *)postUrl queryFromCache:(BOOL)isQueryFromCache
{
    if (![self checkNetWorkOpened]) {
        return ;
    }
    if (request != nil)
    {
        [request clearDelegatesAndCancel];
        request = nil;
    }
    NSString *url = [AHServiceBase addPublicPara:postUrl];
    if (self.isSafeTranfer) {
        NSDictionary *paras = [AHServiceBase getAllParas:url];
        NSString *md5 = [self md5EncodeParas:paras];
        url = [NSString stringWithFormat:@"%@&_sign=%@", url, md5];
    }
    
	request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = 30;
    [request setShouldAttemptPersistentConnection:NO];
    [request addRequestHeader:@"USER_AGENT" value:KUserAgent];
    if (isQueryFromCache)
    {
        [self getCacheData];
    }
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
    [request startAsynchronous];
}


- (void)sendPost:(NSString *)postUrl Dictinary:(NSMutableDictionary *)dic ImageArray:(NSMutableArray *)imageArray
{
    if (![self checkNetWorkOpened]) {
        return ;
    }
    if (request != nil)
    {
        [request clearDelegatesAndCancel];
        request = nil;
    }
    NSString *url = [AHServiceBase addPublicPara:postUrl];
    
    if (self.isSafeTranfer) {
        NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithDictionary:[AHServiceBase getAllParas:url]];
        [paras addEntriesFromDictionary:dic];
        NSString *md5 = [self md5EncodeParas:paras];
        url = [NSString stringWithFormat:@"%@&_sign=%@", url, md5];
    }
    
    request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"USER_AGENT" value:KUserAgent];
    request.timeOutSeconds = 45;
	[ASIFormDataRequest setShouldUpdateNetworkActivityIndicator:NO];
	[request setDelegate:self];
    
	for (NSString *key in [dic allKeys]) {
		[request addPostValue:[dic objectForKey:key] forKey:key];
	}
    
	if ([imageArray count] > 0) {
		int i = 1;
		for (UIImage *img in imageArray) {
			NSData *imageData = UIImageJPEGRepresentation(img, 100);
			[request addData:imageData withFileName:[NSString stringWithFormat:@"image%d", i] andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"image%d", i]];
			i = i + 1;
		}
	}
	[request setRequestMethod:@"POST"];
	[request startAsynchronous];
}

//取缓存
- (void)getCacheData
{
    NSString *ret = nil;
    if (self.cacheKey.length > 0) {
        ret = [[EGOCache globalCache] stringForKey:self.cacheKey];
    } else {
        NSString *md5 = [TRUtility md5Value:self.request.url.absoluteString];
        ret = [[EGOCache globalCache] stringForKey:md5];
    }
    if (ret != nil){
        self.responseDic = ret.JSONValue;
        [self parseJSON:self.responseDic];
    }
}


-(void)dealloc
{
    self.delegate = nil;
    if (request != nil)
    {
        [request clearDelegatesAndCancel];
        self.request = nil;
    }
    self.cacheKey = nil;
}

+ (NSString *) addPublicPara:(NSString *) unAddedUrl{
    NSString *version = [TRUtility clientVersion];
    
    NSString *serverTime = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalServerTimeDelta];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    time += serverTime.floatValue;
    
    NSRange range = [unAddedUrl rangeOfString:@"?"];
    NSString *newUrl = nil;
    if (range.length == 0) {
        newUrl = [NSString stringWithFormat:@"%@?version=%@&platform=%@&_timestamp=%d", unAddedUrl, version, KIOSPlatformId, (int)time];
    } else {
        if ([unAddedUrl characterAtIndex:unAddedUrl.length -1] == '?') {
            newUrl = [NSString stringWithFormat:@"%@version=%@&platform=%@&_timestamp=%d", unAddedUrl, version, KIOSPlatformId, (int)time];
        } else {
            newUrl = [NSString stringWithFormat:@"%@&version=%@&platform=%@&_timestamp=%d", unAddedUrl, version, KIOSPlatformId, (int)time];
        }
    }
    return newUrl;
}

+ (NSDictionary *) getAllParas:(NSString *) url{
    NSRange range = [url rangeOfString:@"?"];
    NSString *parastr = [url substringFromIndex:range.location + range.length];
    NSArray *array = [parastr componentsSeparatedByString:@"&"];
    NSMutableDictionary * reslt = [NSMutableDictionary dictionary];
    for (NSString *str in array) {
        NSArray *temp = [str componentsSeparatedByString:@"="];
        if (temp.count >= 2) {
            [reslt setObject:[temp objectAtIndex:1] forKey:[temp objectAtIndex:0]];
        }
    }
    return reslt;
}

+ (NSString *) getServerTime{
    NSString *str = nil;
    @try {
        NSError *err = nil;
        str = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://club.api.autohome.com.cn/api/system/timestamp"] encoding:NSUTF8StringEncoding error:&err];
        if (err != nil) {
            str = nil;
        }
        return str;
    }
    @catch (NSException *exception) {
        str = nil;
    }
    @finally {
        return str;
    }

}


@end
