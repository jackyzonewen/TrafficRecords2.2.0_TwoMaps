

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    LOG_REALTIME = 0,       //LOG_REALTIME Send Policy
    LOG_BATCH = 1,          //Send Data When Start
} LogReportPolicy;

@interface UMSAgent : NSObject<UIAlertViewDelegate>
{
    //Event * event;
}

+(void)checkUpdate;

+(void)startWithAppKey:(NSString*)appKey ReportPolicy:(LogReportPolicy)policy ChannelId:(NSString*)channelid;

//activitylog*****
+(void)startTracPage:(NSString*)page_name;
+(void)endTracPage:(NSString*)page_name;

//eventlog********
+(void)postEvent:(NSString *)eventid page_name:(NSString *)page_name;
+(void)postEvent:(NSString *)eventid page_name:(NSString *)page_name eventargvs:(NSMutableDictionary *)eventArgvs;

+(void)postEventBegin:(NSString *)eventid page_name:(NSString *)page_name;
+(void)postEventBegin:(NSString *)event_id page_name:(NSString *)page_name eventargvs:(NSMutableDictionary *)eventArgvs;
+(void)postEventEnd:(NSString *)eventid page_name:(NSString *)page_name;
//+(void)postEventEnd:(NSString *)eventid page_name:(NSString *)page_name eventargvs:(NSMutableDictionary *)eventArgvs;
//*****************

+(void)bindUserIdentifier:(NSString *)userid;



//-(void)recordEventStartTime:(NSString*)event_id page_name:(NSString *)page_name;

// Check if the device jail broken
+ (BOOL)isJailbroken;
+ (void)setOnLineConfig:(BOOL)isOnlineConfig;
//+ (void)setIsLogEnabled:(BOOL)isLogEnabled;
+ (NSString*)getUMSUDID;

+(void)setBaseURL:(NSString*)url debugModel:(int)debugmodel;

@end
