//
//  AddressPickViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-3-13.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "AddressPickViewController.h"
#import "CityViewController.h"
#import "AreaDBManager.h"
#import "OfficAdressCell.h"
#import "NSOfficInfo.h"
#import "TRGardMapViewController.h"

@interface AddressPickViewController ()

@end

@implementation AddressPickViewController

@synthesize city;
@synthesize myTableView;
@synthesize dataArray;

-(NSString *) naviTitle{
    return @"违章处理地址";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) naviRightClick:(id) sender{
    if (inLoading) {
        return;
    }
    CityViewController *cityView = [[CityViewController alloc] init];
    cityView.controllerType = 1;
    cityView.areaDelegate = self;
    if (self.city) {
        [cityView setSelectCitys:[NSArray arrayWithObject:self.city]];
    }
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:cityView];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void) selectedCitys:(NSArray *)array{
    if (array.count > 0) {
        City *cityM = [array objectAtIndex:0];
        if (cityM.cityId == self.city.cityId) {
            return;
        }
        self.city = cityM;
        [[NSUserDefaults standardUserDefaults] setObject:self.city.name forKey:@"MapUsedCityName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self setRightIcon:cityM.name];
        [self getOfficeInfo];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) setRightIcon:(NSString *)iconText
{
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    if (rightItem == nil) {
        UIButton* rView = [UIButton buttonWithType:UIButtonTypeCustom];
        rView.frame = CGRectMake(0, 0, 84, 44);
        rView.backgroundColor = [UIColor clearColor];
        [rView addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager textColorWhite];
        label.font = [TRSkinManager mediumFont3];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 100;
        [rView addSubview:label];
        UIImageView * imageIcon = [[UIImageView alloc] initWithImage:TRImage(@"downA.png")];
        imageIcon.frame = CGRectMake(74, 22 - imageIcon.height/2, imageIcon.width, imageIcon.height);
        [rView addSubview:imageIcon];
        
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:rView];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    UIView *customView = rightItem.customView;
    UILabel *label = (UILabel *)[customView viewWithTag:100];
    label.text = iconText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger cityId = [[NSUserDefaults standardUserDefaults] integerForKey:KCurrentCityId];
    if (cityId <= 0) {
        self.city = [AreaDBManager getCityByKeyWord:@"北京"];
    } else {
        self.city = [AreaDBManager getCityByCityId:cityId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.city.name forKey:@"MapUsedCityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setRightIcon:city.name];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= (KHeightReduce + 12);
    self.myTableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [TRSkinManager bgColorLight];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [NSMutableArray array];
    [self getCacheData];//先获取cache数据填充界面
    if (self.dataArray.count == 0) {
        NSOfficInfo *info = [[NSOfficInfo alloc] init];
        info.name = @"东城交通支队北区执法站";
        info.address = @"东城区雍和宫桥下东侧停车场内";
        info.phoneCall = @"010-64040355";
        info.phoneShow = @"010-64040355";
        info.latbaidu = @"39.954485077164";
        info.lngbaidu = @"116.42376532407";
        info.latgaode = @"39.946929";
        info.lnggaode = @"116.417412";
        [self.dataArray addObject:info];
    }
    [self getOfficeInfo];
    
    [self addNodataView:myTableView];
    [self addNetworkErrView:myTableView];
    UIButton *btn = (UIButton *)[networkErrView viewWithTag:101];
    [btn addTarget:self action:@selector(getOfficeInfo) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:KCommentBeClicked] == NO && [TRAppDelegate appDelegate].appInfo.showScore) {
        [self commentAlertViewShow];
//        [self performSelector:@selector(commentAlertViewShow) withObject:nil afterDelay:3];
    }
}


-(void) commentAlertViewShow{
    [MobClick event:@"show_comment"];
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"鼓励一下" message:@"感谢使用违章查询助手，如果喜欢我们的软件，请您评五星给我们鼓励。" delegate:self cancelButtonTitle:@"不、谢谢" otherButtonTitles:@"好的", nil];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KCommentBeClicked];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(buttonIndex != alertView.cancelButtonIndex){
        NSString *url = [TRAppDelegate appDelegate].appInfo.commentUrl;
        if (url.length == 0) {
            url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"708985992"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

-(void) getCacheData
{
    if (service == nil) {
        service = [[GetOfficeInfoService alloc] init];
        service.delegate = self;
    }
    NSArray *array = [service getCacheItemsByCity:(int)self.city.cityId];
    for (NSDictionary *temp in array) {
        NSOfficInfo *info = [[NSOfficInfo alloc] init];
        info.name = [temp objectForKey:@"name"];
        info.address = [temp objectForKey:@"address"];
        info.phoneCall = [temp objectForKey:@"phone_call"];
        info.phoneShow = [temp objectForKey:@"phone_show"];
        info.latbaidu = [temp objectForKey:@"latbaidu"];
        info.lngbaidu = [temp objectForKey:@"lngbaidu"];
        info.latgaode = [temp objectForKey:@"latgaode"];
        info.lnggaode = [temp objectForKey:@"lnggaode"];
        [dataArray addObject:info];
    }
}

-(void) getOfficeInfo{
    if (service == nil) {
        service = [[GetOfficeInfoService alloc] init];
        service.delegate = self;
    }
    [service getOfficeInfoByCity:(int)self.city.cityId];
    inLoading = YES;
    [self showLoadingAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count == 0 && networkErrView.hidden) {
        noDataView.hidden = NO;
    } else {
        noDataView.hidden = YES;
    }
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArray.count > [indexPath row]) {
        NSOfficInfo *info = [dataArray objectAtIndex:[indexPath row]];
        float height = 140;
        UIFont *font = [TRSkinManager mediumFont3];
        float width = 216;
        CGSize size1 = [info.name sizeWithFont:font constrainedToSize:CGSizeMake(999999, font.lineHeight)];
        int lineCount = size1.width/width;
        if ((int)size1.width %  (int)width != 0) {
            lineCount++;
        }
        height += (lineCount - 1) * font.lineHeight;
        
        font = [UIFont systemFontOfSize:15];
        CGSize size2 = [info.address sizeWithFont:font constrainedToSize:CGSizeMake(999999, font.lineHeight)];
        lineCount = size2.width/width;
        if ((int)size2.width %  (int)width != 0) {
            lineCount++;
        }
        height += (lineCount - 1) * font.lineHeight;
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfficAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfficAdressCell"];
    if (cell == nil) {
        cell = [[OfficAdressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OfficAdressCell"];
        cell.observer = self;
    }
    if (dataArray.count > [indexPath row]) {
        NSOfficInfo *info = [dataArray objectAtIndex:[indexPath row]];
        cell.titleLabel.text = info.name;
        cell.addressLabel.text = info.address;
        cell.phoneLabel.text = info.phoneShow;
        cell.cellId = (int)[indexPath row];
    }
    return cell;
}


#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    inLoading = NO;
    [self hideLoadingViewAnimated:YES];
    networkErrView.hidden = YES;
    NSArray *array = service.items;
    [dataArray removeAllObjects];
    for (NSDictionary *temp in array) {
        NSOfficInfo *info = [[NSOfficInfo alloc] init];
        info.name = [temp objectForKey:@"name"];
        info.address = [temp objectForKey:@"address"];
        info.phoneShow = [temp objectForKey:@"phone_show"];
        info.phoneCall = [temp objectForKey:@"phone_call"];
        info.latbaidu = [temp objectForKey:@"latbaidu"];
        info.lngbaidu = [temp objectForKey:@"lngbaidu"];
        info.latgaode = [temp objectForKey:@"latgaode"];
        info.lnggaode = [temp objectForKey:@"lnggaode"];
        [dataArray addObject:info];
    }
    [self.myTableView reloadData];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    inLoading = NO;
    [self hideLoadingViewAnimated:YES];
    [dataArray removeAllObjects];
    networkErrView.hidden = NO;
    [self.myTableView reloadData];
}

#pragma mark -
#pragma mark OfficAdressCellEventObserver Methods
-(void) cell:(int)cellId beClickBtnId:(int)btnId
{
    if (cellId < dataArray.count) {
        NSOfficInfo *info = [dataArray objectAtIndex:cellId];
        if (btnId == 1) {
            TRGardMapViewController *gardView = [[TRGardMapViewController alloc] init];
            gardView.officeInfo = info;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gardView];
            [self presentViewController:navi animated:YES completion:nil];
        } else {
            [self makeCall:info.phoneCall];
        }
    }
}

@end
