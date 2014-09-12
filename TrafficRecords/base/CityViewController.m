//
//  CityViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-3.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "CityViewController.h"
#import "TableViewEx.h"
#import "AHMultiViewCell.h"
#import "AreaDBManager.h"
#import "Area.h"
#import "UITableView+SectionTitles.h"

#define KLocationText @"定位"

@interface CityViewController ()

@end

@implementation CityViewController

@synthesize selContainerView;
@synthesize holdLabel;
@synthesize controllerType;
@synthesize areaDelegate;

-(NSString *) naviTitle{
    return @"选择城市";
}

-(NSString *) naviLeftIcon{
    return @"back.png";
}

-(void) naviLeftClick:(id)sender{
    if (areaDelegate && [areaDelegate respondsToSelector:@selector(selectedCitys:)]) {
        [areaDelegate selectedCitys:selectCitys];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) naviRightIcon{
    if (controllerType == 2) {
        return @"item_ok.png";
    } else {
        return nil;
    }
}

-(void) naviRightClick:(id)sender{
    if (areaDelegate && [areaDelegate respondsToSelector:@selector(selectedCitys:)]) {
        [areaDelegate selectedCitys:selectCitys];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(id) init{
    self = [super init];
    if (self) {
        controllerType = 1;
        selectCitys = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

-(void) dealloc{
    [locationMgr stopUpdatingLocation];
    locationMgr = nil;
}

- (void)initProvinceData
{
    firstLetterArray = [[NSMutableArray alloc] initWithCapacity:26];
    provinceDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    cityArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    //定位
    if (controllerType == 1) {
        NSArray * provinces = [AreaDBManager getAllProvinces];
        for (Province * pro in provinces) {
            NSMutableArray * temp = [provinceDic objectForKey:pro.firstLetter];
            if (temp == nil) {
                [firstLetterArray addObject:pro.firstLetter];
                temp = [NSMutableArray array];
                [provinceDic setObject:temp forKey:pro.firstLetter];
            }
            [temp addObject:pro];
        }
        //字母数组排序
        NSArray * array = [firstLetterArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
            NSString *str1 = a;
            NSString *str2 = b;
            NSComparisonResult res = [str1 compare:str2];
            return res;
        }];
        [firstLetterArray removeAllObjects];
        [firstLetterArray addObjectsFromArray:array];
    } else {
        provinceDic = [SupportCityManager sharedManager].provinceDic;
        NSArray * array = [[SupportCityManager sharedManager].firstLetterArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
            NSString *str1 = a;
            NSString *str2 = b;
            NSComparisonResult res = [str1 compare:str2];
            return res;
        }];
        [firstLetterArray removeAllObjects];
        [firstLetterArray addObjectsFromArray:array];
    }
}

- (void)startLocaltion
{
    [firstLetterArray insertObject:KLocationText atIndex:0];
    City * pro = [[City alloc] init];
    pro.name = @"正在定位...";
    pro.cityId = 0;
    [provinceDic setObject:[NSMutableArray arrayWithObject:pro] forKey:KLocationText];
    
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    [locationMgr startUpdatingLocation];

}

-(void) setSelectCitys:(NSArray *) citys{
    if(selectCitys == nil){
        selectCitys = [NSMutableArray array];
    }
    [selectCitys addObjectsFromArray:citys];
    if (controllerType == 2) {
        for (City * city in selectCitys) {
            if (city.parentId == 450000) {//@"桂", @"450000"
                selectCityType = 1;
            } else if (city.parentId == 120000)//@"津", @"120000",
            {
                selectCityType = 2;
            }
        }
    }
}

#pragma mark -
#pragma mark CLLocationManager代理
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [locationMgr stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    if (geoCoder == nil)
    {
        geoCoder = [[CLGeocoder alloc] init];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
          if (array.count > 0) {
              CLPlacemark *placemark = [array objectAtIndex:0];
              NSDictionary *dic = placemark.addressDictionary;
              NSString *city = [dic objectForKey:@"City"];
              if (city.length == 0) {
                  city = placemark.administrativeArea;
              }
              city = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
              city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
              City * cityM = [AreaDBManager getCityByKeyWord:city];
              if (cityM) {
                  NSMutableArray *array = [provinceDic objectForKey:KLocationText];
                  [array replaceObjectAtIndex:0 withObject:cityM];
                  if (thirdView.tableArray > 0) {
                      AHMultiSelectView* table = [thirdView.tableArray objectAtIndex:0];
                      [table.selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                  }
              } else {
                  [self handleLocationFailed];
              }
          } else {
              [self handleLocationFailed];
          }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self handleLocationFailed];
}

- (void)handleLocationFailed{
    NSMutableArray *array = [provinceDic objectForKey:KLocationText];
    City *city = [array objectAtIndex:0];
    city.name = @"定位失败";
    if (thirdView.tableArray > 0) {
        AHMultiSelectView* table = [thirdView.tableArray objectAtIndex:0];
        [table.selectTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProvinceData];
//    if (controllerType == 1) {
//        [self startLocaltion];
//    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, KDefaultStartY, self.view.width, 35)];
    label.backgroundColor = [TRSkinManager labelColorGray];
    label.textColor = [TRSkinManager colorWithInt:0x666666];
    label.text = @"  已选城市";
    label.font = [TRSkinManager smallFont1];
    [self.view addSubview:label];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [label addSubview:line];
    line = [[UIView alloc] initWithFrame:CGRectMake(0, label.height - 0.5, label.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [label addSubview:line];
    
    self.selContainerView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, label.bottom, self.view.width, 66)];
    [self.view addSubview:selContainerView];
    self.holdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, selContainerView.width, 36)];
    holdLabel.backgroundColor = [UIColor clearColor];
    holdLabel.textColor = [TRSkinManager textColorLightDark];
    if (controllerType == 1) {
        holdLabel.text = @"   请选择您所在的城市";
    } else {
        holdLabel.text = @"   您可以选择一个或者多个城市";
    }
    holdLabel.font = [TRSkinManager smallFont1];
    [selContainerView addSubview:holdLabel];
    line = [[UIView alloc] initWithFrame:CGRectMake(0, selContainerView.bottom+1, selContainerView.width, 0.5)];
    line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
    [self.view addSubview:line];
    
    selContainerView.contentSize = CGSizeMake(0, selContainerView.height);
    CGRect rect = CGRectMake(0, line.bottom, self.view.width, 2);
    rect.size.height = self.view.height  - line.height - label.height - selContainerView.height - KHeightReduce;
    AHThirdSelectView* moreSelectView = [[AHThirdSelectView alloc] initWith:MultiSelect tabStyle:UITableViewStylePlain frame:rect nums:2 TableWidth:100 tableInsetBottom:0];
    moreSelectView.hidden = NO;
    moreSelectView.delegate = self;
    moreSelectView.dataSource = self;
    [self.view addSubview:moreSelectView];
    thirdView = moreSelectView;
    
    [self.view removeGestureRecognizer:recognizer];
//    [[[moreSelectView tableArray] objectAtIndex:0] addGestureRecognizer:recognizer];
    
    for (City *city in selectCitys) {
        holdLabel.hidden = YES;
        CGSize size = selContainerView.contentSize;
        UIView * newCity = [self createCityBtn:city];
        selContainerView.contentSize = CGSizeMake(size.width + newCity.width, size.height);
        [newCity setTop:size.height/2 - newCity.height/2];
        [newCity setLeft:size.width];
        [selContainerView addSubview:newCity];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark AHThirdSelectView Delegate Methods

- (NSInteger)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table NumberOfRowsInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        if (section < firstLetterArray.count) {
            NSString *key = [firstLetterArray objectAtIndex:section];
            NSArray * array = [provinceDic objectForKey:key];
            return array.count;
        }
    } else if (index == 1){
        return cityArray.count;
    }

    return 0;
}

- (NSInteger)thirdSelectView:(AHThirdSelectView *)thirdSelectView  numOfSectionsInTableView:(AHMultiSelectView *) table{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        return provinceDic.count;
    } else {
        return 1;
    }
}

- (AHMultiViewCell *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table CellForRowAtIndexPath:(NSIndexPath *)indexPath{
    table.selectTableView.backgroundColor = [TRSkinManager bgColorLight];
    NSString *CellIdentifier = @"ColumnCell";
    AHMultiViewCell *cell = [table.selectTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (cell == nil) {
        float height = [self thirdSelectView:thirdSelectView tableView:table HeightForRowAtIndexPath:indexPath];
        cell = [[AHMultiViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellFrame:CGRectMake(0, 0, table.width, height)];
        if (index == 0 && selectCellBg1 == nil) {
            CGRect rect2 = CGRectMake(0.0f, 0.0f, table.width, height);
            UIGraphicsBeginImageContextWithOptions(rect2.size, NO, 2.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[TRSkinManager colorWithInt:0xdb325a] CGColor]);
            rect2.size.width = 2;
            CGContextFillRect(context, rect2);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            selectCellBg1 = [[UIImageView alloc] initWithImage:image];
            UIGraphicsEndImageContext();
        } else  if (index == 1 && selectCellBg2 == nil) {
            CGRect rect2 = CGRectMake(0.0f, 0.0f, table.width, height);
            UIGraphicsBeginImageContextWithOptions(rect2.size, NO, 2.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, [[TRSkinManager colorWithInt:0xdb325a] CGColor]);
            rect2.size.width = 2;
            CGContextFillRect(context, rect2);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            selectCellBg2 = [[UIImageView alloc] initWithImage:image];
            UIGraphicsEndImageContext();
        }
        cell.backgroundView = nil;
        cell.backgroundColor = [TRSkinManager bgColorLight];
        
        UILabel *notSupport = [[UILabel alloc] initWithFrame:cell.bounds];
        notSupport.backgroundColor = [UIColor clearColor];
        notSupport.textAlignment = NSTextAlignmentLeft;
        notSupport.font = [TRSkinManager smallFont1];
        notSupport.textColor = [TRSkinManager colorWithInt:0xcccccc];
        notSupport.tag = 211;
        notSupport.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [cell addSubview:notSupport];
        
        float lineH = [TRUtility lineHeight];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(15, height- lineH, table.width, lineH)];
        line.image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcccccc]];
        [cell addSubview:line];
        line.tag = 1024;
    }
    
    if (index == 0) {
        cell.selectedBackgroundView = selectCellBg1;
    } else {
        cell.selectedBackgroundView = selectCellBg2;
    }
    
    float rowsCount = [self thirdSelectView:thirdSelectView tableView:table NumberOfRowsInSection:indexPath.section];
    UIView *line = [cell viewWithTag:1024];
    if (indexPath.row == rowsCount - 1 && index == 0) {
        line.hidden = YES;
    } else {
        line.hidden = NO;
    }
//    [cell.textLabel setLeft:10];
    if (index == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [TRSkinManager colorWithInt:0x333333];
        cell.textLabel.highlightedTextColor = [TRSkinManager colorWithInt:0xdb325a];
        if (indexPath.section < firstLetterArray.count) {
            NSString *key = [firstLetterArray objectAtIndex:indexPath.section];
            NSArray * array = [provinceDic objectForKey:key];
            if ([key isEqualToString:KLocationText]) {
                City *city = [array objectAtIndex:indexPath.row];
                BOOL contains = NO;
                for (int i = 0; i < selectCitys.count; i++) {
                    City *temp = [selectCitys objectAtIndex:i];
                    if (temp.cityId == city.cityId) {
                        contains = YES;
                        break;
                    }
                }
                cell.textLabel.text = city.name;
                cell.isSelected = contains;
            } else {
                if (indexPath.row < array.count) {
                    Province *pro = [array objectAtIndex:indexPath.row];
                    cell.textLabel.text = pro.name;
                    cell.isSelected = NO;
                }
            }
        }
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [TRSkinManager colorWithInt:0x333333];
        cell.textLabel.highlightedTextColor = [TRSkinManager colorWithInt:0xdb325a];
        if (indexPath.row < cityArray.count) {
            City *city = [cityArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text = city.name;
            float width = [city.name sizeWithFont:cell.textLabel.font].width;
            UILabel *notSupport = (UILabel*)[cell viewWithTag:211];
            width += cell.textLabel.left + 2;
            if (cell.textLabel.left == 0) {
                width += 10;
            }
            [notSupport setLeft:width];
            if (controllerType == 2) {
                if ( city.notSupport) {
                    notSupport.text = @"(暂未开通)";
                    cell.textLabel.textColor = [TRSkinManager colorWithInt:0xcccccc];
                } else {
//                    if (city.parentId == 450000) {//@"桂", @"450000"
//                    } else if (city.parentId == 120000)//@"津", @"120000",
                    if (selectCityType == 1) {
                        if (city.parentId == 450000) {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [UIColor blackColor];
                        } else {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [TRSkinManager colorWithInt:0xcccccc];
                        }
                    } else if(selectCityType == 2){
                        if (city.parentId == 120000) {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [UIColor blackColor];
                        } else {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [TRSkinManager colorWithInt:0xcccccc];
                        }
                    } else {
                        if (selectCitys.count > 0 && (city.parentId == 120000 || city.parentId == 450000)) {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [TRSkinManager colorWithInt:0xcccccc];
                        } else {
                            notSupport.text = @"";
                            cell.textLabel.textColor = [UIColor blackColor];
                        }
                    }
                    //end
                }
            }
            else {
                notSupport.text = @"";
                cell.textLabel.textColor = [UIColor blackColor];
            }
            
            BOOL contains = NO;
            for (int i = 0; i < selectCitys.count; i++) {
                City *temp = [selectCitys objectAtIndex:i];
                if (temp.cityId == city.cityId) {
                    contains = YES;
                    break;
                }
            }
            cell.isSelected = contains;
        }
    }
    return cell;
}

- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView  tableView:(AHMultiSelectView *) table HeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSString *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table TitleForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (section < firstLetterArray.count && index == 0) {
        return [firstLetterArray objectAtIndex:section];
    }
    return nil;
}

- (NSArray *)thirdSelectView:(AHThirdSelectView *)thirdSelectView SectionIndexTitlesForTableView:(AHMultiSelectView *) table{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        [table.selectTableView addCustomSectionTitles:firstLetterArray];
        return nil;
    }
    return nil;
}

- (UIView *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ViewForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [TRSkinManager colorWithInt:0xd6d6d6];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 25)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x333333];
        label.font = [TRSkinManager smallFont1];
        label.text = [self thirdSelectView:thirdSelectView tableView:table TitleForHeaderInSection:section];
        [bg addSubview:label];
        
//        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 24, bg.width, 1)];
//        line.backgroundColor = [TRSkinManager colorWithInt:0xcccccc];
//        [bg addSubview:line];
//        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return bg;
    }
    return nil;
}

- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table HeightForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        return 25.0;
    }
    return 0.0;
}

- (BOOL)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ShouldSelect:(NSIndexPath *)indexPath{
     NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0 && indexPath.section < firstLetterArray.count) {
        NSString *key = [firstLetterArray objectAtIndex:indexPath.section];
        NSArray * array = [provinceDic objectForKey:key];
        if ([key isEqualToString:KLocationText]) {
            City *city = [array objectAtIndex:0];
            if (city.cityId == 0) {
                return NO;
            }
        }
    }
    return YES;
}

-(void) thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *)table DidSelect:(NSIndexPath *)indexPath{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0 && indexPath.section < firstLetterArray.count) {
        NSString *key = [firstLetterArray objectAtIndex:indexPath.section];
        NSArray * array = [provinceDic objectForKey:key];
        if ([key isEqualToString:KLocationText]) {
            City *city = [array objectAtIndex:0];
            if (city.cityId != 0) {
                City *beFound = nil;
                for (int i = 0; i < selectCitys.count; i++) {
                    City *temp = [selectCitys objectAtIndex:i];
                    if (temp.cityId == city.cityId) {
                        beFound = temp;
                        break;
                    }
                }
                if (beFound != nil) {
                    [self deleteCityByTag:(int)city.cityId];
                } else {
                    [self appendCityInScrollView:city];
                    [self naviLeftClick:nil];
                }
                [thirdView performSelector:@selector(asyreloadTableView:) withObject:[NSNumber numberWithInt:0] afterDelay:0.0f];
//                [thirdView asyreloadTableView:[NSNumber numberWithInt:0]];
            }
            return;
        }
        if (indexPath.row < array.count) {
            Province *pro = [array objectAtIndex:indexPath.row];
            NSArray * citys = nil;
            if (controllerType == 2) {
                citys = [[SupportCityManager sharedManager] getCitysByPro:[NSString stringWithFormat:@"%ld", (long)pro.provinceId]];
            } else if(controllerType == 1){
                citys = [AreaDBManager getCitysInProvince:pro.provinceId];
            }
            [cityArray removeAllObjects];
            [cityArray addObjectsFromArray:citys];
            [thirdSelectView reloadTableView:1];
        }
    } else if(index == 1){
        if (indexPath.row < cityArray.count) {
            City *city = [cityArray objectAtIndex:indexPath.row];
            //                    if (city.parentId == 450000) {//@"桂", @"450000"
            //                    } else if (city.parentId == 120000)//@"津", @"120000",
            if (controllerType == 2) {
                if (selectCityType == 1) {
                    if (city.parentId != 450000) {
                        NSString *text = [NSString stringWithFormat:@"抱歉，目前广西不支持和广西之外的城市同时查询"];
                        [self showInfoView:text];
                        return;
                    }
                } else if(selectCityType == 2){
                    if (city.parentId != 120000) {
                        NSString *text = [NSString stringWithFormat:@"抱歉，目前天津不支持和天津之外的城市同时查询"];
                        [self showInfoView:text];
                        return;
                    }
                } else {
                    if (selectCitys.count > 0) {
                        if (city.parentId == 450000) {
                            NSString *text = [NSString stringWithFormat:@"抱歉，目前%@不支持和广西之外的城市同时查询", city.name];
                            [self showInfoView:text];
                            return;
                        }
                        if (city.parentId == 120000) {
                            NSString *text = [NSString stringWithFormat:@"抱歉，目前%@不支持和天津之外的城市同时查询", city.name];
                            [self showInfoView:text];
                            return;
                        }
                    }
                }
            }
            //end
            
            if (city.notSupport) {
                [MobClick event:@"unsupport_city" label:city.name];
                UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"抱歉，我们对接完会立刻发布在列表中，无需重新下载软件也能享受查询服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [info show];
                return;
            }
            City *beFound = nil;
            for (int i = 0; i < selectCitys.count; i++) {
                City *temp = [selectCitys objectAtIndex:i];
                if (temp.cityId == city.cityId) {
                    beFound = temp;
                    break;
                }
            }
            if (beFound != nil) {
                [self deleteCityByTag:(int)city.cityId];
            } else {
                [self appendCityInScrollView:city];
                [self naviLeftClick:nil];
            }
        }
    }
}

-(void) appendCityInScrollView:(City *) city{
    if (controllerType == 1) {
        for (City * city in selectCitys) {
            [self deleteCityByTag:(int)city.cityId];
        }
    }
    holdLabel.hidden = YES;
    [selectCitys addObject:city];
    if (controllerType == 2) {
        for (City * city in selectCitys) {
            if (city.parentId == 450000) {//@"桂", @"450000"
                selectCityType = 1;
            } else if (city.parentId == 120000)//@"津", @"120000",
            {
                selectCityType = 2;
            }
        }
    }
    
    CGSize size = selContainerView.contentSize;
    UIView * newCity = [self createCityBtn:city];
     selContainerView.contentSize = CGSizeMake(size.width + newCity.width, size.height);
    [newCity setTop:size.height/2 - newCity.height/2];
    [newCity setLeft:size.width];
    [UIView beginAnimations:@"addItem" context:nil];
    [selContainerView scrollRectToVisible:newCity.frame animated:YES];
    [selContainerView addSubview:newCity];
    [thirdView reloadTableView:1];
    [UIView commitAnimations];
}

-(UIView *) createCityBtn:(City *) city{
    UIFont *font = [TRSkinManager mediumFont3];
    CGSize size = [city.name sizeWithFont:font];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + 52, 66)];
    contentView.backgroundColor = [UIColor clearColor];
    UIImage *delete = [TRImageManager imageNamed:@"CheckUnSel.png"];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    float height = 32;
    btn.frame = CGRectMake(delete.size.width/2 + 6, contentView.height/2 - height/2, size.width + 30, height);
    [btn setTitle:city.name forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIImage *bg = [TRImage(@"cityFrame.png") stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [btn setBackgroundImage:bg forState:UIControlStateNormal];
//    btn.layer.cornerRadius = 4;
//    btn.layer.borderColor = [TRSkinManager colorWithInt:0xcccccc].CGColor;
//    btn.layer.borderWidth = 1;
    btn.tag =  city.cityId + 1;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[TRSkinManager textColorDark] forState:UIControlStateNormal];
    [contentView addSubview:btn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(btn.right - delete.size.width/2, btn.top - delete.size.height/2, delete.size.width, delete.size.height);
    [deleteBtn setBackgroundImage:delete forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteCity:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = city.cityId;
    [contentView addSubview:deleteBtn];
    contentView.tag = city.cityId;
    return contentView;
}

-(void) btnClick:(UIButton *) btn{
    NSInteger tag = btn.tag - 1;
    [self deleteCityByTag:(int)tag];
}

-(void) deleteCity:(UIButton *)sender{
    NSInteger tag = sender.tag;
    [self deleteCityByTag:(int)tag];
}

-(void) deleteCityByTag:(int )tag {
    for (int i = 0; i < selectCitys.count; i++) {
        City *temp = [selectCitys objectAtIndex:i];
        if (temp.cityId == tag ) {
            [selectCitys removeObject:temp];
            if (i == 0) {
                [MobClick event:@"add_choosecity_del_frist"];
            }
            break;
        }
    }
    BOOL found = NO;
    if (controllerType == 2) {
        for (City * city in selectCitys) {
            if (city.parentId == 450000) {//@"桂", @"450000"
                selectCityType = 1;
                found = YES;
            } else if (city.parentId == 120000)//@"津", @"120000",
            {
                selectCityType = 2;
                found = YES;
            }
        }
    }
    if (!found) {
        selectCityType = 0;
    }
    NSArray *subView = [selContainerView subviews];
    [UIView beginAnimations:@"deleteItem" context:nil];
    BOOL move = NO;
    float width = 0;
    CGRect aframe;
    for (UIView * view in subView) {
//        NSLog(@"%@", view);
        if (move) {
            [view setLeft:view.left - width];
        }
        if (view.tag == tag) {
            [selContainerView scrollRectToVisible:view.frame animated:YES];
            aframe = view.frame;
            width = view.width;
            [view removeFromSuperview];
            move = YES;
        }
    }
   
    selContainerView.contentSize = CGSizeMake(selContainerView.contentSize.width - width, selContainerView.contentSize.height);
    [selContainerView scrollRectToVisible:aframe animated:YES];
    [thirdView reloadTableView:1];
    if (selectCitys.count == 0) {
        holdLabel.hidden = NO;
    }
    [UIView commitAnimations];
}

@end
