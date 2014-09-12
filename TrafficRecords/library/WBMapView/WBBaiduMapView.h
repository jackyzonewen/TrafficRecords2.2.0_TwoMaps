//
//  WBBaiduMapView.h
//  TRMapView
//
//  Created by Peter on 14-9-2.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import "WBMapView.h"
#import "BMapKit.h"

#define Baidu_API_Key KAppStoreBaiduMapKey

#define ERROR_STRING(i) (@[@"检索词有岐义",@"检索地址有岐义",@"该城市不支持公交搜索",@"不支持跨城市公交",@"没有找到检索结果",@"起终点太近"])[i]


//转成百度
NS_INLINE BMKCoordinateSpan coordinateSpanConvertToBaidu(WBCoordinateSpan aSpan)
{
    return (BMKCoordinateSpan){aSpan.latitudeDelta,aSpan.longitudeDelta};
}
NS_INLINE BMKCoordinateRegion coordinateRegionConvertToBaidu(WBCoordinateRegion aRegion)
{
    return (BMKCoordinateRegion){aRegion.center,coordinateSpanConvertToBaidu(aRegion.span)};
}
//转成本地
NS_INLINE WBCoordinateSpan coordinateSpanConvertToLocalFromBaidu(BMKCoordinateSpan aSpan)
{
    return (WBCoordinateSpan){aSpan.latitudeDelta,aSpan.longitudeDelta};
}
NS_INLINE WBCoordinateRegion coordinateRegionConvertToLocalFromBaidu(BMKCoordinateRegion aRegion)
{
    return (WBCoordinateRegion){aRegion.center,coordinateSpanConvertToLocalFromBaidu(aRegion.span)};
}



@interface WBBaiduMapView : WBMapView<BMKPoiSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>

@end
