//
//  WBPoiResultItem.h
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WBPoiResultItem : NSObject
//@property(nonatomic,copy) NSString* keywords;
@property(nonatomic,copy) NSString *name,*uid,*address,*city,* phone,*postCode;
@property(nonatomic) CLLocationCoordinate2D location;
@end
