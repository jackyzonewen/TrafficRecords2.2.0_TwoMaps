//
//  ThirdLoginService.m
//  TrafficRecords
//
//  Created by 张小桥 on 13-12-2.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "ThirdLoginService.h"
#import "CarInfo.h"

@implementation ThirdLoginService

@synthesize userId;
@synthesize firstLogin;
@synthesize carTimeStamp;
@synthesize carsItems;
@synthesize reqUserDic;

- (id)init
{
    self = [super init];
	if (self)
	{
        self.isSafeTranfer = YES;
        self.isAddCache = NO;
        self.reqTag = EServiceThirdLogin;
	}
    return self;
}

-(void) loginWithThirdInfo:(NSDictionary *) userInfo{
    self.reqUserDic = userInfo;
    NSString * url = [NSString stringWithFormat:@"%@ashx/ThridUserLogin.ashx?", KServerHost];
    [self sendPost:url Dictinary:[NSMutableDictionary dictionaryWithDictionary:userInfo] ImageArray:nil];
}

-(BOOL) parseJSON: (NSDictionary *)strJSON{
    NSDictionary * result = [strJSON objectForKey:@"result"];
    if (result == nil) {
        return NO;
    }
    self.userId = [result objectForKey:@"userid"];
    if ([self.userId isKindOfClass:[NSNumber class]]) {
        self.userId = [NSString stringWithFormat:@"%ld", (long)[[result objectForKey:@"userid"] integerValue]];
    }
    self.firstLogin = [[result objectForKey:@"user_isfirstoauth"] intValue];
    self.carTimeStamp = [result objectForKey:@"carstimestamp"];
//    self.carsItems = [result objectForKey:@"caritems"];
    
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
        
        //1.4.0
        car.userName = [dic objectForKey:@"username"];
        car.passWord = [dic objectForKey:@"userpwd"];
        car.registernumber = [dic objectForKey:@"registernumber"];
        
        car.sortIndex = i;
        car.picUrl = [dic objectForKey:@"pic"];
        [car reloadLocalUndealRecods];
        [carsArray addObject:car];
        //不插入数据库，不加入全局数组
    }
    self.carsItems = carsArray;
    
    return YES;
}
@end
