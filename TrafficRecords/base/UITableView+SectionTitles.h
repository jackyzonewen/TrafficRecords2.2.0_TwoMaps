//
//  UITableView+SectionTitles.h
//  TrafficRecords
//
//  Created by qiao on 13-10-28.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISectionTitles.h"

@interface UITableView (SectionTitles) <UISelectSectionDelegate>{
    
}

-(void) addCustomSectionTitles:(NSArray *) titles;
@end
