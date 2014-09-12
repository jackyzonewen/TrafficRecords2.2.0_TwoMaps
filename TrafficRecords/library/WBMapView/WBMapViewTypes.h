//
//  WBMapViewTypes.h
//  TRMapView
//
//  Created by Peter on 14-9-3.
//  Copyright (c) 2014年 Peter. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKGeometry.h>
#if USE_BaiduMap
#import "BMapKit.h"
#else
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

//使用原有的数据类型,百度||高德
#if 1
#if USE_BaiduMap
    //类型定义
    typedef BMKPoiSearch                WBPoiSearcher;
    typedef BMKMapPoint                 WBMapPoint;
    typedef BMKMapSize                  WBMapSize;
    typedef BMKMapRect                  WBMapRect;
    typedef BMKCoordinateSpan           WBCoordinateSpan;
    typedef BMKCoordinateRegion         WBCoordinateRegion;
    typedef BMKPointAnnotation          WBPointAnnotation;
    typedef BMKUserLocation             WBUserLocation;
    typedef BMKAnnotationView           WBAnnotationView;
    
#define WBMapPointMake(A,B)             BMKMapPointMake(A,B)
#define WBMapSizeMake(A,B)              BMKMapSizeMake(A,B)
#define WBMapRectMake(A,B)              BMKMapRectMake(A,B)
#define WBCoordinateSpanMake(A,B)       BMKCoordinateSpanMake(A,B)
#define WBCoordinateRegionMake(A,B)     BMKCoordinateRegionMake(A,B)
 //point<-->coordinate
#define WBMapPointForCoordinate(A)      BMKMapPointForCoordinate(A)
#define WBCoordinateForMapPoint(A)      BMKCoordinateForMapPoint(A)
//rect<-->region
#define WBCoordinateRegionForMapRect(A) BMKCoordinateRegionForMapRect(A)
#define WBMapRectForCoordinateRegion(A) BMKMapRectForCoordinateRegion(A)//?
//
#define WBMapRectContainsPoint(A,B)     BMKMapRectContainsPoint(A,B)
#define WBMapRectIntersectsRect(A,B)    BMKMapRectIntersectsRect(A,B)
#define WBMapRectContainsRect(A,B)      BMKMapRectContainsRect(A,B)
//point,size,rect -->string
#define NSStringFromMapPoint(A)         BMKStringFromMapPoint(A)
#define NSStringFromMapSize(A)          BMKStringFromMapSize(A)
#define NSStringFromMapRect(A)          BMKStringFromMapRect(A)
#define NSStringFromCoordinate(A)       BMKStringFromCoordinate(A)
    
NS_INLINE NSString *BMKStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [NSString stringWithFormat:@"{%f, %f}", coordinate.latitude,coordinate.longitude];
}
#else
    
    
    //类型定义
    typedef AMapSearchAPI               WBPoiSearcher;
    typedef MAMapPoint                  WBMapPoint;
    typedef MAMapSize                   WBMapSize;
    typedef MAMapRect                   WBMapRect;
    typedef MACoordinateSpan            WBCoordinateSpan;
    typedef MACoordinateRegion          WBCoordinateRegion;
    typedef MAPointAnnotation           WBPointAnnotation;
    typedef MAUserLocation              WBUserLocation;
    typedef MAAnnotationView            WBAnnotationView;
    
#define WBMapPointMake(A,B)             MAMapPointMake(A,B)
#define WBMapSizeMake(A,B)              MAMapSizeMake(A,B)
#define WBMapRectMake(A,B)              MAMapRectMake(A,B)
#define WBCoordinateSpanMake(A,B)       MACoordinateSpanMake(A,B)
#define WBCoordinateRegionMake(A,B)     MACoordinateRegionMake(A,B)
//point<-->coordinate
#define WBMapPointForCoordinate(A)      MAMapPointForCoordinate(A)
#define WBCoordinateForMapPoint(A)      MACoordinateForMapPoint(A)
//rect<-->region
#define WBCoordinateRegionForMapRect(A) MACoordinateRegionForMapRect(A)
#define WBMapRectForCoordinateRegion(A) MAMapRectForCoordinateRegion(A)
//
#define WBMapRectContainsPoint(A,B)     MAMapRectContainsPoint(A,B)
#define WBMapRectIntersectsRect(A,B)    MAMapRectIntersectsRect(A,B)
#define WBMapRectContainsRect(A,B)      MAMapRectContainsRect(A,B)
//point,size,rect -->string
#define NSStringFromMapPoint(A)         MAStringFromMapPoint(A)
#define NSStringFromMapSize(A)          MAStringFromMapSize(A)
#define NSStringFromMapRect(A)          MAStringFromMapRect(A)
#define NSStringFromCoordinate(A)       MAStringFromCoordinate(A)
  
    /*
NS_INLINE NSString *MAStringFromMapPoint(WBMapPoint point) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", point.x, point.y];
}
NS_INLINE NSString *MAStringFromMapSize(WBMapSize size) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", size.width, size.height];
}
NS_INLINE NSString *MAStringFromMapRect(WBMapRect rect) {
    return [NSString stringWithFormat:@"{%@, %@}", MAStringFromMapPoint(rect.origin), MAStringFromMapSize(rect.size)];
}
     */
NS_INLINE NSString *MAStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    return [NSString stringWithFormat:@"{%f, %f}", coordinate.latitude,coordinate.longitude];
}
#endif
    
    //使用自定义
#else
    typedef struct {
        CLLocationDegrees latitudeDelta;
        CLLocationDegrees longitudeDelta;
    } WBCoordinateSpan;
    
    typedef struct {
        CLLocationCoordinate2D center;
        WBCoordinateSpan span;
    } WBCoordinateRegion;
    
    NS_INLINE WBCoordinateSpan WBCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
    {
        return (WBCoordinateSpan){latitudeDelta, longitudeDelta};
    }
    NS_INLINE WBCoordinateRegion WBCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, WBCoordinateSpan span)
    {
        return (WBCoordinateRegion){centerCoordinate, span};
    }
#endif

//WB前缀类型与系统类型转换
 NS_INLINE  WBMapPoint mapPointConvertFromSystem(MKMapPoint aPoint)
            {
                return (WBMapPoint){aPoint.x,aPoint.y};
            }
NS_INLINE   WBMapSize mapSizeConvertFromSystem(MKMapSize aSize)
            {
                return (WBMapSize){aSize.width,aSize.height};
            }
NS_INLINE   WBMapRect mapRectConvertFromSystem(MKMapRect aRect)
            {
                return (WBMapRect){{aRect.origin.x,aRect.origin.y},{aRect.size.width,aRect.size.height}};
            }
NS_INLINE   WBCoordinateSpan coordinateSpanConvertFromSystem(MKCoordinateSpan aSpan)
            {
                return (WBCoordinateSpan){aSpan.latitudeDelta,aSpan.longitudeDelta};
            }
NS_INLINE   WBCoordinateRegion coordinateRegionConvertFromSystem(MKCoordinateRegion aRegion)
            {
                return (WBCoordinateRegion){{aRegion.center.latitude,aRegion.center.longitude},{aRegion.span.latitudeDelta,aRegion.span.longitudeDelta}};
            }
#ifdef __cplusplus
}
#endif