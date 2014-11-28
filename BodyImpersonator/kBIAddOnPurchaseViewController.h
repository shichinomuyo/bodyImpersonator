//
//  kBIAddOnPurchaseViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "kBIIndicator.h"
@interface kBIAddOnPurchaseViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate>

@end
