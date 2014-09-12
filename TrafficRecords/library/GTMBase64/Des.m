/*!
 @header    Des.h
 @abstract  Des加密
 @author    段广龙
 @version   1.0.0 2012/9/24 Creation
 */

#import "Des.h"

#import "TRGTMBase64.h"

//base64加密表
static char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//base64解码表
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};


@implementation Des

+ (NSString *) md5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return[NSString
           
           stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           
           result[0], result[1],
           
           result[2], result[3],
           
           result[4], result[5],
           
           result[6], result[7],
           
           result[8], result[9],
           
           result[10], result[11],
           
           result[12], result[13],
           
           result[14], result[15]
           
           ];
    
}


+ (NSString *) encryptStr:(NSString *) str key:(NSString*)key iv:(NSString *)theIv
{ 
    return [self doCipher:str key:key iv:theIv context:kCCEncrypt];
}

+ (NSString *) decryptStr:(NSString *) str key:(NSString*)key iv:(NSString *)theIv
{
    if (str == nil) {
        return nil;
    }
    return[self doCipher:str key:key iv:theIv context:kCCDecrypt];
}

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey iv:(NSString *)theIv
               context:(CCOperation)encryptOrDecrypt
{
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {    
        
        dTextIn = [[self decodeBase64WithString:sTextIn] mutableCopy];
        
        //GTMBase64
        //dTextIn = [[GTMBase64 decodeData:[GTMBase64 decodeString:sTextIn]] mutableCopy];
    }    
    else{    
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];    
    }           
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];            
    [dKey setLength:kCCBlockSizeDES];        
    uint8_t *bufferPtr1 = NULL;    
    size_t bufferPtrSize1 = 0;    
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    const void *iv = (const void *) [theIv UTF8String];
    
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);    
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));    
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);    
    CCCrypt(encryptOrDecrypt, // CCOperation op    
            kCCAlgorithm3DES, // CCAlgorithm alg    
            kCCOptionPKCS7Padding, // CCOpti***** opti*****    
            [dKey bytes], // c*****t void *key 
            kCCKeySize3DES,
            //[dKey length], // size_t keyLength    
            iv, // c*****t void *iv    
            [dTextIn bytes], // c*****t void *dataIn
            [dTextIn length],  // size_t dataInLength    
            (void*)bufferPtr1, // void *dataOut    
            bufferPtrSize1,     // size_t dataOutAvailable 
            &movedBytes1);      // size_t *dataOutMoved    
    
    
    NSString * sResult;    
    if (encryptOrDecrypt == kCCDecrypt){    
        sResult = [[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1
                                                                  length:movedBytes1] encoding:EnC];
    }    
    else {    
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1]; 
        
        sResult = [Des encodeBase64WithData:dResult];
        
        //GTMBase64
        //sResult = [GTMBase64 stringByEncodingData:[GTMBase64 encodeData:dResult]];
    }
    free(bufferPtr1);
    return sResult;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return [self encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    NSUInteger intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4 + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while(intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3; 
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    NSString *str = [NSString stringWithCString:strResult encoding:NSUTF8StringEncoding];
    free(strResult);
    // Return the results as an NSString object
    return str;
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    const char* objPointer = [strBase64 cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char * objResult;
    objResult = calloc(intLength, sizeof(unsigned char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            free(objResult);
            return nil;
        }
        
        switch (i % 4) {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
    free(objResult);
    return objData;
}

+ (NSString *)doCipher2:(NSString *)sTextIn key:(NSString *)sKey iv:(NSString *)theIv
               context:(CCOperation)encryptOrDecrypt
{
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        
        dTextIn = [[self decodeBase64WithString:sTextIn] mutableCopy];
        
        //GTMBase64
        //dTextIn = [[GTMBase64 decodeData:[GTMBase64 decodeString:sTextIn]] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    const void *iv = (const void *) [theIv UTF8String];
    
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOpti***** opti*****
            [dKey bytes], // c*****t void *key
            kCCKeySizeDES,
            //[dKey length], // size_t keyLength
            iv, // c*****t void *iv
            [dTextIn bytes], // c*****t void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void*)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);      // size_t *dataOutMoved
    
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1
                                                                 length:movedBytes1] encoding:EnC];
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        
        sResult = [Des encodeBase64WithData:dResult];
        
        //GTMBase64
        //sResult = [GTMBase64 stringByEncodingData:[GTMBase64 encodeData:dResult]];
    }
    free(bufferPtr1);
    return sResult;
}

@end