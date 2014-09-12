/*!
 @header   AHNetDelegate
 @abstract 延伸的网络代理
 @author   张洁
 @version  2.4.0 2013/3/14 Creation
 */
@protocol AHServiceDelegate <NSObject>

@optional
/*!
 @method
 @abstract   开始传输数据时的调用
 @discussion 开始传输数据
 @param      handle 网络请求服务的标识
 */
- (void)netServiceStarted:(AHServiceRequestTag) tag;
/*!
 @method
 @abstract   完成传输数据时的调用
 @discussion 完成传输数据
 @param      handle 网络请求服务的标识
 */
- (void)netServiceFinished:(AHServiceRequestTag) tag;

- (void)netServiceContinueWtihTask:(AHServiceRequestTag) tag;
/*!
 @method
 @abstract   请求错误时的调用
 @discussion 请求接口错误或接口返回错误信息时调用此方法
 @param      handle 网络请求服务的标识
 */
- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage;
/*!
 @method
 @abstract   请求超时时的调用
 @discussion 当访问请求超时时调用此方法
 @param      handle 网络请求服务的标识
 */
- (void)netServiceTimeout:(AHServiceRequestTag) tag;
/*!
 @method
 @abstract   状态改变时的调用
 @discussion 包括网络状态和请求的状态
 @param      handle 网络请求服务的标识
 @param      state 当前触发的状态
 */
- (void)netStateChange:(AHServiceRequestTag) tag state:(int)state;
/*!
 @method
 @abstract   数据传输过程中调用
 @discussion 数据传输过程中分段数据的触发
 @param      handle 网络请求服务的标识
 @param      totalByte 接收数据的总大小
 @param      currentByte 当前接收数据的大小
 */
- (void)netServiceDataTrunk:(AHServiceRequestTag) tag totalByte:(int)totalByte currentByte:(int)currentByte;

@end

