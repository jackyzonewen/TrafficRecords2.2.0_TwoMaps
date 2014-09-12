/*!
 @header    AHServiceBase.h
 @abstract  网络服务基类
 @author    张洁
 @version   2.4.0 2013/03/14 Creation
 */

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AHNetDelegate.h"
#import "EGOCache.h"
/*!
 @class
 @abstract 网络服务基类
 */
@interface AHServiceBase : NSObject<ASIHTTPRequestDelegate>{
    int                             timeErrCount;
    NSMutableDictionary             *parasDic;
}

/*!
 @property
 @abstract 请求
 */
@property(nonatomic, strong) ASIFormDataRequest *request;
/*!
 @property
 @abstract 网络请求服务的标识
 */
@property(nonatomic, assign) AHServiceRequestTag reqTag;
/*!
 @property
 @abstract 是否添加Cache
 */
@property (nonatomic, assign) BOOL isAddCache;
/*!
 @property
 @abstract 网络服务监听的委托者
 */
@property (nonatomic, weak) id<AHServiceDelegate> delegate;

/*!
 @property
 @abstract 当出错时是否显示提示信息，默认是显示
 */
@property (nonatomic, assign) BOOL isShowNetHint;

/*!
 @property
 @abstract 是否加密，默认为NO
 */
@property (nonatomic, assign) BOOL isSafeTranfer;

/*!
 @property
 @abstract 是否添加Cache
 */
@property (nonatomic, assign) BOOL isUserKnow;
/*!
 @property
 @abstract 要缓存时，缓存的key
 */

@property (nonatomic, strong) NSString *cacheKey;
/*!
 @property
 @abstract 要缓存时，缓存的时间 单位秒
 */
@property (nonatomic, assign) double cacheTime;

@property (nonatomic, strong) NSDictionary *responseDic;

/*!
 @method
 @abstract   取消发送请求
 @discussion 取消发送请求
 @result     返回结果 nil
 */
-(void)cancelRequest;
/*!
 @method
 @abstract   发送get请求
 @discussion 发送get请求
 @param      postUrl 数据地址
 @result     返回结果 nil
 */
-(void)getData:(NSString*)postUrl;
/*!
 @method
 @abstract   发送get请求
 @discussion 发送get请求
 @param      postUrl 数据地址
 @param      isQueryFromCache 是否取缓存
 @result     返回结果 nil
 */
- (void)getData:(NSString *)postUrl queryFromCache:(BOOL)isQueryFromCache;
/*!
 @method
 @abstract   解析json
 @discussion 解析json
 @param      strJSON 返回的json数据
 @result     返回结果 nil
 */

-(BOOL)parseJSON:(NSDictionary*)strJSON;

/*!
 @method
 @abstract   发送post请求
 @discussion 发送post请求
 @param      postUrl post数据地址
 @param      dic 发送的字典数据
 @param      imageArray 图片数组
 */
- (void)sendPost:(NSString *)postUrl Dictinary:(NSMutableDictionary *)dic ImageArray:(NSMutableArray *)imageArray;

- (void)notifyNetServiceError:(AHServiceRequestTag) tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage;
+ (NSString *) addPublicPara:(NSString *) unAddedUrl;
+ (NSString *) getServerTime;
+ (NSDictionary *) getAllParas:(NSString *) url;
- (NSString *)md5EncodeParas:(NSDictionary *)paras;
- (void)showHintView:(NSString *)message;
@end
