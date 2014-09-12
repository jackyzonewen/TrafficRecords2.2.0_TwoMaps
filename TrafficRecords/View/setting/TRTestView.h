//
//  TRTestView.h
//  TrafficRecords
//
//  Created by qiao on 14-5-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRTestView : UIView{
    //当前正中间的索引
    int             centerIndex;
    //触摸起始点
    CGPoint         startPoint;
    //当前拖拽点
    CGPoint         currentPoint;
    //内容原本大小
    CGSize          itemSize;
}

@property(nonatomic, strong) UIPageControl      *pageControl;
@property(nonatomic, strong) NSMutableArray     *contentArray;

@end
