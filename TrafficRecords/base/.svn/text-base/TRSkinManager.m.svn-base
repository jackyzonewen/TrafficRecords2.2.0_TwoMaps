//
//  TRSkinManager.m
//  TrafficRecords
//
//  Created by qiao on 13-9-6.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "TRSkinManager.h"

@implementation TRSkinManager

+ (UIColor*)colorWithInt:(unsigned)colorValue{
    unsigned a = (colorValue&0xff000000)>>24;
    unsigned r = (colorValue&0x00ff0000)>>16;
    unsigned g = (colorValue&0x0000ff00)>>8;
    unsigned b = colorValue&0x000000ff;
    UIColor* color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0 - a/255.0];
    return color;
}

+ (UIColor *) selectBgColor{
    return [TRSkinManager colorWithInt:0xe9e7e5];
}

+ (void) setCellSelectBgColor:(UITableViewCell *)cell{
    UIView *selectView = [[UIView alloc] init];
    selectView.backgroundColor = [TRSkinManager selectBgColor];
    cell.selectedBackgroundView = selectView;
}

+ (UIColor *) textColorDark{
    return [TRSkinManager colorWithInt:0x333333];
}

+ (UIColor *) textColorLightDark{
    return [TRSkinManager colorWithInt:0x9b9b9b];
}

+ (UIColor *) textColorLight{
    return [TRSkinManager colorWithInt:0xd9d9d9];
}

+ (UIColor *) textColorWhite{
    return [TRSkinManager colorWithInt:0xffffff];
}

+ (UIColor *) labelColorRed{
    return [TRSkinManager colorWithInt:0xfc3e39];
}

+ (UIColor *) labelColorGray{
    return [TRSkinManager colorWithInt:0xd6d6d6];
}

+ (UIColor *) bgColorDark{
    return [TRSkinManager colorWithInt:0xe5e5e5];
}

//+ (UIColor *) bgColorLightDark{
//    return [TRSkinManager colorWithInt:0xc7c7c7];
//}

+ (UIColor *) bgColorLight{
    return [TRSkinManager colorWithInt:0xf5f2f0];
}

+ (UIColor *) bgColorWhite{
    return [TRSkinManager colorWithInt:0xffffff];
}

+ (UIColor *) borderColor{
    return [TRSkinManager colorWithInt:0xeeeeee];
}

+ (UIColor *) cellSelectedCorlor{
    return [TRSkinManager colorWithInt:0xf1f1f1];
}

+ (UIFont *) largeFont1{
    return [UIFont systemFontOfSize:22];
}

+ (UIFont *) largeFont2{
    return [UIFont systemFontOfSize:20];
}

+ (UIFont *) mediumFont1{
    return [UIFont systemFontOfSize:19];
}

+ (UIFont *) mediumFont2{
    return [UIFont systemFontOfSize:18];
}

+ (UIFont *) mediumFont3{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *) smallFont1{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *) smallFont2{
    return [UIFont systemFontOfSize:12];
}

@end
