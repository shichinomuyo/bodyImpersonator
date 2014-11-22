//
//  AppDelegate.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef DEBUG
#define NSLog(...)
#endif
static const NSInteger kINTERSTITIAL_DISPLAY_RATE = 1000;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
