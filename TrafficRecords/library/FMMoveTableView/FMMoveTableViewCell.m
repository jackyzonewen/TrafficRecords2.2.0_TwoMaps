//
//  FMMoveTableViewCell.m
//  FMFramework
//
//  Created by Florian Mielke.
//  Copyright 2012 Florian Mielke. All rights reserved.
//  

#import "FMMoveTableViewCell.h"


@implementation FMMoveTableViewCell


- (void)prepareForMove
{
    self.hidden = YES;
}

- (void)recoverFromMove{
    self.hidden = NO;
}

@end
