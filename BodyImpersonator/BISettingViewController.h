//
//  BISettingViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIFeedbakAndActionCell.h"
#import "BITableViewCellHaveFourItems.h"
#import "kBITableViewCellHaveSwitch.h"
#import "kBITableViewCellHavePicker.h"
#import "kBISoundEffectSettingsViewController.h"
#import "kBISettingMotionControllsViewController.h"
#import <StoreKit/StoreKit.h>
#import "kBIIndicator.h"
#import "kBIAddOnPurchaseViewController.h"
#import "GAITrackedViewController.h"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface BISettingViewController : GAITrackedViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL purchased;


@end
