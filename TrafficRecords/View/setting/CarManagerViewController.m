//
//  CarManagerViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-25.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "CarManagerViewController.h"
#import "CarInfo.h"
#import "AddCarViewController.h"
#import "OpenUDID.h"
#import "BrandManager.h"
#import "JSON.h"

@interface CarManagerViewController ()

@end

@implementation carManagerCell

@synthesize editBtn;
@synthesize deleteBtn;
@synthesize mainLabel;

@end

@implementation CarManagerViewController
@synthesize myTableView;

-(NSString *) naviTitle{
    return @"车辆管理";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) naviRightIcon{
    return @"addCar.png";
}

-(void) naviRightClick:(id)sender{
    [MobClick event:@"car_manage_add"];
    AddCarViewController *addCar = [[AddCarViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
    [self presentViewController:navi animated:YES completion:nil];
    
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
	// Do any additional setup after loading the view.
    CGRect frame = self.view.bounds;
    frame.origin.y = KDefaultStartY;
    frame.size.height -= KHeightReduce;
    self.myTableView = [[FMMoveTableView alloc] initWithFrame:frame style: UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundView = [[UIView alloc] init];
    myTableView.backgroundView.backgroundColor = [TRSkinManager bgColorLight];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:KNotification_CarChanged object:nil];
    [MobClick event:@"car_manage_arrive"];
}

-(void) updateNoDataViews{
    if ([CarInfo globCarInfo].count > 0) {
        myTableView.tableFooterView = nil;
    } else {
        
        UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.width, myTableView.height)];
        bgview.backgroundColor = [UIColor clearColor];
        self.myTableView.tableFooterView = bgview;
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *image = TRImage(@"dashedBox.png");
//        btn.frame = CGRectMake(myTableView.width/2 - image.size.width/2, 12, image.size.width, image.size.height);
//        [btn setBackgroundImage:TRImage(@"dashedBox.png") forState:UIControlStateNormal];
//        [btn setBackgroundImage:TRImage(@"dashedBoxHL.png") forState:UIControlStateHighlighted];
//        [btn setTitle:@"点击添加车辆" forState:UIControlStateNormal];
//        [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
//        [bgview addSubview:btn];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = TRImage(@"dashedBox.png");
        btn.frame = CGRectMake(myTableView.width/2 - image.size.width/2, myTableView.height/2 - image.size.height/2 - 40, image.size.width, image.size.height);
        [btn setBackgroundImage:TRImage(@"dashedBox.png") forState:UIControlStateNormal];
        [btn setBackgroundImage:TRImage(@"dashedBoxHL.png") forState:UIControlStateHighlighted];
        [btn setTitleColor:[TRSkinManager colorWithInt:0x999999] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btn];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.bottom + 4, myTableView.width, 24)];
        label.font = [TRSkinManager smallFont1];
        label.text = @"点击添加车辆";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x999999];
        label.textAlignment = NSTextAlignmentCenter;
        [bgview addSubview:label];

    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateNoDataViews];
}

-(void) addCarBtnClick:(UIButton *) btn{
    AddCarViewController *addCar = [[AddCarViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void) notifyMessage:(NSNotification*) notifyMsg{
    if ([notifyMsg.name isEqualToString:KNotification_CarChanged]) {
        [myTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = [CarInfo globCarInfo].count;
    if (tableView.movingIndexPath && tableView.movingIndexPath.section != tableView.initialIndexPathForMovingRow.section)
	{
		if (section == tableView.movingIndexPath.section) {
			count++;
		}
		else if (section == tableView.initialIndexPathForMovingRow.section) {
			count--;
		}
	}
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    carManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[carManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [TRSkinManager bgColorWhite];
        UIButton *btn = [self createBtn:@"edit2.png" hl:@"edit2HL.png"];
        [btn setTop:height/2 - btn.height/2];
        [btn setLeft:tableView.width - btn.width*2];
        [btn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        cell.editBtn = btn;
        
        btn = [self createBtn:@"delete.png" hl:@"deleteHL.png"];
        [btn setTop:height/2 - btn.height/2];
        [btn setLeft:tableView.width - btn.width];
        [cell addSubview:btn];
        [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        float lineH = [TRUtility lineHeight];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - lineH, cell.width, lineH)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
        [cell addSubview:line];
        cell.deleteBtn = btn;
        
        cell.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 190, height)];
        cell.mainLabel.backgroundColor = [UIColor clearColor];
        cell.mainLabel.font = [TRSkinManager mediumFont2];
        cell.mainLabel.textColor = [UIColor blackColor];
        [cell addSubview:cell.mainLabel];
    }
    
    if ([tableView indexPathIsMovingIndexPath:indexPath])
    {
        [cell prepareForMove];
    } else {
        [cell recoverFromMove];
        cell.editBtn.tag = indexPath.row + 100;
        cell.deleteBtn.tag = indexPath.row + 101;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CarInfo * car = [[CarInfo globCarInfo] objectAtIndex:indexPath.row];
        NSString *text = car.carname.length > 0 ? car.carname : car.carnumber;
        cell.mainLabel.text = text;
    }
    return cell;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *cars = [CarInfo globCarInfo];
    NSInteger fromIndex = fromIndexPath.row ;
    NSInteger toIndex = toIndexPath.row ;
    NSLog(@"fromIndex = %d,toIndex =%d",fromIndex,toIndex);
    CarInfo *obj = [cars objectAtIndex:fromIndex];
    [cars removeObjectAtIndex:fromIndex];
    if (toIndex >= cars.count) {
        [cars addObject:obj];
    } else {
        [cars insertObject:obj atIndex:toIndex];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int sortIndex = 0;
        for (CarInfo *car in [CarInfo globCarInfo]) {
            car.sortIndex = sortIndex;
            sortIndex++;
            [CarInfo updateCarSortIndex:car];
        }
    });
}

- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	return proposedDestinationIndexPath;
}

-(void) editClick:(UIButton *) btn{
    [MobClick event:@"car_manage_edit"];
    NSInteger index = btn.tag - 100;
    CarInfo * car = [[CarInfo globCarInfo] objectAtIndex:index];
    if (car) {
        AddCarViewController * addCar = [[AddCarViewController alloc] init];
        addCar.carData = car;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addCar];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

-(void) deleteClick:(UIButton *) btn{
    [MobClick event:@"car_manage_del"];
    NSInteger index = btn.tag - 101;
    CarInfo * car = [[CarInfo globCarInfo] objectAtIndex:index];
    if (car) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您确定要删除%@",car.carnumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil, nil];
        [alert show];
        alert.tag = btn.tag;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        NSInteger index = alertView.tag - 101;
        CarInfo * car = nil;
        if (index < [CarInfo globCarInfo].count) {
            car = [[CarInfo globCarInfo] objectAtIndex:index];
        } else {
            [self showInfoView:@"删除失败，车辆不存在"];
            return;
        }
        deleteIndex = index;
        NSMutableDictionary *carInfo = [NSMutableDictionary dictionary];
        [carInfo setObject:[NSNumber numberWithInt:car.carid.intValue] forKey:@"carid"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [carInfo setObject:[defaults objectForKey:KGUIDKey] forKey:@"guid"];
        [carInfo setObject:[OpenUDID value] forKey:@"deviceid"];
        NSString *userId = [NSString stringWithFormat:@"%d", [TRAppDelegate appDelegate].userId];//;
        if (userId.length > 0) {
            [carInfo setObject:userId forKey:@"userid"];
        } else {
            [carInfo setObject:@"" forKey:@"userid"];
        }
        if (service == nil) {
            service = [[DeleteCarService alloc] init];
            service.delegate = self;
        }
        [service deleteCarWithJson:carInfo];
        [self showLoadingAnimated:NO];
    }
}

#pragma mark -
#pragma mark AHServiceDelegate Methods
- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (tag == EServiceDeleteCar && deleteIndex < [CarInfo globCarInfo].count) {
        CarInfo * car = [[CarInfo globCarInfo] objectAtIndex:deleteIndex];
        [[CarInfo globCarInfo] removeObjectAtIndex:deleteIndex];
        [CarInfo deleteCar:car.carid];
        [self showInfoView:@"删除成功！"];
        [self hideLoadingViewAnimated:YES];
        [self updateNoDataViews];
        [myTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
    }
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    if (tag == EServiceDeleteCar) {
        [self hideLoadingViewAnimated:YES];
        if (errorCode == -14 && deleteIndex < [CarInfo globCarInfo].count) {
            CarInfo * car = [[CarInfo globCarInfo] objectAtIndex:deleteIndex];
            [[CarInfo globCarInfo] removeObjectAtIndex:deleteIndex];
            [CarInfo deleteCar:car.carid];
            [self showInfoView:@"删除成功！"];
            [myTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CarChanged object:nil];
        } else {
            if (errorMessage.length > 0) {
                [self showInfoView:errorMessage];
            } else {
                [self showInfoView:UNKNOWN_ERROR];
            }
        }
    }
}


-(UIButton *) createBtn:(NSString *) icon hl:(NSString *) hlIcon{
    UIImage *image = TRImage(icon);
    if (image == nil) {
        return nil;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:TRImage(hlIcon) forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    return btn;
}

@end
