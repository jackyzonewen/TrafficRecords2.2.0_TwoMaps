//
//  LimitNumViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-5-15.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "LimitNumViewController.h"
#import "TRScrollCarView.h"
#import "LimitNumManager.h"
#import "AreaDBManager.h"
#import "CarInfo.h"
#import "TRSettingPushViewController.h"
#import "TRImageScaleView.h"

@interface LimitNumViewController ()

@end

@implementation LimitNumViewController

@synthesize cityId;
@synthesize dates;
@synthesize limitNums;
@synthesize part2Titles;
@synthesize part2Contents;
@synthesize part3Titles;
@synthesize part3Contents;
@synthesize picUrl;
@synthesize carNums;
@synthesize carLimitInfo;

const int KLimitNumViewId = 101;
const int KPart2ViewId = 102;
const int KPart3ViewId = 103;
const int KPart4ViewId = 104;

-(NSString *) naviTitle{
    if (cityId == 0) {
        return @"北京限行提醒";
    }
    City *city = [AreaDBManager getCityByCityId:cityId];
    return [NSString stringWithFormat:@"%@限行提醒", city.name];
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)naviRightIcon{
    if (cityId == 0) {
        return nil;
    }
    LimitCityInfo *cityInfo = [LimitNumManager cityInfo:cityId];
    if (![cityInfo.limitpush boolValue]) {
        return nil;
    }
    return @"limitSetting.png";
}

-(void) naviRightClick:(id)sender{
    TRSettingPushViewController *pushSetView = [[TRSettingPushViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pushSetView];
    [self presentModalViewController:navi animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initData{
    if (self.dates == nil) {
        self.dates = [NSMutableArray array];
    }
    if (limitNums == nil) {
        self.limitNums = [NSMutableArray array];
    }
    NSDate *now = [NSDate date];
    NSTimeInterval oneday = 24*60*60;
    for (int i = 0; i < 5; i++) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M.d"];
        NSDate *date = [NSDate dateWithTimeInterval:oneday * i sinceDate:now];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        if (i == 0) {
            [dates addObject:@"今日"];
        } else if(i == 1) {
            [dates addObject:@"明日"];
        } else {
            [dates addObject:currentDateStr];
        }
        [limitNums addObject: [LimitNumManager getLimitNumByCity:cityId date:date]];
    }
    
    self.carLimitInfo = [NSMutableArray array];
    if (self.carNums == nil) {
        self.carNums = [NSMutableArray array];
        for (CarInfo *car in [CarInfo globCarInfo]) {
            [self.carNums addObject:car.carnumber];
            [self.carLimitInfo addObject:[LimitNumManager limitInfo:cityId ForCar:car.carnumber]];
        }
    }
    LimitCityInfo *cityInfo = [LimitNumManager cityInfo:cityId];
    if (self.part2Titles == nil) {
        self.part2Titles = [NSMutableArray array];
    }
    if (self.part2Contents == nil) {
        self.part2Contents = [NSMutableArray array];
    }
    if (cityInfo.limittimearea.length > 0) {
        [self.part2Titles addObject:@"限行时间及范围:"];
        [self.part2Contents addObject:cityInfo.limittimearea];
    }
    
    
//    
//    if (cityInfo.limitinfo.length > 0) {
//        [self.part2Titles addObject:@"限行范围:"];
//        [self.part2Contents addObject:cityInfo.limitinfo];
//    }
    
    if (self.part3Titles == nil) {
        self.part3Titles = [NSMutableArray array];
    }
    if (self.part3Contents == nil) {
        self.part3Contents = [NSMutableArray array];
    }
    if (cityInfo.limitinfo.length > 0) {
        [self.part3Titles addObject:@"限行尾号规则:"];
        [self.part3Contents addObject:cityInfo.limitinfo];
    }
    
    
    if (self.part4Titles == nil) {
        self.part4Titles = [NSMutableArray array];
    }
    if (self.part4Contents == nil) {
        self.part4Contents = [NSMutableArray array];
    }
    if (cityInfo.limitother.length > 0) {
        [self.part4Titles addObject:@"其他规定:"];
        [self.part4Contents addObject:cityInfo.limitother];
    }
    self.picUrl = cityInfo.limitPicUrl;
}

-(UIView *) createLimitNumView:(float) top{
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(5, top, self.view.width - 10, 71)];
    frameView.backgroundColor = [TRSkinManager bgColorWhite];
    frameView.layer.cornerRadius = 4;
    frameView.layer.borderColor = [TRSkinManager colorWithInt:0xe3e0de].CGColor;
    frameView.layer.borderWidth = [TRUtility lineHeight];
//    [self.view addSubview:frameView];
    if (dates.count != 0) {
        float width = frameView.width / dates.count;
        for (int i = 0; i < dates.count; i++) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0 + i * width, 16, width, 16)];
            label1.backgroundColor = [UIColor clearColor];
            label1.textColor = [TRSkinManager colorWithInt:0x999999];
            label1.font = [TRSkinManager smallFont1];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.text = [dates objectAtIndex:i];
            [frameView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0 + i * width, 42, width, 17)];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [TRSkinManager colorWithInt:0x666666];
            label2.font = [TRSkinManager mediumFont3];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.text = [limitNums objectAtIndex:i];
            [frameView addSubview:label2];
            if (i != dates.count - 1) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label1.right, 10, [TRUtility lineHeight], frameView.height - 20)];
                line.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
                [frameView addSubview:line];
            }
        }
    }
    frameView.tag = KLimitNumViewId;
    return frameView;
}


-(UIView *) createPartView:(float) top titles:(NSArray *) titles contents:(NSArray *) contents{
    float sectionH = 20;
    float lineTextH = 22;
    float totalH = 0;
    UIFont *titleFont = [TRSkinManager smallFont1];
    UIFont *contentFont = [TRSkinManager mediumFont3];
    
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(5, top, self.view.width - 10, 71)];
    frameView.backgroundColor = [TRSkinManager bgColorWhite];
    frameView.layer.cornerRadius = 4;
    frameView.layer.borderColor = [TRSkinManager colorWithInt:0xe3e0de].CGColor;
    frameView.layer.borderWidth = [TRUtility lineHeight];
    
    float startY = 0;
    for (int i = 0 ; i < titles.count && contents.count == titles.count; i++) {
        totalH += sectionH; //先加上每段除去文字的高度
        
        NSString *title = [titles objectAtIndex:i];
        CGSize titleSize = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake(9999999, 22)];
        NSString *content = [contents objectAtIndex:i];
        CGSize contentsize = [content sizeWithFont:contentFont constrainedToSize:CGSizeMake(frameView.width - 30 - titleSize.width - 2, 99999999)];
        if (contentsize.height > 22) { // 一行放不下,另起一行
            totalH += 5 + lineTextH;//两行之间再设置5像素的间距
            contentsize = [content sizeWithFont:contentFont constrainedToSize:CGSizeMake(frameView.width - 30, 9999999)];
            totalH += contentsize.height;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, startY + sectionH/2, titleSize.width, lineTextH)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [TRSkinManager colorWithInt:0x999999];
            titleLabel.font = titleFont;
            titleLabel.text = title;
            [frameView addSubview:titleLabel];
            
            startY += sectionH/2 + lineTextH + 5;
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, startY, contentsize.width, contentsize.height)];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [TRSkinManager colorWithInt:0x666666];
            label2.font = contentFont;
            label2.text = content;
            label2.numberOfLines = 0;
            [frameView addSubview:label2];
            startY += label2.height + sectionH/2;
        } else { // 只有一行
            totalH += lineTextH;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, startY , titleSize.width, lineTextH + sectionH)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [TRSkinManager colorWithInt:0x999999];
            titleLabel.font = titleFont;
            titleLabel.text = title;
            [frameView addSubview:titleLabel];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right + 2, titleLabel.top , contentsize.width, titleLabel.height)];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [TRSkinManager colorWithInt:0x666666];
            label2.font = contentFont;
            label2.text = content;
            [frameView addSubview:label2];
            startY += sectionH + lineTextH;
        }
        if (i != titles.count - 1) { //添加横线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, startY, frameView.width, [TRUtility lineHeight])];
            line.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
            [frameView addSubview:line];
        }
    }
    
    if (picUrl.length > 0 && part2Titles == titles) {
        CGSize picSize = CGSizeMake(280, 150);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, startY, picSize.width, picSize.height)];
        imageView.userInteractionEnabled = YES;
        NSString *key = [TRUtility md5Value:picUrl];
        UIImage *image = [UIImage imageWithData: [[EGOCache globalCache] dataForKey:key]];
        if (image == nil) {
            imageView.image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcfcfcf] size:picSize];
            
            UIImageView *smallView = [[UIImageView alloc] initWithImage:TRImage(@"loadimg.png")];
            [smallView setLeft:imageView.width/2 - smallView.width/2];
            [smallView setTop:imageView.height/2 - smallView.height/2];
            [imageView addSubview:smallView];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url = [NSURL URLWithString:picUrl];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image2 = [UIImage imageWithData:data];
                if (image2) {
                    [[EGOCache globalCache] setData:data forKey:key withTimeoutInterval: 100 * 24 * 60 *60 ];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        float newH = (picSize.width/ image2.size.width) * image2.size.height;
                        [imageView setHeight:newH];
                        CGSize contentSize = contentScrollView.contentSize;
                        [contentScrollView setContentSize:CGSizeMake(contentSize.width, contentSize.height + newH - picSize.height)];
                        UIView *part2View = [contentScrollView viewWithTag:KPart2ViewId];
                        UIView *part3View = [contentScrollView viewWithTag:KPart3ViewId];
                        UIView *part4View = [contentScrollView viewWithTag:KPart4ViewId];
                        [part2View setHeight:part2View.height + newH - picSize.height];
                        [part3View setTop:part2View.bottom + 5];
                        [part4View setTop:part3View.bottom + 5];
                        
                        
                        imageView.image = image2;
                        [smallView removeFromSuperview];
                        UIImage *images = TRImage(@"scale.png");
                        UIImageView *scale = [[UIImageView alloc] initWithImage:images];
                        scale.frame = CGRectMake(imageView.width - 12 - images.size.width, imageView.height - 12 -images.size.height, images.size.width, images.size.height);
                        [imageView addSubview:scale];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageView:)];
                        [imageView addGestureRecognizer:tap];
                    });
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        smallView.image = TRImage(@"loadimgerr.png");
                    });
                }
            });
        } else {
            imageView.image = image;
            float newH = (picSize.width/ image.size.width) * image.size.height;
            [imageView setHeight:newH];
            
            image = TRImage(@"scale.png");
            UIImageView *scale = [[UIImageView alloc] initWithImage:image];
            scale.frame = CGRectMake(imageView.width - 12 - image.size.width, imageView.height - 12 -image.size.height, image.size.width, image.size.height);
            [imageView addSubview:scale];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageView:)];
            [imageView addGestureRecognizer:tap];
        }
        totalH += imageView.height + 5;
        [frameView addSubview:imageView];
        
        //添加图片
    }
    [frameView setHeight:totalH];

    return frameView;
}

- (void)openImageView:(UIGestureRecognizer*)gestureRecognizer {
    [MobClick event:@"limit_pic_scale"];
    NSString *key = [TRUtility md5Value:picUrl];
    UIImage *image = [UIImage imageWithData: [[EGOCache globalCache] dataForKey:key]];
    if (image) {
        TRImageScaleView *scaleView = [[TRImageScaleView alloc] initWithFrame:self.view.bounds Image:image];
        [self.view addSubview:scaleView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= KHeightReduce;
//    [self.view removeGestureRecognizer:recognizer];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
//    [scrollView setContentSize:CGSizeMake(self.view.width, 1000)];
    [self.view addSubview:scrollView];
    float height = 0;
    contentScrollView = scrollView;

    if (carNums.count != 0) {
        scrollcarView = [[TRScrollCarView alloc] initWithFrame:CGRectMake(0, 0, 320, 206) carnums:self.carNums];
        scrollcarView.delegate = self;
        [scrollView addSubview:scrollcarView];
        height += scrollcarView.height;
        if ([self.carLimitInfo containsObject:@"今日限行"]) {
            NSUInteger index = [self.carLimitInfo indexOfObject:@"今日限行"];
            [scrollcarView setCurrentIndex:index];
            scrollcarView.limitLabel.text = @"今日限行";
        } else if([self.carLimitInfo containsObject:@"明日限行"]){
            NSUInteger index = [self.carLimitInfo indexOfObject:@"明日限行"];
            [scrollcarView setCurrentIndex:index];
            scrollcarView.limitLabel.text = @"明日限行";
        } else {
            scrollcarView.limitBgView.hidden = YES;
        }
    } else {
        height += 5;
    }

    UIView *frameView = [self createLimitNumView:height];
    [scrollView addSubview:frameView];
    float gap = 5;
    height += gap + frameView.height;
    
    UIView *part2View = [self createPartView:frameView.bottom + gap titles:self.part2Titles contents:self.part2Contents];
    [scrollView addSubview:part2View];
    part2View.tag = KPart2ViewId;
    height += gap + part2View.height;
    
    UIView *part3View = nil;
    if (self.part3Titles.count > 0) {
        part3View = [self createPartView:part2View.bottom + gap titles:self.part3Titles contents:self.part3Contents];
        [scrollView addSubview:part3View];
        part3View.tag = KPart3ViewId;
        height += gap + part3View.height;
    }
    
    if (self.part4Titles.count > 0) {
        UIView *part4View = [self createPartView:part3View.bottom + gap titles:self.part4Titles contents:self.part4Contents];
        [scrollView addSubview:part4View];
        part4View.tag = KPart4ViewId;
        height += gap + part4View.height;
    }
    
    [scrollView setContentSize:CGSizeMake(self.view.width, height)];
}

- (void) indexChanged:(NSUInteger) index{
    NSString *str = [self.carLimitInfo objectAtIndex:index];
    if (str.length > 0) {
        scrollcarView.limitBgView.hidden = NO;
        scrollcarView.limitLabel.text = str;
    } else {
        scrollcarView.limitBgView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
