//
//  GardLineChooseViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-3-16.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "GardLineChooseViewController.h"
#import "ManuaLocationViewController.h"
#import "NaviMapViewController.h"

@interface GardLineChooseViewController ()

@end

@implementation GardLineChooseViewController

@synthesize myLocationBtn;
@synthesize targetAddBtn;
@synthesize busBtn;
@synthesize carBtn;
@synthesize walkBtn;
@synthesize officeInfo;
@synthesize cityName;
@synthesize busTransits;
@synthesize drivePaths;
@synthesize walkingPaths;
@synthesize footView;
@synthesize notFoundLineView;
@synthesize loadingNaviView;
@synthesize notLocationView;

-(NSString *) naviTitle{
    return @"路线导航";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc{
    self.search.delegate = nil;
    self.search = nil;
    _mapView.delegate = nil;
    _mapView = nil;
}

-(void) addLineAt:(CGRect) frame
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcdcdcd];
    [self.view addSubview:line];
}

-(void) addShadowToView:(UIView *) view
{
    UIImage *shadow = TRImage(@"shadow.png");
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, shadow.size.height)];
    shadowView.image = shadow;
    [view addSubview:shadowView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [TRSkinManager bgColorWhite];
    self.carBtn.selected = YES;
    [targetAddBtn setTitle:officeInfo.address forState:UIControlStateNormal];
    UIImageView *myPlaceIcon = [[UIImageView alloc] initWithImage:TRImage(@"myPlace.png")];
    myPlaceIcon.frame = CGRectMake(63, 22, myPlaceIcon.width, myPlaceIcon.height);
    [myLocationBtn addSubview:myPlaceIcon];
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, busBtn.bottom + 0.5, self.view.width, self.view.height - KHeightReduce- 146.5) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [TRSkinManager bgColorLight];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addLineAt:CGRectMake(34, myLocationBtn.bottom, myTableView.width - 34, 0.5)];
    [self addLineAt:CGRectMake(0, targetAddBtn.bottom, self.view.width, 0.5)];
    [self addLineAt:CGRectMake(0, busBtn.bottom, self.view.width, 0.5)];
    [self addShadowToView:myTableView];
    
    
    float height = 72;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.width, height)];
    view.backgroundColor = [TRSkinManager bgColorLight];
    UIImage *bgImage = [TRImage(@"loginBg.png") stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    UIButton * bgBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(54, 30, 211, 40);
    [bgBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
//    [bgBtn setBackgroundImage:[TRImage(@"loginBgHL.png") stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [bgBtn setTitle:@"查看地图导航" forState:UIControlStateNormal];
    [bgBtn.titleLabel setFont:[TRSkinManager mediumFont2]];
    [bgBtn setTitleColor:[TRSkinManager textColorWhite] forState:UIControlStateNormal];
    [bgBtn addTarget:self action:@selector(naviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bgBtn];
    self.footView = view;
    
//    TRLoadingView *loading = [[TRLoadingView alloc] initWithParentView:self.view];
//    [loading start];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (startPos.latitude <= 0 || startPos.longitude <= 0) {
        [self startLocaltion];
    }
}

-(UIView*)notFoundLineView
{
    if (notFoundLineView == nil) {
        self.notFoundLineView = [[UIView alloc] initWithFrame:myTableView.frame];
        notFoundLineView.backgroundColor = [TRSkinManager bgColorLight];
        [self.view addSubview:notFoundLineView];
        UIImageView *icon = [[UIImageView alloc] initWithImage:TRImage(@"noResult.png")];
        [icon setLeft:notFoundLineView.width/2 - icon.width/2];
        [icon setTop:23];
        [notFoundLineView addSubview:icon];
        
        UIFont *font = [TRSkinManager smallFont1];
        NSString *text1 = @"没有找到路线，";
        NSString *text2 = @"试试其他方式";
        float width1 = [text1 sizeWithFont:font constrainedToSize:CGSizeMake(999999, font.lineHeight)].width;
        float width2 = [text2 sizeWithFont:font constrainedToSize:CGSizeMake(999999, font.lineHeight)].width;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(notFoundLineView.width/2 - (width1 + width2)/2, icon.bottom + 20, width1, font.lineHeight)];
        textLabel.text = text1;
        textLabel.font = font;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [TRSkinManager textColorLightDark];
        textLabel.backgroundColor = [UIColor clearColor];
        [notFoundLineView addSubview:textLabel];
        
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
        butn.frame = CGRectMake(textLabel.right, icon.bottom + 20, width2, font.lineHeight);
        [butn setTitle:text2 forState:UIControlStateNormal];
        butn.titleLabel.font = font;
        [butn setTitleColor:[TRSkinManager labelColorRed] forState:UIControlStateNormal];
        [butn addTarget:self action:@selector(naviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [notFoundLineView addSubview:butn];
        
//        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabel.right, icon.bottom + 20, width2, font.lineHeight)];
//        textLabel.text = text2;
//        textLabel.font = font;
//        textLabel.textAlignment = NSTextAlignmentCenter;
//        textLabel.textColor = [TRSkinManager labelColorRed];
//        textLabel.backgroundColor = [UIColor clearColor];
//        [notFoundLineView addSubview:textLabel];
        
        
        [self addShadowToView:notFoundLineView];
    }
    return notFoundLineView;
}

-(UIView *)notLocationView
{
    if (notLocationView == nil) {
        self.notLocationView = [[UIView alloc] initWithFrame:myTableView.frame];
        notLocationView.backgroundColor = [TRSkinManager bgColorLight];
        [self.view addSubview:notLocationView];
        UIImageView *icon = [[UIImageView alloc] initWithImage:TRImage(@"noResult.png")];
        [icon setLeft:notLocationView.width/2 - icon.width/2];
        [icon setTop:23];
        [notLocationView addSubview:icon];
        
        UIFont *font = [TRSkinManager smallFont1];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom + 20, notLocationView.width, font.lineHeight)];
        textLabel.text = @"定位失败，请点击我的位置进行定位";
        textLabel.font = font;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [TRSkinManager textColorDark];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = 100;
        [notLocationView addSubview:textLabel];
        [self addShadowToView:notLocationView];
    }
    return notLocationView;
}

-(UIView *)loadingNaviView
{
    if (loadingNaviView == nil) {
        self.loadingNaviView = [[TRLoadingView alloc] initWithParentView:self.view];
        loadingNaviView.frame = CGRectMake(myTableView.left, myTableView.top, myTableView.width, 120); //myTableView.frame;
        [loadingNaviView start];
//        loadingNaviView.backgroundColor = [TRSkinManager bgColorLight];
//        [self.view addSubview:loadingNaviView];
//        UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [loadingNaviView addSubview:indicatorView];
//        [indicatorView startAnimating];
//        UIFont *font = [TRSkinManager mediumFont3];
//        NSString *text = @"正在加载导航线路，请稍候...";
//        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(99999, font.lineHeight)];
//        float totalW = indicatorView.width + 2 + size.width;
//        [indicatorView setTop:60];
//        [indicatorView setLeft:loadingNaviView.width/2 - totalW/2];
//        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(indicatorView.right + 2, indicatorView.top, size.width, indicatorView.height)];
//        textLabel.text = text;
//        textLabel.font = font;
//        textLabel.textColor = [TRSkinManager colorWithInt:0x333333];
//        textLabel.backgroundColor = [UIColor clearColor];
//        [loadingNaviView addSubview:textLabel];
//        [self addShadowToView:loadingNaviView];
    }
    return loadingNaviView;
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (busBtn.selected) {
        return self.busTransits.count;
    }
    else if(carBtn.selected && self.drivePaths.count > 0)
    {
        return 1;
    }
    else if(walkBtn.selected && self.walkingPaths.count > 0)
    {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NaviMapViewController *naviMapView = [[NaviMapViewController alloc] init];
    if (busBtn.selected) {
        naviMapView.type = 0;
        if (self.busTransits.count > [indexPath row]) {
            AMapTransit *transit = [self.busTransits objectAtIndex:[indexPath row]];
            naviMapView.busLineData = transit;
            naviMapView.mytitle = [self busInfoBy:transit];
        }

    }
    else if(carBtn.selected)
    {
        naviMapView.type = 1;
        if (self.drivePaths.count > [indexPath row]) {
            AMapPath *path = [self.drivePaths objectAtIndex:[indexPath row]];
            naviMapView.pathData = path;
            NSArray *array = [self pathsInfoBy:path];
            if (array.count > 0) {
                naviMapView.mytitle = [array objectAtIndex:0];
            }
            if (array.count > 1) {
                naviMapView.subtitle = [array objectAtIndex:1];
            }
        }
    }
    else if(walkBtn.selected)
    {
        naviMapView.type = 2;
        if (self.walkingPaths.count > [indexPath row]) {
            AMapPath *path = [self.walkingPaths objectAtIndex:[indexPath row]];
            naviMapView.pathData = path;
            NSArray *array = [self pathsInfoBy:path];
            if (array.count > 0) {
                naviMapView.mytitle = [array objectAtIndex:0];
            }
            if (array.count > 1) {
                naviMapView.subtitle = [array objectAtIndex:1];
            }
        }
    }
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:naviMapView];
    [self presentViewController:naviMapView animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GardLine"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GardLine"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [TRSkinManager setCellSelectBgColor:cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = nil;
        cell.backgroundColor = [TRSkinManager bgColorLight];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, tableView.width, 0.5)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [cell addSubview:line];
        UIFont *font1 = [UIFont systemFontOfSize:15];
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 15, 250, font1.lineHeight)];
        textLabel.textColor = [TRSkinManager colorWithInt:0x666666];
        textLabel.font = font1;
        textLabel.numberOfLines = 0;
        textLabel.tag = 100;
        textLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:textLabel];
        font1 = [UIFont systemFontOfSize:14];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, textLabel.bottom + 10, 250, font1.lineHeight)];
        textLabel.textColor = [TRSkinManager colorWithInt:0x999999];
        textLabel.font = font1;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = 101;
        [cell addSubview:textLabel];
    }
    UILabel *label1 = (UILabel*)[cell viewWithTag:100];
    UILabel *label2 = (UILabel*)[cell viewWithTag:101];
    if (busBtn.selected && [indexPath row] < self.busTransits.count) {
        AMapTransit *transit = [self.busTransits objectAtIndex:[indexPath row]];
        label1.text = [self busInfoBy:transit];
        [label1 setTop:0];
        [label1 setHeight:height];
        label2.hidden = YES;
    }
    else if(carBtn.selected && [indexPath row] < self.drivePaths.count)
    {
        label2.hidden = NO;
        [label1 setTop:15];
        [label1 setHeight:label1.font.lineHeight];
        AMapPath *path = [self.drivePaths objectAtIndex:[indexPath row]];
        NSArray * array = [self pathsInfoBy:path];
        if (array.count >= 1) {
            label1.text = [array objectAtIndex:0];
        }
        if (array.count >= 2) {
            label2.text = [array objectAtIndex:1];
        }
    }
    else if(walkBtn.selected)
    {
        label2.hidden = NO;
        [label1 setTop:15];
        [label1 setHeight:label1.font.lineHeight];
        AMapPath *path = [self.walkingPaths objectAtIndex:[indexPath row]];
        NSArray * array = [self pathsInfoBy:path];
        if (array.count >= 1) {
            label1.text = [array objectAtIndex:0];
        }
        if (array.count >= 2) {
            label2.text = [array objectAtIndex:1];
        }
    }
    return cell;
}

-(NSString *) busInfoBy:(AMapTransit*) transit
{
    NSMutableString *reslt = [NSMutableString string];
    for (AMapSegment *segment in transit.segments) {
        if (segment.busline) {
            if (reslt.length > 0) {
                [reslt appendString:@"→"];
            }
            NSString *name = segment.busline.name;
            NSRange r = [name rangeOfString:@"("];
            if (r.length != 0 ) {
                [reslt appendString:[name substringToIndex:r.location]];
            } else
            {
                [reslt appendString:segment.busline.name];
            }
        }
    }
    return reslt;
}

-(NSArray *) pathsInfoBy:(AMapPath*) path{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (AMapStep * step in [path steps]) {
        NSNumber *doubleV = [mDic objectForKey:step.road];
        if (step.road.length == 0) {
            continue;
        }
        if (doubleV == nil) {
            doubleV = [NSNumber numberWithDouble:step.distance];
            [mDic setObject:doubleV forKey:step.road];
        } else {
            double newV = doubleV.doubleValue + step.distance;
            doubleV = [NSNumber numberWithDouble:newV];
            [mDic setObject:doubleV forKey:step.road];
        }
    }
    
    NSString *firstPath = @"";
    NSString *secondPath = @"";
    for (NSString *road in [mDic allKeys]) {
        double firstV = [[mDic objectForKey:firstPath] doubleValue];
        double secondV = [[mDic objectForKey:secondPath] doubleValue];
        double currentV = [[mDic objectForKey:road] doubleValue];
        if (currentV > firstV) {
            secondPath = firstPath;
            firstPath = road;
        } else {
            if (currentV > secondV) {
                secondPath = road;
            }
        }
    }
    NSString *name = [NSString stringWithFormat:@"途经%@和%@",firstPath,secondPath];
    if (secondPath.length == 0) {
        name = [NSString stringWithFormat:@"途经%@",firstPath];
    }
    NSString *totalDisDes = nil;
    if (path.distance > 1000) {
        float totalDis = path.distance/1000.0;
        totalDisDes = [NSString stringWithFormat:@"%0.1f公里", totalDis];
    } else {
        totalDisDes = [NSString stringWithFormat:@"%d米", (int)path.distance];
    }
    return [NSArray arrayWithObjects:name,totalDisDes, nil];
}

-(void) openBaiduAppToNavi
{
    NSMutableString *baidu = [NSMutableString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%@,%@&mode=driving&src=", startPos.latitude, startPos.longitude, officeInfo.latbaidu, officeInfo.lngbaidu];
    [baidu appendString:[TRUtility URLEncodedString:@"TRMapScheme:|TRMapScheme:"]];
    
    
    NSURL *url = [NSURL URLWithString:baidu];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self showInfoView:@"抱歉，在您的设备上没有找到百度地图"];
    }
}

-(void) openGaodeAppToNavi{
    NSString *urlScheme = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=wz&backScheme=TRMapScheme:&lat=%@&lon=%@&dev=0&style=2", officeInfo.latgaode, officeInfo.lnggaode];
    NSURL *url = [NSURL URLWithString:urlScheme];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void) openSystemMapToNavi{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f) {
        //ios_version为4.0～5.1时 调用谷歌地图客户端
        
        //生成url字符串
        NSString *currentLocation = [NSString stringWithFormat:@"%f,%f",startPos.latitude, startPos.longitude];
        NSString *desLocation = [NSString stringWithFormat:@"%f,%f",[officeInfo.latgaode floatValue], [officeInfo.lnggaode floatValue]];
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",
                               currentLocation,desLocation];
        //转换为utf8编码
        urlString =  [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        UIApplication *app =[UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //验证url是否可用
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }else{
            //手机客户端不支持此功能 或者 目的地有误
            [self showInfoView:@"无法打开地图进行导航"];
        }
        
    }else{
        //ios_version为 >=6.0时 调用苹果地图客户端
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([officeInfo.latgaode floatValue], [officeInfo.lnggaode floatValue]);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:@"结束"];
            // Set the directions mode to "Walking"
            // Can use MKLaunchOptionsDirectionsModeDriving instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            if (self.carBtn.selected) {
                launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            }
            // Get the "Current User Location" MKMapItem
            
            MKMapItem *currentLocationMapItem = nil;
            if (NO) {
                currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            } else
            {
                MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startPos
                                                                    addressDictionary:nil];
                currentLocationMapItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
            }
            [currentLocationMapItem setName:@"开始"];
            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }
    }
}

-(void)naviBtnClick:(id) sender
{
    NSString *title1 = nil;
    NSString *title2 = nil;
    NSString *title3 = nil;
    NSString *gaode = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=wz&backScheme=TRMapScheme:&lat=%@&lon=%@&dev=0&style=2", officeInfo.latgaode, officeInfo.lnggaode];
    NSURL *gaodeUrl = [NSURL URLWithString:gaode];
    
    NSMutableString *baidu = [NSMutableString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%@,%@&mode=driving&src=", startPos.latitude, startPos.longitude, officeInfo.latbaidu, officeInfo.lngbaidu];
    [baidu appendString:[TRUtility URLEncodedString:@"TRMapScheme:|TRMapScheme:"]];
    NSURL *baiduUrl = [NSURL URLWithString:baidu];
    
    UIApplication *app =[UIApplication sharedApplication];
    if ([app canOpenURL:gaodeUrl]) {
        title1 = @"高德地图";
    }
    if ([app canOpenURL:baiduUrl]) {
        if (title1 == nil) {
            title1 = @"百度地图";
        } else {
            title2 = @"百度地图";
        }
    }
    if (title1 == nil) {
        title1 = @"系统自带地图";
    } else if(title2 == nil){
        title2 = @"系统自带地图";
    } else {
        title3 = @"系统自带地图";
    }
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择导航地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:title1,title2,title3,nil];
    sheet.tag = 103;
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnClick:(UIButton *)sender
{
    if (sender == self.busBtn) {
        self.walkBtn.selected = NO;
        self.carBtn.selected = NO;
    } else if(sender == self.carBtn)
    {
        self.walkBtn.selected = NO;
        self.busBtn.selected = NO;
    } else if(sender == self.walkBtn)
    {
        self.carBtn.selected = NO;
        self.busBtn.selected = NO;
    }
    sender.selected = YES;
    [self upDateViewState];
}

-(void) upDateViewState
{
    int type = -1;//0为需要加载；1为已加载，但无数据；2为已加载，有数据;3定位失败或者未定位
    if (self.busBtn.selected) {
        if (busTransits == nil) {
            type = 0;
        } else
        {
            if (busTransits.count == 0) {
                type = 1;
            } else {
                type = 2;
            }
        }
        myTableView.tableFooterView = nil;
    } else if(self.carBtn.selected)
    {
        if (drivePaths == nil) {
            type = 0;
        } else
        {
            if (drivePaths.count == 0) {
                type = 1;
            } else {
                type = 2;
            }
        }
        myTableView.tableFooterView = self.footView;
    } else if(self.walkBtn.selected)
    {
        if (walkingPaths == nil) {
            type = 0;
        } else
        {
            if (walkingPaths.count == 0) {
                type = 1;
            } else {
                type = 2;
            }
        }
        myTableView.tableFooterView = self.footView;
    }
    if (startPos.latitude <=0 && startPos.longitude <= 0) {
        type = 3;
    }
    if (type == 0) {
        myTableView.hidden = YES;
        self.loadingNaviView.hidden = NO;
        self.notFoundLineView.hidden = YES;
        self.notLocationView.hidden = YES;
        [self startSearchNavi];
    }
    else if(type == 1)
    {
        myTableView.hidden = YES;
        self.loadingNaviView.hidden = YES;
        self.notFoundLineView.hidden = NO;
        self.notLocationView.hidden = YES;
    }
    else if(type == 2){
        myTableView.hidden = NO;
        self.loadingNaviView.hidden = YES;
        self.notFoundLineView.hidden = YES;
        self.notLocationView.hidden = YES;
        [myTableView reloadData];
    } else {
        myTableView.hidden = YES;
        self.loadingNaviView.hidden = YES;
        self.notFoundLineView.hidden = YES;
        self.notLocationView.hidden = NO;
        if (inAutoLocaling) {
            UILabel *label = (UILabel *)[self.notLocationView viewWithTag:100];
            label.text = @"正在定位，请稍候...";
        } else {
            UILabel *label = (UILabel *)[self.notLocationView viewWithTag:100];
            label.text = @"定位失败，请点击我的位置进行定位";
        }
    }
}

-(IBAction) locationBtnClick:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"自动定位",@"地图上选择", nil];
    sheet.tag = 104;
//    [sheet addButtonWithTitle:@"自动定位"];
//    [sheet addButtonWithTitle:@"地图上选择"];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 104) {
        if (buttonIndex == 0) {
            [self startLocaltion];
        }
        else if(buttonIndex == 1)
        {
            ManuaLocationViewController * manuaView = [[ManuaLocationViewController alloc] init];
            manuaView.delegate = self;
            manuaView.center = CLLocationCoordinate2DMake([self.officeInfo.latgaode doubleValue] , [officeInfo.lnggaode doubleValue]);
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:manuaView];
            [self presentViewController:navi animated:YES completion:nil];
        }
    } else if(actionSheet.tag == 103){
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"高德地图"]) {
            [self openGaodeAppToNavi];
        } else if([title isEqualToString:@"百度地图"])
        {
            [self openBaiduAppToNavi];
        } else if([title isEqualToString:@"系统自带地图"])
        {
            [self openSystemMapToNavi];
        }
    }
}

#pragma mark -
#pragma mark CLLocationManager代理
- (void)startLocaltion
{
    inAutoLocaling = YES;
    [self upDateViewState];
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    inAutoLocaling = NO;
    startPos = userLocation.location.coordinate;
    autoLocal = YES;
    //清空数据,重新搜索
    self.walkingPaths = nil;
    self.busTransits = nil;
    self.drivePaths = nil;
    
    [self getCityInfo];
    [self upDateViewState];
    _mapView.showsUserLocation = NO;
    [self performSelector:@selector(releaseMapView) withObject:nil afterDelay:1];
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    _mapView.showsUserLocation = NO;
    [self performSelector:@selector(releaseMapView) withObject:nil afterDelay:1];
    [self handleLocationFailed];
    inAutoLocaling = NO;
    startPos = CLLocationCoordinate2DMake(0, 0);
    [self upDateViewState];
}

-(void) releaseMapView
{
    _mapView.delegate = nil;
    _mapView = nil;
}

- (void)handleLocationFailed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"手动定位", nil];
    [alert show];
}

-(void) getCityInfo{
    self.cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"MapUsedCityName"];
    [self startSearchNavi];
}

#pragma mark -
#pragma mark UIAlertViewDelegate代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        ManuaLocationViewController * manuaView = [[ManuaLocationViewController alloc] init];
        manuaView.delegate = self;
        manuaView.center = CLLocationCoordinate2DMake([self.officeInfo.latgaode doubleValue] , [officeInfo.lnggaode doubleValue]);
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:manuaView];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark ManuaLocationViewControllerDelegate代理

-(void) locationBeLocated:(CLLocationCoordinate2D)locatedPos
{
    startPos = locatedPos;
    //清空数据,重新搜索
    self.walkingPaths = nil;
    self.busTransits = nil;
    self.drivePaths = nil;
    
    [self getCityInfo];
}

#pragma mark -
#pragma mark AMapSearchDelegate路径规划
-(void) startSearchNavi{
    if (startPos.latitude <= 0 || startPos.longitude <= 0) {
        return;
    }
    AMapSearchType type = AMapSearchType_NaviBus;
    if (busBtn.selected) {
        type = AMapSearchType_NaviBus;
    }
    else if(carBtn.selected)
    {
        type = AMapSearchType_NaviDrive;
    }
    else if(walkBtn.selected)
    {
        type = AMapSearchType_NaviWalking;
    }
    [self searchNavigationByType: type];
}

- (void)searchNavigationByType:(AMapSearchType) type
{
    if (self.search == nil) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey:KGaoDeMapKey Delegate:self];
    }
    if (startPos.latitude > 0 && startPos.longitude > 0) {
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = type;
        naviRequest.requireExtension = YES;
        if (AMapSearchType_NaviBus == type && self.cityName.length > 0) {
            naviRequest.city = self.cityName;
        }
        naviRequest.origin = [AMapGeoPoint locationWithLatitude:startPos.latitude longitude:startPos.longitude];
        naviRequest.destination = [AMapGeoPoint locationWithLatitude:[officeInfo.latgaode floatValue] longitude:[officeInfo.lnggaode floatValue]];
        [self.search AMapNavigationSearch: naviRequest];
    }

}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    //自驾车
    if (request.searchType == AMapSearchType_NaviDrive) {
        NSArray * array = response.route.paths;
        if (array == nil) {
            self.drivePaths = [NSArray array];
        }else{
            self.drivePaths = array;
        }
    }
    else if(request.searchType == AMapSearchType_NaviWalking)//步行
    {
        NSArray * array = response.route.paths;
        if (array == nil) {
            self.walkingPaths = [NSArray array];
        } else {
            self.walkingPaths = array;
        }
    }
    else if(request.searchType == AMapSearchType_NaviBus)//公交
    {
        NSArray * array = response.route.transits;
        if (array == nil) {
            self.busTransits = [NSArray array];
        } else {
            self.busTransits = array;
        }

    }
    [self upDateViewState];
}

- (void)search:(id)searchRequest error:(NSString*)errInfo
{
    AMapNavigationSearchRequest *request = searchRequest;
    if (request.searchType == AMapSearchType_NaviDrive) {
        self.drivePaths = [NSArray array];
    }
    else if(request.searchType == AMapSearchType_NaviWalking)//步行
    {
        self.walkingPaths = [NSArray array];
    }
    else if(request.searchType == AMapSearchType_NaviBus)//公交
    {
        self.busTransits = [NSArray array];
    }
    [self upDateViewState];
}


@end
