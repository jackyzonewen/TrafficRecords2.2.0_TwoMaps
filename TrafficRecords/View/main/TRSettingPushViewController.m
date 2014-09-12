//
//  TRSettingPushViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-5-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRSettingPushViewController.h"

@interface TRSettingPushViewController ()

@end

@implementation TRSettingPushViewController

-(NSString *) naviTitle{
    return @"推送设置";
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
    
    float startY = 22;
    NSString *infoText = [[NSUserDefaults standardUserDefaults] objectForKey:KNoPushCity];
    if (infoText.length > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, self.view.width - 24, 30)];
        label.font = [TRSkinManager smallFont1];
        CGSize size = [infoText sizeWithFont:label.font constrainedToSize:CGSizeMake(label.width, 999999)];
        [label setHeight:size.height];
        label.backgroundColor = [UIColor clearColor];
        label.text = infoText;
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        [self.view addSubview:label];
        startY = label.bottom + 10;
    }
    
    UIView *cell3 = [[UIView alloc] initWithFrame:CGRectMake(0, startY, self.view.width, 45)];
    cell3.backgroundColor = [TRSkinManager bgColorWhite];
    [self.view addSubview:cell3];
    float lineH = [TRUtility lineHeight];
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell3.width, lineH)];
    topline.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
    [cell3 addSubview:topline];
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, cell3.height - lineH, cell3.width, lineH)];
    bottom.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
    [cell3 addSubview:bottom];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell3.width/3, cell3.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [TRSkinManager colorWithInt:0x666666];
    label.font = [TRSkinManager mediumFont3];
    label.text = @"新违章推送";
    [cell3 addSubview:label];
    UISwitch *switchV = [[UISwitch alloc] init];
    [switchV addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    switchV.frame = CGRectMake(cell3.width - 12 - switchV.width, cell3.height/2  - switchV.height/2, switchV.width, switchV.height);
    [cell3 addSubview:switchV];
    switchV.onTintColor = [self naviColor];
    openSwitch2 = switchV;
    openSwitch2.on = ![[NSUserDefaults standardUserDefaults] boolForKey:KWZPushSettingClose];
    
    UIView *cell1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell3.bottom + 22, self.view.width, 90)];
    cell1.backgroundColor = [TRSkinManager bgColorWhite];
    [self.view addSubview:cell1];
    topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell1.width, lineH)];
    topline.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
    [cell1 addSubview:topline];
    bottom = [[UIView alloc] initWithFrame:CGRectMake(0, cell1.height - lineH, cell1.width, lineH)];
    bottom.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
    [cell1 addSubview:bottom];
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell1.width/3, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [TRSkinManager colorWithInt:0x666666];
    label.font = [TRSkinManager mediumFont3];
    label.text = @"限行推送";
    [cell1 addSubview:label];
    switchV = [[UISwitch alloc] init];
    [switchV addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    switchV.frame = CGRectMake(cell1.width - 12 - switchV.width, cell1.height/4  - switchV.height/2, switchV.width, switchV.height);
    [cell1 addSubview:switchV];
    switchV.onTintColor = [self naviColor];
    openSwitch = switchV;
    openSwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:KPushSettingClose];
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(12, cell1.height/2, cell1.width - 12, lineH)];
    middleLine.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
    [cell1 addSubview:middleLine];
    
    UIButton *cell2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    cell2.frame = CGRectMake(0, middleLine.bottom, self.view.width, 45);
//    [[UIView alloc] initWithFrame:CGRectMake(0, cell1.bottom + 22, self.view.width, 45)];
    cell2.backgroundColor = [TRSkinManager bgColorWhite];
    [cell1 addSubview:cell2];
    [cell2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell2.width, lineH)];
//    topline.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
//    [cell2 addSubview:topline];
//    bottom = [[UIView alloc] initWithFrame:CGRectMake(0, cell2.height - lineH, cell2.width, lineH)];
//    bottom.backgroundColor = [TRSkinManager colorWithInt:0xe3e0de];
//    [cell2 addSubview:bottom];
    label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell2.width/3, cell2.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [TRSkinManager colorWithInt:0x666666];
    label.font = [TRSkinManager mediumFont3];
    label.text = @"时间设置";
    [cell2 addSubview:label];

    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(cell2.width/2 - 12, 0, cell2.width/2, cell2.height)];
    label2.backgroundColor = [UIColor clearColor];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:KPushSettingClose]) {
        label2.textColor = [TRSkinManager colorWithInt:0xcccccc];
    } else {
        label2.textColor = [TRSkinManager colorWithInt:0x666666];
    }
    
    label2.font = [TRSkinManager mediumFont3];
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:KPushStartTime];
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:KPushEndTime];
    if (str1.length == 0 || str2.length == 0) {
        str1 = @"20:00";
        str2 = @"22:00";
    }
    NSString *text = [NSString stringWithFormat:@"%@~%@", str1, str2];
    label2.text = text;
    label2.textAlignment = NSTextAlignmentRight;
    [cell2 addSubview:label2];
    timeLabel = label2;
}

-(void) btnClick:(id) sender{
    if (pickBgView == nil || pickBgView.hidden == YES) {
        [self showPickView];
    } else {
        pickBgView.hidden = YES;
    }
}

-(void) switchChanged:(id)sender{
    if (sender == openSwitch) {
        [self uploadSetting];
        if (!openSwitch.on) {
            timeLabel.textColor = [TRSkinManager colorWithInt:0xcccccc];
        } else {
            timeLabel.textColor = [TRSkinManager colorWithInt:0x666666];
        }
    } else if(sender == openSwitch2)
    {
        [self wzuploadSetting];
    }
}

-(void) wzuploadSetting{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey];
    if (token.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请打开系统设置中的通知中心，允许“违章查询助手”使用通知服务。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //取消之前的上传设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(wzdoUploadSetting) object:nil];
    [self performSelector:@selector(wzdoUploadSetting) withObject:nil afterDelay:1];
}

-(void) wzdoUploadSetting{
    if (wzpushServices == nil) {
        wzpushServices = [[PushSettingService alloc] init];
        wzpushServices.delegate = self;
        wzpushServices.reqTag = EServiceWZPushSetting;
    }
    [wzpushServices upWzPushSetting:openSwitch2.on];
}


-(void) showPickView{
    if (!openSwitch.on) {
        [self showInfoView:@"请先打开推送开关"];
        return;
    }
    if (pickBgView == nil) {
        pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        pickBgView.backgroundColor = [TRSkinManager colorWithInt:0x99000000];
        [self.view addSubview:pickBgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick:)];
        [pickBgView addGestureRecognizer:tap];
        
        float startY = self.view.height - 204;
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, startY, self.view.width, 204)];
        view1.backgroundColor = [TRSkinManager bgColorLight];
        [pickBgView addSubview:view1];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 52, 44);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[TRSkinManager colorWithInt:0x666666] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents: UIControlEventTouchUpInside];
        [view1 addSubview:cancel];
        
        UIButton *queding = [UIButton buttonWithType:UIButtonTypeCustom];
        queding.frame = CGRectMake(view1.width - 52, 0, 52, 44);
        [queding setTitle:@"确定" forState:UIControlStateNormal];
        [queding setTitleColor:[TRSkinManager colorWithInt:0x666666] forState:UIControlStateNormal];
        [queding addTarget:self action:@selector(okBtnClick:) forControlEvents: UIControlEventTouchUpInside];
        [view1 addSubview:queding];
        startY+=44;
        pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 160)];
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        [view1 addSubview:pickView];
//        - (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
        NSArray *data = [timeLabel.text componentsSeparatedByString:@"~"];
         NSArray *array = [NSArray arrayWithObjects:@"0:00", @"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00", @"7:00", @"8:00", @"9:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00",  nil];
        int index1 = [array indexOfObject:[data objectAtIndex:0]];
        int index2 = [array indexOfObject:[data objectAtIndex:1]];
        [pickView selectRow:index1 inComponent:0 animated:YES];
        [pickView selectRow:index2 inComponent:1 animated:YES];
    }
    pickBgView.hidden = NO;
}

-(void) cancelBtnClick:(id) sender{
    pickBgView.hidden = YES;
}

-(void) okBtnClick:(id) sender{
    pickBgView.hidden = YES;
    NSArray *array = [NSArray arrayWithObjects:@"0:00", @"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00", @"7:00", @"8:00", @"9:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00",  nil];
    NSString *str1 = [array objectAtIndex:[pickView selectedRowInComponent:0]];
    NSString *str2 = [array objectAtIndex:[pickView selectedRowInComponent:1]];
    NSString *text = [NSString stringWithFormat:@"%@~%@", str1, str2];
    timeLabel.text = text;
    [self uploadSetting];
}

-(void) uploadSetting{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KSaveTokenKey];
    if (token.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请打开系统设置中的通知中心，允许“违章查询助手”使用通知服务。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //取消之前的上传设置
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doUploadSetting) object:nil];
    [self performSelector:@selector(doUploadSetting) withObject:nil afterDelay:1];
}

-(void) doUploadSetting{
    if (pushServices == nil) {
        pushServices = [[PushSettingService alloc] init];
        pushServices.delegate = self;
    }
    NSArray *data = [timeLabel.text componentsSeparatedByString:@"~"];
    NSString *str1 = [data objectAtIndex:0];
    NSString *str2 = [data objectAtIndex:1];
    str1 = [str1 stringByReplacingOccurrencesOfString:@":" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@":" withString:@""];
    if (!openSwitch.on) {
        [MobClick event:@"limit_setting_close"];
    } else {
        [MobClick event:@"limit_setting_open"];
    }
    [pushServices upLoadPushSetting:openSwitch.on startTime:str1 endTime:str2];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 24;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *array = [NSArray arrayWithObjects:@"0:00", @"1:00", @"2:00", @"3:00", @"4:00", @"5:00", @"6:00", @"7:00", @"8:00", @"9:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00",  nil];
    return [array objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)netServiceFinished:(AHServiceRequestTag) tag{
    if (EServiceWZPushSetting == tag) {
        [[NSUserDefaults standardUserDefaults] setBool:!openSwitch2.on forKey:KWZPushSettingClose];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if(EServicePushSetting == tag){
        NSArray *data = [timeLabel.text componentsSeparatedByString:@"~"];
        NSString *str1 = [data objectAtIndex:0];
        NSString *str2 = [data objectAtIndex:1];
        [[NSUserDefaults standardUserDefaults] setBool:!openSwitch.on forKey:KPushSettingClose];
        [[NSUserDefaults standardUserDefaults] setObject:str1 forKey:KPushStartTime];
        [[NSUserDefaults standardUserDefaults] setObject:str2 forKey:KPushEndTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self showInfoView:@"推送设置修改成功！"];
}

- (void)netServiceError:(AHServiceRequestTag)tag errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self showInfoView:@"推送设置修改失败！"];
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
