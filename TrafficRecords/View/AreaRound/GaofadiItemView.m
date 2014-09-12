//
//  GaofadiItemView.m
//  TrafficRecords
//
//  Created by qiao on 14-8-12.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GaofadiItemView.h"
#import "TRPercentView.h"

@implementation GaofadiItemView

@synthesize myheight;

-(id) initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        
        TRPercentView *percentView = [[TRPercentView alloc] initWithFrame:CGRectMake(15, 20, 31, 31)];
        percentView.percent = 0.78;
        [self addSubview:percentView];
        mypercentView = percentView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(percentView.right + 8, percentView.top, 240, 0)];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x999999];
        label.numberOfLines = 0;
        label.text = [dic objectForKey:@"content"];
        CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.width, 0x666666)];
        if (size.height < percentView.height) {
            size.height = percentView.height;
        } else {
            size.height += 10;
        }
        [label setHeight:size.height];
        [self addSubview:label];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:TRImage(@"money.png")];
        imageView1.frame = CGRectMake(label.left, label.bottom + 5, imageView1.width, imageView1.height);
        [self addSubview:imageView1];
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.right + 3, imageView1.top, 50, imageView1.height)];
        money.text = [NSString stringWithFormat:@"-%d", [[dic objectForKey:@"pay"] integerValue]];
        if ([[dic objectForKey:@"pay"] integerValue] < 0) {
            money.text = @"未知";
        }
        money.font = [UIFont systemFontOfSize:14];
        money.backgroundColor = [UIColor clearColor];
        money.textColor = [TRSkinManager colorWithInt:0xdb325a];
        [self addSubview:money];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:TRImage(@"score.png")];
        imageView2.frame = CGRectMake(money.right, money.top, imageView2.width, imageView2.height);
        [self addSubview:imageView2];
        UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(imageView2.right + 3, imageView2.top, 50, imageView2.height)];
        score.text = [NSString stringWithFormat:@"-%d", [[dic objectForKey:@"score"] integerValue]];
        if ([[dic objectForKey:@"score"] integerValue] < 0) {
            score.text = @"未知";
        }
        score.font = [UIFont systemFontOfSize:14];
        score.backgroundColor = [UIColor clearColor];
        score.textColor = [TRSkinManager colorWithInt:0xdb325a];
        [self addSubview:score];
        myheight = score.bottom;
        self.frame = CGRectMake(0, 0, 320, myheight);
    }
    return self;
}

-(void) setPercent:(float) percent{
    mypercentView.percent = percent;
}

-(TRPercentView*) PercentView{
    return mypercentView;
}
@end
