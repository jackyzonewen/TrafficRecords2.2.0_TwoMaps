//
//  TRSettingPushViewController.h
//  TrafficRecords
//
//  Created by qiao on 14-5-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "TRBaseViewController.h"
#import "PushSettingService.h"
#include "PushSettingService.h"

@interface TRSettingPushViewController : TRBaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView            *pickView;
    UIView                  *pickBgView;
    UILabel                 *timeLabel;
    UISwitch                *openSwitch;
    PushSettingService      *pushServices;
    UISwitch                *openSwitch2;
    PushSettingService      *wzpushServices;
}

@end
