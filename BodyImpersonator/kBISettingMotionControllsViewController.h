//
//  kBISettingMotionControllsViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBITableViewCellHaveSwitch.h"

@interface kBISettingMotionControllsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
+ (CGFloat)rowHeight;
@property BOOL startPlayingByMotionOn;
@property BOOL finishPlayingByMotionOn;
@end
