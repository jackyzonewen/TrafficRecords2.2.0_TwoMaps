//
//  WeatherModule.h
//  TrafficRecords
//
//  Created by qiao on 13-9-8.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EWeatherType {
    EWeatherQing = 0,//晴
    EWeatherDuoyun, // 多云
    EWeatherYin, // 阴
    EWeatherZhenyu, // 阵雨
    EWeatherLeizhenyu, // 雷阵雨
    EWeatherBingbao, //雷阵雨伴有冰雹
    EWeatherYujiaxue, //雨夹雪
    EWeatherXiaoyu, //小雨
    EWeatherZhongyu, // 中雨
    EWeatherDayu, // 大雨
    EWeatherBaoyu = 10, //暴雨
    EWeatherDabaoyu, //大暴雨
    EWeatherTeBaoyu, // 特大暴雨
    EWeatherZhenxue, //阵雪
    EWeatherXiaoxue, // 小雪
    EWeatherZhongxue, //中雪
    EWeatherDaxue, //大雪
    EWeatherBaoxue, // 暴雪
    EWeatherWu, //雾
    EWeatherDongyu, //冻雨
    EWeatherShabao = 20, // 沙尘暴
    EWeatherXiaoyuZhong, // 小雨-中雨
    EWeatherZhongyuDa, //中雨-大雨
    EWeatherDayuBao, //大雨-暴雨
    EWeatherBaoyuDa, //暴雨-大暴雨
    EWeatherDayuTe, // 大暴雨-特大暴雨
    EWeatherXiaoxueZhong, // 小雪-中雪
    EWeatherZhongxueDa, //中雪-大雪
    EWeatherDaxueBao, //大雪-暴雪
    EWeatherFuchen, //浮尘
    EWeatherYangsha = 30, //扬沙
    EWeatherQiangSha, //强沙层暴
    EWeatherMai = 53 //霾
}EWeatherType;

@interface WeatherModule : NSObject

//0表示今天
@property (nonatomic, assign) int dateIndex;

@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) EWeatherType weatherType;
@property (nonatomic, strong) NSString *weatherText;
@property (nonatomic, assign) int lowTemper;
@property (nonatomic, assign) int highTemper;
@property (nonatomic, assign) int air;
@property (nonatomic, strong) NSString *airText;
@property (nonatomic, strong) NSString *xicheZhishu;

-(UIImage *) weatherIcon;
@end
