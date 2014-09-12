//
//  TRScrollCarView.h
//  TrafficRecords
//
//  Created by qiao on 14-5-14.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TRScrollCarViewDelegate <NSObject>

@optional
- (void) indexChanged:(NSUInteger) index;
@end

@interface TRScrollCarView : UIView{
//当前正中间的索引
int             centerIndex;
//触摸起始点
CGPoint         startPoint;
//当前拖拽点
CGPoint         currentPoint;
}

@property(nonatomic, strong)UIPageControl      *pageControl;

@property(nonatomic, strong)NSArray     *carNumArray;//车牌数组，字符串
@property(nonatomic, strong)NSMutableArray     *contentArray;//控件数组

@property(nonatomic, strong)UIImageView        *limitBgView;
@property(nonatomic, strong)UILabel            *limitLabel;
@property(nonatomic, assign)id<TRScrollCarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame carnums:(NSArray *) carNums;
-(void) setCurrentIndex:(NSUInteger) index;
@end
