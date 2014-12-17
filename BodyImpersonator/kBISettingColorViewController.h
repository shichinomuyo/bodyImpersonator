//
//  kBISettingColorViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface kBISettingColorViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
+ (CGFloat)rowHeight;
@end
