//
//  SupportCityManager.m
//  TrafficRecords
//
//  Created by qiao on 13-9-16.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "SupportCityManager.h"
#import "JSON.h"
#import "Area.h"

static SupportCityManager * shareSupportCityManager = nil;

@implementation SupportCityManager

@synthesize provinceDic;
@synthesize firstLetterArray;

-(id) init{
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}

-(void) reloadData{
    supportCityDic = nil;
    self.firstLetterArray = nil;
    self.provinceDic = nil;
    
    supportCityDic = [[NSMutableDictionary alloc] init];
    self.firstLetterArray = [NSMutableArray array];
    self.provinceDic = [[NSMutableDictionary alloc] init];
    
    NSString *supprtText = [TRUtility readcontentFromFile:@"support.json"];
    //本地不存在 则读取包中数据
    if(supprtText == nil || supprtText.length == 0){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"support" ofType:@"json"];
        NSStringEncoding coding = NSUTF8StringEncoding;
        supprtText = [NSString stringWithContentsOfFile:path usedEncoding:&coding error:nil];
    }
    
    NSArray *supportArray = [supprtText JSONValue];
    for (NSDictionary *dic in supportArray) {
        int provinceid = [[dic objectForKey:@"parentid"] intValue];
        City *city = [[City alloc] init];
        city.cityId = [[dic objectForKey:@"cityid"] intValue];
        //全省查询
//        if (provinceid == 0) {
//            provinceid = [[dic objectForKey:@"cityid"] integerValue];
//            city.name = [dic objectForKey:@"provincename"];//;
//            city.cityId = provinceid;
//        } else {
//            //构造supportCityDic数据
//            city.name = [dic objectForKey:@"cityname"];
//            city.cityId = [[dic objectForKey:@"cityid"] integerValue];
//        }
        city.name = [dic objectForKey:@"cityname"];
        city.parentId = provinceid;
        city.enginelen = [[dic objectForKey:@"enginenumlen"] integerValue];
        city.framelen = [[dic objectForKey:@"framenumlen"] integerValue];
        city.supportnum = [dic objectForKey:@"supportnum"];
        city.loginurl = [dic objectForKey:@"loginurl"];
        city.registernumlen = [[dic objectForKey:@"registernumlen"] integerValue];
        if ([[dic objectForKey:@"support"] integerValue] == 0) {
            city.notSupport = YES;
        } else {
            city.notSupport = NO;
        }
        //构造supportCityDic数据
        NSMutableArray *citys = [supportCityDic objectForKey: [NSString stringWithFormat:@"%d", provinceid]];
        if (citys == nil) {
            citys = [NSMutableArray array];
            [supportCityDic setObject:citys forKey:[NSString stringWithFormat:@"%d", provinceid]];
        }
        [citys addObject:city];
        
        
        //构造provinceDic数据
        Province *pro = [[Province alloc] init];
        pro.name = [dic objectForKey:@"provincename"];
        pro.provinceId = provinceid;
        pro.firstLetter = [dic objectForKey:@"firstletter"];
        
        NSMutableArray * temp = [provinceDic objectForKey:pro.firstLetter];
        if (temp == nil) {
            [firstLetterArray addObject:pro.firstLetter];
            temp = [NSMutableArray array];
            [provinceDic setObject:temp forKey:pro.firstLetter];
        }
        BOOL found = NO;
        for (Province * tempPro in temp) {
            if (tempPro.provinceId == pro.provinceId) {
                found = YES;
                break;
            }
        }
        if (!found) {
            [temp addObject:pro];
        }
    }
}

-(NSArray *) getCitysByPro:(NSString *) provinceId{
    NSArray * citys = [supportCityDic objectForKey:provinceId];
    return citys;
}

-(City*) getCity:(int) cityID{
    for (NSArray *array in [supportCityDic allValues]) {
        for (City * city in array) {
            if (city.cityId == cityID) {
                return city;
            }
        }
    }
    return nil;
}

+(SupportCityManager*) sharedManager{
    if (shareSupportCityManager == nil) {
        shareSupportCityManager = [[SupportCityManager alloc] init];
    }
    return shareSupportCityManager;
}

@end
