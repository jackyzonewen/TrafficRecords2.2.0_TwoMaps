//
//  FAQModel.h
//  TrafficRecords
//
//  Created by qiao on 14-6-19.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQModel : NSObject

@property(nonatomic, strong) NSString       *title;
@property(nonatomic, strong) NSString       *content;
@property(nonatomic, assign) BOOL           opened;

@end
