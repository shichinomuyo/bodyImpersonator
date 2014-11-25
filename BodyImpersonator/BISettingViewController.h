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
#import <StoreKit/StoreKit.h>

@interface BISettingViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
