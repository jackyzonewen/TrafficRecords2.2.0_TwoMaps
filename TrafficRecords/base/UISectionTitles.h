//
//  UISectionTitles.h
//  TrafficRecords
//
//  Created by qiao on 13-10-28.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISelectSectionDelegate <NSObject>

@optional
-(void) sectionDidSelected:(int) index title:(NSString *) title;

@end



@interface UISectionTitles : UIView{
    NSArray *titles;
    UILabel *bigTitle;
}
-(id) initWith:(UIView *) view andTitles:(NSArray *) titleArray;

@property (nonatomic, strong)UIView *selectedBgView;
@property (nonatomic, assign) id<UISelectSectionDelegate> delegate;

@end
