//
//  NSObject+Animation.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kBIUIViewShowMusicHundlerInfo.h"

@interface NSObject (Animation)
+ (void)animationHideNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool CustomView:(kBIUIViewShowMusicHundlerInfo *)customView;
+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool CustomView:(kBIUIViewShowMusicHundlerInfo *)customView;
+ (void)pickerViewAppear:(UIPickerView *)picker;
@end
