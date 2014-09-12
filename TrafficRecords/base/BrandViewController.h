//
//  BrandViewController.h
//  TrafficRecords
//
//  Created by qiao on 13-9-18.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "AHThirdSelectView.h"
#import "BrandManager.h"

@protocol BrandDelegate <NSObject>
@optional
- (void) selectedBrand:(Brand *)brand Series:(Series *) series Spec:(CarType *) spec;
@end

//

@interface BrandViewController : TRBaseViewController<AHThirdSelectViewDelegate, AHThirdSelectViewDataSource>{
    AHThirdSelectView       *thirdView;
    NSMutableArray          *brandTitles;
    NSMutableArray          *specTitles;
    NSMutableDictionary     *brandData;
    NSMutableArray          *seriesData;
    NSMutableDictionary     *specData;
    UIImageView         *selectCellBg1;
    UIImageView         *selectCellBg2;
}

@property(nonatomic, weak) id<BrandDelegate> brandDelegate;
@property(nonatomic, strong)Brand *selectBrand;
@property(nonatomic, strong)Series *selectSeries;
@property(nonatomic, strong)CarType *selectSpec;

@end
