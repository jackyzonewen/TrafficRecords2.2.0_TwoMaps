//
//  ThirdLoginService.h
//  TrafficRecords
//
//  Created by 张小桥 on 13-12-2.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "AHServiceBase.h"

@interface ThirdLoginService : AHServiceBase

@property(nonatomic, strong) NSString * userId;
@property(nonatomic, assign) int        firstLogin;
@property(nonatomic, strong) NSString * carTimeStamp;
@property(nonatomic, strong) NSArray * carsItems;
@property(nonatomic, strong) NSDictionary *reqUserDic;

-(void) loginWithThirdInfo:(NSDictionary *) userInfo;

@end
