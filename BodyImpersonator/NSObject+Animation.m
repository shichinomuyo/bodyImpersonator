//
//  NSObject+Animation.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/20.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "NSObject+Animation.h"

@implementation NSObject (Animation)
+ (void)animationHideNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool CustomView:(kBIUIViewShowMusicHundlerInfo *)customView{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y - 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y + 32);
                         customView.center = CGPointMake(customView.center.x, customView.center.y + 64);
                     } completion:^(BOOL finished){
                         [nav setHidden:1];
                         [tool setHidden:1];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }
     ];
    
}

+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool CustomView:(kBIUIViewShowMusicHundlerInfo *)customView{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [nav setHidden:0];
    [tool setHidden:0];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, 22);
                         tool.center = CGPointMake(tool.center.x, tool.center.y - 32);
                         customView.center = CGPointMake(customView.center.x, customView.center.y - 64);
                     } completion:^(BOOL finished){

                         [[UIApplication sharedApplication] setStatusBarHidden:NO];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }

     ];
}

+ (void)animationHideNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool kView:(UIView *)view{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y - 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y + 32);
                         view.center = CGPointMake(view.center.x, view.center.y + 64);
                     } completion:^(BOOL finished){
                         [nav setHidden:1];
                         [tool setHidden:1];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }
     ];
    
}

+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool kView:(UIView *)view{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [nav setHidden:0];
    [tool setHidden:0];
    [UIView animateWithDuration:0.15f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, 22);
                         tool.center = CGPointMake(tool.center.x, tool.center.y - 32);
                         view.center = CGPointMake(view.center.x, view.center.y - 64);
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

+ (void)slideInUIViewToCenter:(UIView *)view{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    view.center = CGPointMake((0 - view.center.x),view.center.y);

    [view setHidden:0];

    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    [UIView animateKeyframesWithDuration:0.7
                                   delay:0.0
                                 options:0 << 16
                              animations:^{
                                  view.center = CGPointMake(rect.size.width/2, view.center.y);
                                  NSLog(@"mainFrameX:%.2f",rect.size.width);
                                  NSLog(@"view.centerX:%.2f",view.center.x);
                                  NSLog(@"view.frame.size(%.2f,%.2f)",view.frame.size.width, view.frame.size.height);
//                                  [view.layer setBorderColor:[[UIColor blueColor]CGColor]];
//                                  [view.layer setBorderWidth:4.0];
                              } completion:^(BOOL finished){
                                      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                              }];
}


@end
