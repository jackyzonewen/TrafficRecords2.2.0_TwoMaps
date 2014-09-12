//
//  TRAppViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-4-23.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRAppViewController.h"
#import "TRAppTableViewCell.h"
#import "AppInfo.h"
#import "JSON.h"

@interface TRAppViewController ()

@end

@implementation TRAppViewController

@synthesize myTableView;
@synthesize dataArray;

-(NSString *) naviTitle{
    return @"精品应用";
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
    self.dataArray = [NSMutableArray array];
    NSString *text = [TRUtility readcontentFromFile:KAPPRecommadListFileName];
    if (text.length > 0) {
        NSDictionary *dic = [text JSONValue];
        NSDictionary * result = [dic objectForKey:@"result"];
        NSArray *array = [result objectForKey:@"items"];
        for (NSDictionary *temp in array) {
            AppInfo *info = [[AppInfo alloc] init];
            [dataArray addObject:info];
            info.iconUrl = [temp objectForKey:@"icon_url"];
            info.appName = [temp objectForKey:@"appname"];
            info.appResume = [temp objectForKey:@"info"];
            info.downloadUrl = [temp objectForKey:@"download_url"];
        }
    } else {
    }
    
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= (KHeightReduce + 12);
    self.myTableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [TRSkinManager bgColorLight];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addNetworkErrView:myTableView];

    UIButton *btn = (UIButton *)[networkErrView viewWithTag:101];
    [btn addTarget:self action:@selector(getRemmendList) forControlEvents:UIControlEventTouchUpInside];
    [self getRemmendList];
    // Do any additional setup after loading the view.
}

-(void) getRemmendList{
    if (dataArray.count == 0) {
        [self showLoadingAnimated:YES];
    }
    if (recommndList == nil) {
        recommndList = [[AppRecommendService alloc] init];
        recommndList.delegate = self;
    }
    [recommndList getRecommendList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfficAdressCell"];
    if (cell == nil) {
        cell = [TRAppTableViewCell loadFromXib];
    }
    if (dataArray.count > indexPath.row) {
        AppInfo *info = [dataArray objectAtIndex:indexPath.row];
        [cell.appIconView setImageWithURL:[NSURL URLWithString:info.iconUrl] placeholderImage:TRImage(@"iconHolder.png")];
        cell.appNameLabel.text = info.appName;
        cell.appResumeLabel.text = info.appResume;
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count > indexPath.row) {
        AppInfo *info = [dataArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:info.downloadUrl];
        [[UIApplication sharedApplication] openURL:url];
        [MobClick event:@"recommend_app_download" label:info.appName];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    [self hideLoadingViewAnimated:YES];
    networkErrView.hidden = YES;
    [dataArray removeAllObjects];
    NSDictionary * result = [recommndList.responseDic objectForKey:@"result"];
    NSArray *array = [result objectForKey:@"items"];
    for (NSDictionary *temp in array) {
        AppInfo *info = [[AppInfo alloc] init];
        [dataArray addObject:info];
        info.iconUrl = [temp objectForKey:@"icon_url"];
        info.appName = [temp objectForKey:@"appname"];
        info.appResume = [temp objectForKey:@"info"];
        info.downloadUrl = [temp objectForKey:@"download_url"];
    }
    [self.myTableView reloadData];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self hideLoadingViewAnimated:YES];
    [dataArray removeAllObjects];
    networkErrView.hidden = NO;
    [self.myTableView reloadData];
}

@end
