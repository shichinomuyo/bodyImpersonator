//
//  BISettingViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIFeedbakAndActionCell.h"
#import "BIOtherAppsTableViewCell.h"

@interface BISettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
