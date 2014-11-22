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
    NSLog(@"indicator start");
    // ベースビュー
    indicatorBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    [indicatorBaseView setBackgroundColor:[UIColor grayColor]];
    [indicatorBaseView.layer setCornerRadius:28];
    [indicatorBaseView setAlpha:0.6];
    // ラベル
    labelLoadingMassage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [labelLoadingMassage setTextColor:[UIColor whiteColor]];
    [labelLoadingMassage setText:@"Now loading..."];
    [labelLoadingMassage setFont:[UIFont systemFontOfSize:22]];
    [labelLoadingMassage setTextAlignment:NSTextAlignmentCenter];
    [labelLoadingMassage setAdjustsFontSizeToFitWidth:YES];


    // インジケーター
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 100, 100);
    
    UIViewController *topVC = [self topMostController];

//
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

//    while (topController.presentedViewController) {
//        topController = topController.presentedViewController;
//    }
//    
    [indicator setCenter:indicatorBaseView.center];
    [labelLoadingMassage setCenter:CGPointMake(indicatorBaseView.frame.size.width/2, indicatorBaseView.frame.size.height / 6 * 5)];
    [indicatorBaseView addSubview:labelLoadingMassage];
    [indicatorBaseView setCenter:topVC.view.center];
    [indicatorBaseView addSubview:indicator];

    [indicator startAnimating];	
    [topVC.view addSubview:indicatorBaseView];
    NSLog(@"topViewController:%@",topVC);
}

- (void)indicatorStop{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicatorBaseView removeFromSuperview];
    
}

- (UIViewController *)topViewController{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return rootViewController;
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end
