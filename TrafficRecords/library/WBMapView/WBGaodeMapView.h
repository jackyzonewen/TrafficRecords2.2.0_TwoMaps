//
//  WBGaodeMapView.h
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "WBMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define Gaode_API_Key KGaoDeMapKey

//转成高德
NS_INLINE MACoordinateSpan coordinateSpanConvertToGaode(WBCoordinateSpan aSpan)
{
    return (MACoordinateSpan){aSpan.latitudeDelta,aSpan.longitudeDelta};
}
NS_INLINE MACoordinateRegion coordinateRegionConvertToGaode(WBCoordinateRegion aRegion)
{
    return (MACoordinateRegion){aRegion.center,coordinateSpanConvertToGaode(aRegion.span)};
}

//转成本地
NS_INLINE WBCoordinateSpan coordinateSpanConvertToLocalFromGaode(MACoordinateSpan aSpan)
{
    return (WBCoordinateSpan){aSpan.latitudeDelta,aSpan.longitudeDelta};
}
NS_INLINE WBCoordinateRegion coordinateRegionConvertToLocalFromGaode(MACoordinateRegion aRegion)
{
    return (WBCoordinateRegion){aRegion.center,coordinateSpanConvertToLocalFromGaode(aRegion.span)};
}

@interface WBGaodeMapView : WBMapView<AMapSearchDelegate,MAMapViewDelegate>
@end
