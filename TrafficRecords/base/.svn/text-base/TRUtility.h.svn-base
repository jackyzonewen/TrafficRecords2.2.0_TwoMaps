//
//  TRUtility.h
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUtility : NSObject

+ (NSString *) IDFAString;
+ (NSString *)getMacAddress;

+ (NSString *) md5Value:(NSString *) srcStr;
+ (NSString *) searchPath:(NSSearchPathDirectory) directory;
+ (NSString *) clientVersion;
+ (NSString *) cacheFullPathByAppend:(NSString *) filename;
/*
 * 将日期转换成 年-月-日
 */
+ (NSString *) dateToString:(NSDate *) date;


+(BOOL) writecontent:(NSString*)content toFile:(NSString*) fileName;
+(NSString*) readcontentFromFile:(NSString*)fileName;
+ (NSString *)URLEncodedString:(NSString *)string;
+ (NSString *) URLDecodedString:(NSString *) string ;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize) size;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
+ (NSArray *) getDesInfo;
+ (NSString *)getAppKey;

+(UIImage*) image:(UIImage*) image withCornerRadius:(CGFloat) radius;
+(UIImage*) bgimage:(UIImage*) bgimage withFontImage:(UIImage *) fontImage;
+ (BOOL)isPhoneNumber:(NSString *)phoneNumber;

+(BOOL) deviceIsHDScreen;
+(float) lineHeight;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
//获取网络运营商
+(NSString *) getMobileNetworkOperators;
+(NSString *) getMobileModle;
+(NSString *) getNetworkType;
+(NSString *) getOsInfo;
//1为2G,2为3G，3为4G，4为LTE，5为wifi
+ (int)dataNetworkTypeFromStatusBar;
+ (BOOL)isJailBreak;

+(UIImage *) centeRoundImage:(UIColor *) bgColor size:(CGSize) size rect:(CGRect) roundRect;
+(UIImage*) imageOfView:(UIView*) view ;
+(UIImage *)addImage:(UIImage *)frontImg toImage:(UIImage *)bgImage atPos:(CGPoint) pos;
@end
