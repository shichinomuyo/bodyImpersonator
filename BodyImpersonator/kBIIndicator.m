//
//  kBIIndicator.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/21.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBIIndicator.h"

@implementation kBIIndicator

- (void)indicatorStart{
    indicatorBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 0, 0);
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    [indicator setCenter:indicatorBaseView.center];
    [indicatorBaseView setCenter:topController.view.center];

    [indicatorBaseView setBackgroundColor:[UIColor grayColor]];
    [indicatorBaseView setAlpha:0.6];
    
    [indicatorBaseView addSubview:indicator];

    [indicator startAnimating];	
    [topController.view addSubview:indicatorBaseView];
}

- (void)indicatorStop{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicatorBaseView removeFromSuperview];
    
}
@end
