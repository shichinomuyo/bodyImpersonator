//
//  kBISoundEffectSettingsViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBITableViewCellHaveSwitch.h"
#import "kBITableViewCellHavePicker.h"
#import "kBISettingColorViewController.h"
#import "GAITrackedViewController.h"

@interface kBISoundEffectSettingsViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL musicOn;
@property BOOL crashSoundOn;
@property BOOL flashOn;

@end
