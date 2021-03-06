//
//  AreaRoundViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-7-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AreaRoundViewController.h"
//#import "RoundBaiduMapViewController.h"
#import "RoundPoiSearchMapViewController.h"
@interface AreaRoundViewController ()

@end

@implementation AreaRoundViewController


-(NSString *) naviTitle{
    return @"周边服务";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *texts = [NSArray arrayWithObjects:@"交通队",@"银行",@"4S店",@"加油站",@"停车场",@"洗车",@"汽车美容", @"汽车装饰", @"汽车改装", @"汽车维修", @"酒店", nil];
    NSArray *iconnames = [NSArray arrayWithObjects:@"police.png", @"bank.png", @"4S.png", @"jiayou.png", @"park.png", @"washcar.png",  @"meirong.png", @"zhuangshi.png", @"gaizhuang.png", @"repair.png",@"hotel.png",nil];
    float height = 86;
    float itemW = self.view.width/3;
    float lineH = [TRUtility lineHeight];
    for (int i = 0; i < texts.count; i++) {
        CGRect rect = CGRectMake(itemW * (i % 3), KDefaultStartY + ((int)(i / 3)) *height, itemW, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:[TRUtility imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[TRUtility imageWithColor:[TRSkinManager selectBgColor]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image =TRImage([iconnames objectAtIndex:i]);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(btn.width/2 - imageView.width/2, 12, imageView.width, imageView.height);
        [btn addSubview:imageView];
        [btn setTitle:[texts objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
        btn.titleLabel.font = [TRSkinManager smallFont1];
        [self.view addSubview:btn];
        
        if ((i + 1) % 3 != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right - lineH, btn.top, lineH, btn.height)];
            line.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
            [self.view addSubview:line];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.left, btn.bottom - lineH, btn.width, lineH)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xdedede];
        [self.view addSubview:line];
    }
//    UICollectionView

    
    // Do any additional setup after loading the view.
}

-(void) btnClick:(UIButton *) btn{
    NSString *str = [btn titleForState:UIControlStateNormal];
    [MobClick event:@"nearby_show" label:str];
    //RoundBaiduMapViewController * round = [[RoundBaiduMapViewController alloc] init];
    RoundPoiSearchMapViewController* round=[[RoundPoiSearchMapViewController alloc] init];
    if ([str isEqualToString:@"交通队"]) {
        round.searchType =  EAreaRoundTrafficPolice;
    } else if([str isEqualToString:@"银行"]){
        round.searchType =  EAreaRoundBank;
    } else if([str isEqualToString:@"4S店"]){
        round.searchType =  EAreaRound4sShop;
    } else if([str isEqualToString:@"加油站"]){
        round.searchType =  EAreaRoundGasStation;
    } else if([str isEqualToString:@"停车场"]){
        round.searchType =  EAreaRoundParking;
    } else if([str isEqualToString:@"洗车"]){
        round.searchType =  EAreaRoundWashCar;
    } else if([str isEqualToString:@"酒店"]){
        round.searchType =  EAreaRoundHotel;
    } else if([str isEqualToString:@"汽车美容"]){
        round.searchType =  EAreaRoundMeiRong;
    } else if([str isEqualToString:@"汽车装饰"]){
        round.searchType =  EAreaRoundMeiRong;
    } else if([str isEqualToString:@"汽车改装"]){
        round.searchType =  EAreaRoundMeiRong;
    } else if([str isEqualToString:@"汽车维修"]){
        round.searchType =  EAreaRoundMeiRong;
    }
    round.typetitle = str;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:round];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
