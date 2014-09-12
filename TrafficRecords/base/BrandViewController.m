//
//  BrandViewController.m
//  TrafficRecords
//
//  Created by qiao on 13-9-18.
//  Copyright (c) 2013年 AutoHome. All rights reserved.
//

#import "BrandViewController.h"
#import "TableViewEx.h"
#import "AHMultiViewCell.h"
#import "UrlImageView.h"
#import "UITableView+SectionTitles.h"

@interface BrandViewController ()

@end

@implementation BrandViewController

@synthesize brandDelegate;
@synthesize selectBrand;
@synthesize selectSeries;
@synthesize selectSpec;

-(NSString *) naviTitle{
    return @"选择车系";
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

- (void)initBrandData
{
    brandTitles = [NSMutableArray array];
    specTitles = [NSMutableArray array];
    seriesData = [NSMutableArray array];
    brandData = [NSMutableDictionary dictionary];
    specData = [NSMutableDictionary dictionary];
	// Do any additional setup after loading the view.
    NSArray *array = [BrandManager getAllBrands];
    for (Brand *brand in array) {
        NSMutableArray *tempArray = [brandData objectForKey:brand.firstLetter];
        if (tempArray == nil) {
            tempArray = [NSMutableArray array];
            [brandData setObject:tempArray forKey:brand.firstLetter];
            [brandTitles addObject:brand.firstLetter];
        }
        [tempArray addObject:brand];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBrandData];
    
    AHThirdSelectView* moreSelectView = [[AHThirdSelectView alloc] initWith:MultiSelect tabStyle:UITableViewStylePlain frame:CGRectMake(0, KDefaultStartY, self.view.width, self.view.height - KHeightReduce) nums:2 TableWidth: 100 tableInsetBottom:0];
    moreSelectView.hidden = NO;
    moreSelectView.delegate = self;
    moreSelectView.dataSource = self;
    [self.view addSubview:moreSelectView];
    thirdView = moreSelectView;
    
    if (selectBrand && selectSeries && selectSpec) {
        NSIndexPath *indexpath = nil;
        for (int i = 0; i < brandTitles.count; i++) {
            if ([selectBrand.firstLetter isEqualToString:[brandTitles objectAtIndex:i]]) {
                NSArray *brands = [brandData objectForKey:selectBrand.firstLetter];
                for (int j = 0; j < brands.count; j++) {
                    Brand *temp = [brands objectAtIndex:j];
                    if (temp.brandId == selectBrand.brandId) {
                        indexpath = [NSIndexPath indexPathForRow:j inSection:i];
                        break;
                    }
                }
            }
        }
        if (indexpath == nil) {
            return;
        }
        AHMultiSelectView *tableView = [thirdView.tableArray objectAtIndex:0];
        [tableView setSelectedOfIndexPath:indexpath isSendHandle:YES];
        indexpath = nil;
        for (int i = 0; i < seriesData.count; i++) {
            Series *temp = [seriesData objectAtIndex:i];
            if (temp.seriesId == self.selectSeries.seriesId) {
                indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
        tableView = [thirdView.tableArray objectAtIndex:1];
        [tableView setSelectedOfIndexPath:indexpath isSendHandle:YES];
    }
    [self.view removeGestureRecognizer:recognizer];
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
        NSString *key = [brandTitles objectAtIndex:section];
        NSArray *brandArray = [brandData objectForKey:key];
        return brandArray.count;
    } else if (index == 1){
        return seriesData.count;
    } else if (index == 2){
        NSString *key = [specTitles objectAtIndex:section];
        NSArray *specArray = [specData objectForKey:key];
        return specArray.count;
    }
    
    return 0;
}

- (NSInteger)thirdSelectView:(AHThirdSelectView *)thirdSelectView  numOfSectionsInTableView:(AHMultiSelectView *) table{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        return brandTitles.count;
    } else if(index == 1){
        return 1;
    } else if(index == 2){
        return specTitles.count;
    }
    return 0;
}

- (AHMultiViewCell *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table CellForRowAtIndexPath:(NSIndexPath *)indexPath{
    table.selectTableView.backgroundColor = [TRSkinManager bgColorLight];
    NSString *CellIdentifier = @"ColumnCell";
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    AHMultiViewCell *cell = [table.selectTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        float height = [self thirdSelectView:thirdSelectView tableView:table HeightForRowAtIndexPath:indexPath];
        cell = [[AHMultiViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier cellFrame:CGRectMake(0, 0, 320, height)];
        if (index == 0) {
            UrlImageView *imageView = [[UrlImageView alloc] initWithFrame:CGRectMake(15, height/2 - 20, 40, 40)];
            [cell addSubview:imageView];
            imageView.tag = 100;
            
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 14, 0, 120, height)];
            [title setBackgroundColor:[UIColor clearColor]];
            [title setTextColor:[TRSkinManager colorWithInt:0x333333]];
            title.font = [TRSkinManager mediumFont3];
            title.highlightedTextColor = [TRSkinManager colorWithInt:0xdb325a];
            title.tag = 102;
            [cell addSubview:title];
        }
        float lineH = [TRUtility lineHeight];
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(15, height- lineH, table.width, lineH)];
        line.image = [TRUtility imageWithColor:[TRSkinManager colorWithInt:0xcccccc]];
        [cell addSubview:line];
        cell.textLabel.highlightedTextColor = [TRSkinManager colorWithInt:0xdb325a];
//        cell.selectedBackgroundView.backgroundColor = [TRSkinManager colorWithInt:0xd1effe];
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
    }
    if (index == 0) {
        cell.selectedBackgroundView = selectCellBg1;
    } else {
        cell.selectedBackgroundView = selectCellBg2;
    }
    if (index == 0) {
        NSString *key = [brandTitles objectAtIndex:indexPath.section];
        Brand *brand = [[brandData objectForKey:key] objectAtIndex:indexPath.row];
        NSString *url = brand.brandImg;
        UrlImageView *imageView = (UrlImageView*)[cell viewWithTag:100];
        [imageView setImageFromUrl:YES withUrl:url];
        UILabel *title = (UILabel*)[cell viewWithTag:102];
        title.text = brand.name;
    } else if(index == 1){
        Series *series = [seriesData objectAtIndex:indexPath.row];
        cell.textLabel.font = [TRSkinManager mediumFont3];
        cell.textLabel.textColor = [TRSkinManager colorWithInt:0x333333];
        cell.textLabel.text = series.name;
    } else if(index == 2){
        NSString *key = [specTitles objectAtIndex:indexPath.section];
        CarType  *spec = [[specData objectForKey:key] objectAtIndex:indexPath.row];
        cell.textLabel.font = [TRSkinManager mediumFont3];
        cell.textLabel.textColor = [TRSkinManager colorWithInt:0x333333];
        cell.textLabel.text = spec.name;
        cell.textLabel.numberOfLines = 0;
    }
    return cell;
}

- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView  tableView:(AHMultiSelectView *) table HeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        return 65;
    } else if(index == 2){
        UIFont *font = [TRSkinManager mediumFont2];
        NSString *key = [specTitles objectAtIndex:indexPath.section];
        CarType *spec = [[specData objectForKey:key] objectAtIndex:indexPath.row];
        CGSize newSize = [spec.name sizeWithFont:font constrainedToSize:CGSizeMake(10000, 22)];
        float height = 44;
        int lines = newSize.width/146;
        height += lines * font.lineHeight;
        return height;
    }
    return 45;
}

- (NSString *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table TitleForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        return [brandTitles objectAtIndex:section];
    } else if(index == 2){
        return [specTitles objectAtIndex:section];
    }
    return nil;
}

- (NSArray *)thirdSelectView:(AHThirdSelectView *)thirdSelectView SectionIndexTitlesForTableView:(AHMultiSelectView *) table{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        [table.selectTableView addCustomSectionTitles:brandTitles];
        return nil;
    }
    return nil;
}

- (UIView *)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ViewForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0 || index == 2) {
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [TRSkinManager colorWithInt:0xd6d6d6];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 25)];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [TRSkinManager colorWithInt:0x333333];
//        label.font = [TRSkinManager smallFont1];
//        label.text = [self thirdSelectView:thirdSelectView tableView:table TitleForHeaderInSection:section];
//        [bg addSubview:label];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [TRSkinManager colorWithInt:0x333333];
        label.font = [TRSkinManager smallFont1];
        label.text = [self thirdSelectView:thirdSelectView tableView:table TitleForHeaderInSection:section];
        [bg addSubview:label];
        return bg;
    }
    return nil;
}

- (CGFloat)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table HeightForHeaderInSection:(NSInteger)section{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0 || index == 2) {
        return 24.0;
    }
    return 0.0;
}

//- (BOOL)thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *) table ShouldSelect:(NSIndexPath *)indexPath{
//    int index = [thirdSelectView indexOfTableView:table];
//    if (index == 0 && indexPath.section < firstLetterArray.count) {
//        NSString *key = [firstLetterArray objectAtIndex:indexPath.section];
//        NSArray * array = [provinceDic objectForKey:key];
//        if ([key isEqualToString:KLocationText]) {
//            City *city = [array objectAtIndex:0];
//            if (city.cityId == 0) {
//                return NO;
//            }
//        }
//    }
//    return YES;
//}

-(void) thirdSelectView:(AHThirdSelectView *)thirdSelectView tableView:(AHMultiSelectView *)table DidSelect:(NSIndexPath *)indexPath{
    NSUInteger index = [thirdSelectView indexOfTableView:table];
    if (index == 0) {
        NSString *key = [brandTitles objectAtIndex:indexPath.section];
        Brand *brand = [[brandData objectForKey:key] objectAtIndex:indexPath.row];
        NSArray *series = [BrandManager getSeriesInBrand:brand.brandId];
        [seriesData removeAllObjects];
        [seriesData addObjectsFromArray:series];
        [thirdSelectView reloadTableView:1];
    } else if(index == 1){
        [self selectBrands];
//        Series *series = [seriesData objectAtIndex:indexPath.row];
//        NSArray *years = [BrandManager getYearsInSeries:series.seriesId];
//        [specTitles removeAllObjects];
//        for (CarYear * year in years) {
//            NSArray *carTypes = [BrandManager getCarTypesInYear:year.yearId];
//            [specTitles addObject:year.name];
//            [specData setObject:carTypes forKey:year.name];
//        }
//        [thirdSelectView reloadTableView:2];
    } else if(index == 2){
//        NSString *key = [specTitles objectAtIndex:indexPath.section];
//        CarType *spec = [[specData objectForKey:key] objectAtIndex:indexPath.row];
//        NSLog(@"%@",spec.name);
//        [self selectBrands];
    }
}

-(void) selectBrands{
    NSArray *selectIndexpath = [thirdView indexPathsForSelected];
    Brand *brand = nil;
    Series *series = nil;
    CarType *spec = nil;
    for (int i = 0; i < selectIndexpath.count; i++) {
        NSIndexPath *indexPath = [[selectIndexpath objectAtIndex:i] objectAtIndex:0];
        if (i == 0) {
            NSString *key = [brandTitles objectAtIndex:indexPath.section];
            brand = [[brandData objectForKey:key] objectAtIndex:indexPath.row];
        } else if(i == 1){
             series = [seriesData objectAtIndex:indexPath.row];
        } else if(i == 2) {
            NSString *key = [specTitles objectAtIndex:indexPath.section];
            spec = [[specData objectForKey:key] objectAtIndex:indexPath.row];
        }
    }
    
    if (brandDelegate && [brandDelegate respondsToSelector:@selector(selectedBrand:Series:Spec:)]) {
        [brandDelegate selectedBrand:brand Series:series Spec:spec];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
