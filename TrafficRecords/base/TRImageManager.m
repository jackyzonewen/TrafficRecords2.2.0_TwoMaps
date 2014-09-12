//
//  TRImageManager.m
//  TrafficRecords
//
//  Created by qiao on 13-9-1.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRImageManager.h"

#define KAutoReleaseTime 60
static TRImageManager * gTRImageMInstance = nil;

@implementation TRImageManager

+ (UIImage *)imageNamed:(NSString *)name{
    if (gTRImageMInstance == nil) {
        gTRImageMInstance = [[TRImageManager alloc] init];
    }
    UIImage * image = [gTRImageMInstance imageNamed:name];
    if (image == nil) {
        image = [UIImage imageNamed: name];
    }
    return image;
}

-(id) init {
    self = [super init];
    if (self) {
        isRetain = [TRUtility deviceIsHDScreen];
        imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
        [self performSelector:@selector(runPerTimes) withObject:nil afterDelay:KAutoReleaseTime];
    }
    
    return self;
}

-(void) dealloc{
    if (imageDictionary) {
        [imageDictionary release];
        imageDictionary = nil;
    }
    [super dealloc];
}

- (UIImage *)imageNamed:(NSString *)name{
    if (name == nil || name.length == 0) {
        return nil;
    }
    NSMutableString* temp = [[NSMutableString alloc] initWithString:name];
    NSRange range = [temp rangeOfString:@"@2x"];
    if (range.length > 0 && !isRetain) {//低分辨率下有@2x
        [temp deleteCharactersInRange:range];
    } else if(range.length == 0 && isRetain){//高分辨率下无@2x
        range = [temp rangeOfString:@"."];
        if (range.length == 0) {
            [temp appendString:@"@2x"];
        } else {
            [temp insertString:@"@2x" atIndex:range.location];
        }
    }
    range = [temp rangeOfString:@"."];//没有后缀
    if (range.length == 0) {
        [temp appendString:@".png"];
    }
    UIImage* image = [imageDictionary objectForKey:temp];
    if (image == nil) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",
                          [[NSBundle mainBundle] bundlePath],
                          temp];
        image = [[UIImage alloc] initWithContentsOfFile:path];
        if (image) {
            [imageDictionary setObject:image forKey:temp];
            [image release];
        }
    }
    [temp release];
    return image;
}

-(void) runPerTimes{
    [self releaseNotUsedImages];
    [self performSelector:@selector(runPerTimes) withObject:nil afterDelay:KAutoReleaseTime];
}

- (void) releaseNotUsedImages{
    NSArray* array = [imageDictionary allKeys];
    for (int i = 0; i < [array count]; i++) {
        NSString* name = [array objectAtIndex:i];
        UIImage* image = [imageDictionary objectForKey:name];
        if (image.retainCount <= 1) {
            [imageDictionary removeObjectForKey:name];
        }
    }
}
@end
