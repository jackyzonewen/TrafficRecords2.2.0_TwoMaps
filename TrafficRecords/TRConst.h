//
//  TRConst.h
//  TrafficRecords
//
//  Created by qiao on 13-8-26.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#ifndef TrafficRecords_TRConst_h
#define TrafficRecords_TRConst_h
//服务器地址
#define KServerHost (@"http://wz.qichecdn.com/")
//#define KTestServerHost (@"http://221.192.136.143/")
//#define KServerHost (@"http://221.192.136.71/")
//#define KServerHost (@"http://10.168.100.102/")
//#define KServerHost (@"http://10.168.12.15:8087/")
//#define KServerHost (@"http://10.168.12.56:80/")

#define KUMSAgentServerHost (@"http://app.stats.autohome.com.cn/")
//#define KUMSAgentServerHost (@"http://10.168.100.181/razor/web/")

#define KChannelId (@"App Store")
//KChannelId不能为中文

//地图切换
#define USE_BaiduMap 1
#define Latitude_Baidu_Key @"latbaidu"
#define Longitude_Baidu_Key @"lngbaidu"
#define Latitude_Gaode_Key @"latbaidu"
#define Longitude_Gaode_Key @"lngbaidu"


//果粉
#define KChannelguofen (@"guofen")
//威锋市场
#define KChannelweifeng (@"weifeng")
// 爱思助手
#define KChannelaisi (@"aisi")
//XY苹果助手
#define KChannelguofenxy (@"xy")
//App Store
#define KChannelAppStore (@"App Store")
//91市场
#define KChanne91Market (@"91 Market")
//同步推
#define KChanneTongBuTui (@"Tong Bu Tui")
//PP助手
#define KChannePP (@"PP")
//App苹果园
#define KChanneAppleYuan (@"Apple Yuan")
// 快用市场
#define KChannekuaiyong (@"kuaiyong")
// AutoHome
#define KChanneAutoHome (@"autohome")
#define KChanneMogu (@"mogu")


#define KChangeLine @"<br>"
//代码编号 
#define KReleaseCode (@"2000")

//企业版百度key
#define KCompanyBaiduMapKey (@"jWrPqBD1PkM9TtThw8RGTEGA")
////appstore版百度key
#define KAppStoreBaiduMapKey (@"vqyll8FKFviuU35f0u6YOfRF")

#define KGaoDeMapKey (@"5136b408c0c12608a413ea49857b9789")

#define KUMengAppKey (@"528c181356240b8e880f0bc5")

#define KGUIDKey (@"GUIDKey")
#define KUserId (@"UserId")
#define KUserName (@"UserName")
#define KPassword (@"UserPassword")
#define KIOSPlatformId (@"1") 
#define KDefaultMapZoomLevel 13

#define KShareSDKAppKey (@"7fde49a959d")
#define KWXAPPKey (@"wx18e4846776d19a84")
#define KWXAPPSecert (@"46c5c9def1005886ced0ef2a998ed457")
#define KQQAppKey (@"100566579")
#define KQQAppSecert (@"5b4a6dfe35cb903b67563bb1883b1a63")
#define KSinaWeiBoKey (@"2008458032")
#define KSinaWeiBoSecert (@"8aa365bd71e93f6bcacbdbb4083d2140")
    
#define KCurrentCityId (@"currentCityId")
#define KLuKuangCityInfo (@"LuKuangCityInfo")
#define KWeatherLastUpdateTime (@"WeatherLastUpdateTime")
#define KSaveTokenKey (@"KSaveTokenKey")
#define KPushSettingClose (@"KPushSettingClose")
#define KWZPushSettingClose (@"KWZPushSettingClose")
#define KPushStartTime (@"KPushStartTime")
#define KPushEndTime (@"KPushEndTime")

#define KUserAgent (@"iOS7.0\\WZCX1.1.0")

typedef enum : NSUInteger {
    EAreaRoundTrafficPolice,
    EAreaRoundBank,
    EAreaRound4sShop,
    EAreaRoundGasStation,
    EAreaRoundParking,
    EAreaRoundWashCar,
    EAreaRoundHotel,
    EAreaRoundMeiRong,
    EAreaRoundZhuangshi,
    EAreaRoundGaizhuang,
    EAreaRoundRepair
} EAreaRoundSearchType;

typedef  enum AHServiceRequestTag
{
    EServiceStart = 10000,
    EServiceGetWeather,
    EServiceGetAppInfo,
    EServiceGetTrafficRecord,
    EServiceGetSupportCity,
    EServiceAddCar,
    EServiceDeleteCar,
    EServiceLogin,
    EServiceThirdLogin,
    EServiceAuthCodeQuery,
    EServiceAddCarAuthCode,
    EServiceBindingCars,
    EServiceChangeAuthCode,
    EServiceRegToken,
    EServiceGetOfficeInfo,
    EServiceReportLocErr,
    EServiceLuKuangInfo,
    EServiceGetAppRecommdList,
    EServiceFeedBackGet,
    EServiceFeedBackSend,
    EServicePushSetting,
    EServiceWZPushSetting,
    EServiceGetFAQList,
    EServicePOISearch,
    EServiceProxyTask,
    EServiceGaofadi
}AHServiceRequestTag;

#define NETWORK_BAD (@"网络请求失败，请重试")
#define NETPARSER_BAD (@"网络请求失败，请重试")
#define UNKNOWN_ERROR (@"网络请求失败，请重试")

#define KNotification_GlobTouchEvent (@"globTouchEvent")
#define KNotification_CarChanged (@"CarChanged")
#define KNotification_SetteingView (@"KNotification_SetteingView")
#define KNotification_GetAppInfo (@"KNotification_GetAppInfo")
#define KNotification_CityChanged (@"KNotification_CityChanged")

#define KNotification_HaveActivity (@"KNotification_HaveActivity")
#define KNotification_PushMsgReceived (@"KNotification_PushMsgReceived")

#define KMainViewGuidShow (@"KMainViewGuidShow")

//点击叉子时记录已经叉掉的时间戳
#define KActivityTimestamp (@"KActivityTimestamp")

//这三个用来存储getappinfo的数据，无网时使用
#define KActivityImgUrl (@"KActivityImgUrl")
#define KActivityUrl (@"KActivityUrl")
#define KActivityTimestamp2 (@"KActivityTimestamp2")
#define KActivityShareText (@"KActivityShareText")
#define KActivityShareUrl (@"KActivityShareUrl")
#define KActivityShareIconUrl (@"KActivityShareIconUrl")
#define KActivityShareTitle (@"KActivityShareTitle")

#define KCitysTimestamp (@"citys_timestamp")
#define KLimitNumsTimestamp (@"limitNums_timestamp")
#define KProductionDBTimestamp (@"productionDB_timestamp")
#define KThemeImageChanged (@"ThemeImageChanged")
#define KCarsTimestamp (@"cars_timestamp")
#define KLocalServerTimeDelta (@"LocalServerTimeDelta")
#define KLuKuangTimestamp (@"KLuKuangTimestamp")
#define KLuKuangSaveFileName (@"LuKuangCity.json")
#define KFAQSaveFileName (@"FAQ.json")

#define KNoPushCity (@"KNoPushCity")

#define KAPPRecommadListFileName (@"APPRecommadLis.json")
#define KFeedbackFileName (@"KFeedbackFileName.json")
#define KLuKuangBeClicked (@"KLuKuangBeClicked")
#define KSettingBeClicked (@"KSettingBeClicked")
#define KActivityBeClicked (@"KActivityBeClicked")
#define KPushSettingBeClicked (@"KPushSettingBeClicked")

#define KCommentBeClicked (@"KCommentBeClicked")
#define KSerctAppKey ([TRUtility getAppKey])
#define KUserPicUrl (@"UserPicUrl")

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kSystemVersion ([[UIDevice currentDevice] systemVersion].intValue)
#define KSelectedTextColor (0x1d71a0)

#define KTransBgColor (0x55000000)

#define KSettingViewWidth (270.0)
#define KLoadingDuration 50
#define KHiddenHeight (180.0)
#define KCompressFloat (0.5)

#endif
