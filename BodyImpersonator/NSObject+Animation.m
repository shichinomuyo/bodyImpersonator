//
//  NSObject+Animation.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "NSObject+Animation.h"

@implementation NSObject (Animation)
+ (void)animationHideNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y - 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y + 32);
                     } completion:^(BOOL finished){
                         [nav setHidden:1];
                         [tool setHidden:1];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }
     ];
    
}
+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [nav setHidden:0];
    [tool setHidden:0];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y + 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y - 32);
                     } completion:^(BOOL finished){

                         [[UIApplication sharedApplication] setStatusBarHidden:NO];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }

     ];
}

+ (void)pickerViewAppear:(UIPickerView *)picker{
    [UIView animateWithDuration:0.2
                     animations:^{
                         [picker setCenter:CGPointMake(picker.superview.center.x, picker.superview.frame.size.height - picker.frame.size.height)];
                     } completion:nil];
}


@end
