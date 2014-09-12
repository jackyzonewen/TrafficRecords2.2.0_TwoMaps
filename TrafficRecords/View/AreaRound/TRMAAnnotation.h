//
//  TRMAAnnotation.h
//  TrafficRecords
//
//  Created by qiao on 14-7-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface TRMAAnnotation : NSObject<MAAnnotation>{
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSURL *url;
@end
