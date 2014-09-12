//
//  NSOfficInfo.h
//  TrafficRecords
//
//  Created by qiao on 14-3-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOfficInfo : NSObject
{
}

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *phoneShow;
@property(nonatomic, strong) NSString *phoneCall;
@property(nonatomic, strong) NSString *latbaidu;
@property(nonatomic, strong) NSString *lngbaidu;
@property(nonatomic, strong) NSString *latgaode;
@property(nonatomic, strong) NSString *lnggaode;
@end
