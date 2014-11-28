//
//  kBISettingMotionControllsViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBITableViewCellHaveSwitch.h"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface kBISettingMotionControllsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL startPlayingByShakeOn;
@property BOOL finishPlayingByShakeOn;
@property BOOL startPlayingWithBibeOn;
@property BOOL finishPlayingWithBibeOn;
@end
