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
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y - 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y + 32);
                     } completion:^(BOOL finished){
                         [nav setHidden:1];
                         [tool setHidden:1];
                         [[UIApplication sharedApplication] setStatusBarHidden:YES];
                     }
     ];
    
}
+ (void)animationAppearNavBar:(UINavigationBar *)nav ToolBar:(UIToolbar *)tool{
    [nav setHidden:0];
    [tool setHidden:0];
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         nav.center = CGPointMake(nav.center.x, nav.center.y + 48);
                         tool.center = CGPointMake(tool.center.x, tool.center.y - 32);
                     } completion:^(BOOL finished){

                         [[UIApplication sharedApplication] setStatusBarHidden:NO];
                     }

     ];
}


@end
