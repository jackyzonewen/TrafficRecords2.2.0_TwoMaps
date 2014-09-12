/*!
 @header    Des.h
 @abstract  Des加密
 @author    段广龙
 @version   1.0.0 2012/9/24 Creation
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//绑定新的SN时加密的key和iv
#define gKey_binding (@"FC13573F412EAA1BA8E34791")
#define gIv_binding (@"12345678")

//绑定新的SN时加密的key和iv
#define gKey_addCar (@"!@#$%^&#$%^&amp;*1234567")
#define gIv_addCar (@"12345678")

/*说明:       本类进行Des加密时，如果对不同串进行加密几次后会有偶发崩溃现象，尚未明确是哪块的问题。*/


/*!
 @class Utility
 @abstract MD5加密
 */
@interface Des: NSObject
{
}

+ (NSString *) md5:(NSString *)str;

+ (NSString *)doCipher:(NSString *)sTextIn
                   key:(NSString *)sKey
                    iv:(NSString *)theIv
               context:(CCOperation)encryptOrDecrypt;

+ (NSString *) encryptStr:(NSString *) str key:(NSString*)key iv:(NSString *)theIv;
+ (NSString *) decryptStr:(NSString *) str key:(NSString*)key iv:(NSString *)theIv;
+ (NSString *)doCipher2:(NSString *)sTextIn key:(NSString *)sKey iv:(NSString *)theIv
                context:(CCOperation)encryptOrDecrypt;
#pragma mark Based64
+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;

@end