//
//  UITableView+SectionTitles.m
//  TrafficRecords
//
//  Created by qiao on 13-10-28.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "UITableView+SectionTitles.h"


@implementation UITableView (SectionTitles)


-(void) addCustomSectionTitles:(NSArray *) titles{
    UISectionTitles *sectionView = [[UISectionTitles alloc] initWith:self andTitles:titles];
    sectionView.delegate = self;
}

-(void) sectionDidSelected:(int) index title:(NSString *) title{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
