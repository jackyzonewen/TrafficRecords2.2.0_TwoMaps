//
//  TRUtility.m
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "TRUtility.h"
#import "Des.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import"sys/utsname.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TRReachability.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static NSString *appkey = nil;

@implementation TRUtility

+ (NSString *) IDFAString
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0000) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        return @"";
    }
}

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString *)md5Value:(NSString *) srcStr
{
    if (srcStr.length > 0) {
        const char *str = [srcStr UTF8String];
        unsigned char r[CC_MD5_DIGEST_LENGTH];
        CC_MD5(str, (CC_LONG)strlen(str), r);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    }
    return nil;
}

+ (NSString *)clientVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleVersionKey];
}

+(NSString *) searchPath:(NSSearchPathDirectory) directory{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *appSupport = [paths objectAtIndex:0];
    if (![fileMgr fileExistsAtPath:appSupport]) {
        [fileMgr createDirectoryAtPath:appSupport withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return appSupport;
}

+ (NSString *) dateToString:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSString *) cacheFullPathByAppend:(NSString *) filename{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    if (![fileMgr fileExistsAtPath:cachePath]) {
        [fileMgr createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    cachePath = [cachePath stringByAppendingPathComponent:filename];
    return cachePath;
}

+(BOOL) writecontent:(NSString*)content toFile:(NSString*) fileName{
    if (content == nil) {
        return NO;
    }
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    //定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    //查找文件，如果不存在，就创建一个文件
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*) readcontentFromFile:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //获取文件路径
    NSString *pathll = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    return [NSString stringWithContentsOfFile:pathll usedEncoding:&encoding error:nil];
}

+ (NSString *)URLEncodedString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8));
}

+ (NSString*) URLDecodedString:(NSString *) string {
    @try {
        return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                             (__bridge CFStringRef) string,
                                                                                             CFSTR(""),
                                                                                             kCFStringEncodingUTF8);
    }
    @catch (NSException *exception) {
        return string;
    }

}

+ (UIImage *)imageWithColor:(UIColor *)color size: (CGSize) size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    //    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    return [TRUtility imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}


/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        return nil;
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

+ (NSArray *) getDesInfo{
    NSString *str = @"1234567890qwertyuiopasdfghjlkzxcvbnmQAZWSXEDCRFVTGBYHNUJMIKL";
    int desIndex[12] = {1,6,7,8,24,12,26,21,12,1,0,13};
    int ivIndex[12] = {2,3,7,1,10,12,34,21,45,48,0,37};
    NSMutableString *desKey = [NSMutableString string];
    NSMutableString *ivKey = [NSMutableString string];
    for (int i = 0; i < 12; i++) {
        [desKey appendFormat:@"%u", [str characterAtIndex:desIndex[i]]];
        [ivKey appendFormat:@"%u", [str characterAtIndex:ivIndex[i]]];
    }
    NSArray *array = [NSArray arrayWithObjects:desKey, ivKey, nil];
    return array;
}

+ (NSString *)getAppKey{
    if (appkey == nil) {
        NSArray *desInfo = [TRUtility getDesInfo];
        NSString *desKey = [desInfo objectAtIndex:0];
        NSString *ivKey = [desInfo objectAtIndex:1];
//        NSString *appkey = [Des encryptStr:@"8CA0A5DD95C28A98" key:desKey iv:ivKey];
        appkey = [Des decryptStr:@"MmDGyAmkWXTMMcZu1TPRS8kuXnzlcZk8" key:desKey iv:ivKey];
    }
    return appkey;
}

+(UIImage *) centeRoundImage:(UIColor *) bgColor size:(CGSize) size rect:(CGRect) roundRect{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    float scale = 1.0;
    if ([TRUtility deviceIsHDScreen]) {
        scale = 2.0;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, 0);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, roundRect.origin.y);
    CGContextAddArc(context, roundRect.origin.x + roundRect.size.width/2, roundRect.origin.y + roundRect.size.height/2, roundRect.size.width/2, -M_PI/2, M_PI/2, 1);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, roundRect.origin.x + roundRect.size.width/2, 0);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, roundRect.origin.y);
    CGContextAddArc(context, roundRect.origin.x + roundRect.size.width/2, roundRect.origin.y + roundRect.size.height/2, roundRect.size.width/2, -M_PI/2, M_PI/2, 0);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, size.height);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, size.width, 0);
    CGContextAddLineToPoint(context, roundRect.origin.x + roundRect.size.width/2, 0);
    CGContextFillPath(context);
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;

}

+(UIImage*) image:(UIImage*) image withCornerRadius:(CGFloat) radius{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextMoveToPoint(context, image.size.width, image.size.height/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, image.size.width, image.size.height, image.size.width/2, image.size.height, radius);  // Top right corner
    CGContextAddArcToPoint(context, 0, image.size.height, 0, image.size.height/2, radius); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, image.size.width/2, 0, radius); // Lower left corner
    CGContextAddArcToPoint(context, image.size.width, 0, image.size.width, image.size.height/2, radius); // Back to lower right
    CGContextClip(context);
    [image drawInRect:rect];
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+(UIImage*) bgimage:(UIImage*) bgimage withFontImage:(UIImage *) fontImage{
    UIGraphicsBeginImageContextWithOptions(bgimage.size, NO, bgimage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, bgimage.size.width, bgimage.size.height);
    [bgimage drawInRect:rect];
    
    if (rect.size.width < fontImage.size.width || rect.size.height < fontImage.size.height) {
        rect = CGRectMake(3, 3, bgimage.size.width - 6, bgimage.size.height - 6);
    } else {
        rect = CGRectMake(bgimage.size.width/2 - fontImage.size.width/2, bgimage.size.height/2 - fontImage.size.height/2, fontImage.size.width, fontImage.size.height);
    }
    [fontImage drawInRect:rect];
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


// 正则判断手机号码地址格式
+ (BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL) deviceIsHDScreen{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    size_screen.width *= scale_screen;
    size_screen.height *= scale_screen;
    if (   CGSizeEqualToSize(size_screen, CGSizeMake(320, 480))
        || CGSizeEqualToSize(size_screen, CGSizeMake(480, 320))
        || CGSizeEqualToSize(size_screen, CGSizeMake(1024, 768))
        || CGSizeEqualToSize(size_screen, CGSizeMake(768, 1024))) {
       return NO;
    }
    return YES;
}

+(float) lineHeight{
    float lineH = 1;
    if ([TRUtility deviceIsHDScreen]) {
        lineH = 0.5;
    }
    return lineH;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+(NSString *) getMobileNetworkOperators
{
    NSString *str = nil;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSLog(@"%@", info.currentRadioAccessTechnology);
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return str;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil) {
        return str;
    }
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        str = @"移动";
    } else if([code isEqualToString:@"01"] || [code isEqualToString:@"06"] ){
        str = @"联通";
    } else if([code isEqualToString:@"03"] || [code isEqualToString:@"05"] ){
        str = @"电信";
    } else if([code isEqualToString:@"20"] ){
        str = @"铁通";
    }
    return str;
}

+(NSString *) getNetworkType{
    NetworkStatus status = [TRReachability reachabilityForInternetConnection].currentReachabilityStatus;
    if(status == ReachableViaWiFi){
        return @"wifi";
    } else {
        if (kSystemVersion >= 7.0) {
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *nettype = info.currentRadioAccessTechnology;
            if (nettype.length == 0) {
                nettype = @"CTRadioAccessTechnologyGPRS";
            }
            return nettype;
        } else {
            return @"CTRadioAccessTechnologyGPRS";
        }
    }
}

+(NSString *) getMobileModle{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

+(NSString *) getOsInfo{
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

//1为2G,2为3G，3为4G，4为LTE，5为wifi
+ (int)dataNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
        
    }
    int netType = 0;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        netType = 0;
    }else{
        netType = [num intValue];
    }
    return netType;
    
}

+ (BOOL)isJailBreak
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}

+(UIImage*) imageOfView:(UIView*) view {
    float scale = 1.0;
    if ([TRUtility deviceIsHDScreen]) {
        scale = 2.0;
    }
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)addImage:(UIImage *)frontImg toImage:(UIImage *)bgImage atPos:(CGPoint) pos
{
    float scale = 1.0;
    if ([TRUtility deviceIsHDScreen]) {
        scale = 2.0;
    }
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, scale);
    //Draw image2
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    //Draw image1
    [frontImg drawInRect:CGRectMake(pos.x, pos.y, frontImg.size.width, frontImg.size.height)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}
@end
