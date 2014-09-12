//
//  CityOfCar.h
//  TrafficRecords
//
//  Created by qiao on 13-9-11.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

//验证码过期时间,5年
#define KTimeStampOverTime 157680000

@interface CityOfCar : NSObject

@property (nonatomic, strong)NSString *cityid;
@property (nonatomic, strong)NSString *carid;
@property (nonatomic, strong)NSString *timestamp;
@property (nonatomic, strong)NSString *authovertime;
@property (nonatomic, strong)NSString *authurl;
@property (nonatomic, strong)NSString *authInfoMsg;
@property (nonatomic, strong)UIImage  *authImage;

+(CityOfCar *) createByDic:(NSDictionary *) dic;
@end
