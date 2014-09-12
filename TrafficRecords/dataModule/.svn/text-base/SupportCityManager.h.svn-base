//
//  SupportCityManager.h
//  TrafficRecords
//
//  Created by qiao on 13-9-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"

@interface SupportCityManager : NSObject{
    //key为省份id，value为City对象数组
    NSMutableDictionary *supportCityDic;
}
//key为firstLetter，value为Province
@property(nonatomic, strong) NSMutableDictionary  *provinceDic;
@property(nonatomic, strong) NSMutableArray       *firstLetterArray;

-(NSArray *) getCitysByPro:(NSString *) provinceId;
-(void) reloadData;
-(City*) getCity:(int) cityID;
+(SupportCityManager*) sharedManager;
@end
