//
//  NSObject+Animation.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Animation)
+ (void)animationHideNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool;
+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool;

@end
