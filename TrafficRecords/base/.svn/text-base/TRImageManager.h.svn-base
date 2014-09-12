//
//  TRImageManager.h
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRImageManager : NSObject {
    //是否是高清设备
    BOOL                    isRetain;
    NSMutableDictionary*    imageDictionary;
}

- (UIImage *)imageNamed:(NSString *)name;
- (void) runPerTimes;
- (void) releaseNotUsedImages;
+ (UIImage *)imageNamed:(NSString *)name;

@end
