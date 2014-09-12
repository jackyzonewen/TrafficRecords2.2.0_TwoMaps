//
//  LuKuangCity.m
//  TrafficRecords
//
//  Created by qiao on 14-4-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "LuKuangCity.h"
#import "AreaDBManager.h"
#import "Json.h"

static NSArray *shareLuKuangCity = nil;

@implementation LuKuangCity

@synthesize centerCoord;
@synthesize zoomLevel;
@synthesize supportLuKuang;

+(void) releaseShareDic{
    shareLuKuangCity = nil;
}

+(LuKuangCity *) getLuKuangCityById:(int) cityId{
    if (shareLuKuangCity == nil) {
        NSString *text = [TRUtility readcontentFromFile:KLuKuangSaveFileName];
        if(text.length <= 0)
        {
//            [[NSBundle mainBundle] pathForResource:@"TRDataBase" ofType:@"rdb"]
//            LuKuangCity.json
            NSString *path = [[NSBundle mainBundle] pathForResource:@"LuKuangCity" ofType:@"json"];
            text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        }
        NSDictionary *dic = [text JSONValue];
        dic = [dic objectForKey:@"result"];
        shareLuKuangCity = [dic objectForKey:@"items"];
    }
    
    City *city = [AreaDBManager getCityByCityId:cityId];
    LuKuangCity *reslt = [[LuKuangCity alloc] init];
    reslt.cityId = city.cityId;
    reslt.name = city.name;
    reslt.parentId = city.parentId;
    reslt.firstLetter = city.firstLetter;
    BOOL found = NO;
    for (NSDictionary *temp in shareLuKuangCity) {
        if ([[temp objectForKey:@"cityid"] intValue] == reslt.cityId) {
            found = YES;
            reslt.centerCoord = CLLocationCoordinate2DMake([[temp objectForKey:@"latgaode"] doubleValue], [[temp objectForKey:@"lnggaode"] doubleValue]);
            reslt.zoomLevel = [[temp objectForKey:@"level"] floatValue];
            reslt.supportLuKuang = YES;
            break;
        }
    }
    if (!found) {
        reslt.centerCoord = CLLocationCoordinate2DMake(0, 0);
        reslt.zoomLevel = 0;
        reslt.supportLuKuang = NO;
    }
    
    return reslt;
}

+(LuKuangCity *) getLuKuangCityByKeyWord:(NSString*) cityName{
    City *city = [AreaDBManager getCityByKeyWord:cityName];
    LuKuangCity *reslt = [LuKuangCity getLuKuangCityById:city.cityId];
    return reslt;
}

-(NSString *) toJsonString{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:cityId] forKey:@"cityId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:[NSNumber numberWithInteger:parentId] forKey:@"parentId"];
    [dic setObject:self.firstLetter forKey:@"firstLetter"];
    [dic setObject:[NSNumber numberWithInteger:self.enginelen] forKey:@"enginelen"];
    [dic setObject:[NSNumber numberWithInteger:self.framelen] forKey:@"framelen"];
    [dic setObject:[NSNumber numberWithBool:self.notSupport] forKey:@"notSupport"];
    [dic setObject:[NSNumber numberWithDouble:centerCoord.latitude] forKey:@"latitude"];
    [dic setObject:[NSNumber numberWithDouble:centerCoord.longitude] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithFloat:zoomLevel] forKey:@"zoomLevel"];
    [dic setObject:[NSNumber numberWithBool:self.supportLuKuang] forKey:@"supportLuKuang"];
    NSString * str = [dic JSONRepresentation];
    return str;
}

-(id) initWithJsonStr:(NSString *) json{
    self = [super init];
    if (self) {
        NSDictionary *dic = [json JSONValue];
        self.cityId = [[dic objectForKey:@"cityId"] integerValue];
        self.name = [dic objectForKey:@"name"];
        self.parentId = [[dic objectForKey:@"parentId"] integerValue];
        self.firstLetter = [dic objectForKey:@"firstLetter"];
        self.enginelen = [[dic objectForKey:@"enginelen"] integerValue];
        self.framelen = [[dic objectForKey:@"framelen"] integerValue];
        self.notSupport = [[dic objectForKey:@"framelen"] boolValue];
        self.centerCoord = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longitude"] doubleValue]) ;
        self.zoomLevel = [[dic objectForKey:@"zoomLevel"] floatValue];
        self.supportLuKuang = [[dic objectForKey:@"supportLuKuang"] boolValue];
    }
    return self;
}
@end
