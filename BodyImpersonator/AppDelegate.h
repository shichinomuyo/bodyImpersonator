//
//  AppDelegate.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GAI.h"
#ifndef DEBUG
#define NSLog(...)
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) UIWindow *window;


@end
