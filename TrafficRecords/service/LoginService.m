//
//  LoginService.m
//  TrafficRecords
//
//  Created by qiao on 13-9-24.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "LoginService.h"
#import "OpenUDID.h"
#import "JSON.h"
#import "CarInfo.h"

@implementation LoginService

@synthesize authImage;
@synthesize useId;
@synthesize firstLogin;
@synthesize carTimeStamp;
@synthesize carsItems;

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceLogin;
	}
    return self;
}

-(void) loginWithUser:(NSString *) user pwd:(NSString *) pwd authCode:(NSString *) authCode{
    self.isShowNetHint = YES;
    NSString * url = [NSString stringWithFormat:@"%@ashx/UserLogin.ashx?", KServerHost];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:user,@"username",
                                pwd,@"userpwd",
                                [OpenUDID value], @"deviceid",
                                nil];
    if (authCode == nil) {
        [dic setObject:@"" forKey:@"validecode"];
    } else {
        [dic setObject:authCode forKey:@"validecode"];
    }
    [self sendPost:url Dictinary:dic ImageArray:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    @try {
        NSString * response = [aRequest responseString];
        NSLog(@"%@", response);
        NSDictionary *dic = [response JSONValue];
        self.responseDic = dic;
        if (dic == nil)
        {
            //如果不是一个有效的json数据，则认为是出错了
            [self notifyNetServiceError:self.reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
            return;
        }
        
        int successFlag = [[dic valueForKey:@"returncode"] intValue];
        //时间戳超出误差范围
        if (successFlag == -71) {
            if (timeErrCount >= 1) {
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
            });
            return;
        }
        if (0 != successFlag && -50 != successFlag)
        {
            //如果服务器返回错误的代码，则处理为出错
            [self notifyNetServiceError:self.reqTag errorCode:successFlag errorMessage:[dic valueForKey:@"message"]];
            return;
        }
        if ([self parseJSON:self.responseDic])
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:)])
            {
                [self.delegate netServiceFinished:self.reqTag];
            }
        }
        else
        {
            [self notifyNetServiceError:self.reqTag errorCode:successFlag errorMessage:NETPARSER_BAD];
        }
    }
    @catch (NSException *exception) {
        //解析出错，把错误传递出去
        [self notifyNetServiceError:self.reqTag errorCode:-1 errorMessage:NETPARSER_BAD];
    }
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    int successFlag = [[strJSON valueForKey:@"returncode"] intValue];
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    if (successFlag == 0) {
        self.authImage = nil;
       
        self.useId = [result objectForKey:@"userid"];
        if ([self.useId isKindOfClass:[NSNumber class]]) {
            self.useId = [NSString stringWithFormat:@"%ld", (long)[[result objectForKey:@"userid"] integerValue]];
        }
        self.firstLogin = [[result objectForKey:@"user_isfirstoauth"] intValue];
        self.carTimeStamp = [result objectForKey:@"carstimestamp"];
        NSString *miniPic = [result objectForKey:@"minipic"];
        if (miniPic == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KUserPicUrl];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:miniPic forKey:KUserPicUrl];
        }
        
        NSMutableArray *carsArray = [NSMutableArray array];
        NSArray * cars = [result objectForKey:@"caritems"];
        for (int i = 0; i < cars.count; i++) {
            NSDictionary *dic = [cars objectAtIndex:i];
            CarInfo *car = [[CarInfo alloc] init];
            car.carid = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"carid"] intValue]];
            NSString *cityText = [dic objectForKey:@"querycitysid"];
            NSArray *citys = [cityText componentsSeparatedByString:@","];
            for (NSString *cityId in citys) {
                CityOfCar *city = [[CityOfCar alloc] init];
                city.cityid = cityId;
                city.carid = car.carid;
                city.timestamp = @"";
                [car addCity:city];
            }
            car.carname = [dic objectForKey:@"carname"];
            car.carBrandId = [[dic objectForKey:@"carbrand"] integerValue];
            car.carSeriesId = [[dic objectForKey:@"carseries"] integerValue];
            car.cartypeId = [[dic objectForKey:@"carspecid"] integerValue];
            
            car.carnumber =[dic objectForKey:@"carnumber"];
            car.enginenumber =[dic objectForKey:@"enginenumber"];
            car.framenumber =[dic objectForKey:@"framenumber"];
            car.sortIndex = i;
            car.picUrl = [dic objectForKey:@"pic"];
            
            //1.4.0
            car.userName = [dic objectForKey:@"username"];
            car.passWord = [dic objectForKey:@"userpwd"];
            car.registernumber = [dic objectForKey:@"registernumber"];
            
            [car reloadLocalUndealRecods];
            [carsArray addObject:car];
            //不插入数据库，不加入全局数组
        }
        self.carsItems = carsArray;
    } else if(-50 == successFlag){
        NSString *base64 = [result objectForKey:@"validecode"];
        NSData *data = [TRUtility dataWithBase64EncodedString:base64];
        UIImage *image = [UIImage imageWithData:data];
        self.authImage = image;
        return NO;
    }
    return YES;
}
@end
