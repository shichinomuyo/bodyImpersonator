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
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    NSLog(@"indicator start");
    UIViewController *topVC = [NSObject topMostController];
    int baseViewWidth;
    int baseViewHeight;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){ // 見た目をいい感じにするために分母を変えてる
        NSLog(@"iPhoneの処理");
        baseViewWidth = topVC.view.frame.size.width /2;
        baseViewHeight = baseViewWidth;
    }
    else{
        NSLog(@"iPadの処理");
        baseViewWidth = topVC.view.frame.size.width /4;
        baseViewHeight = baseViewWidth;
    }


    
    CGRect rect = CGRectMake(0, 0, baseViewWidth * 0.8, baseViewWidth * 0.8);

    // ベースビュー
    indicatorBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeight)];
    [indicatorBaseView setBackgroundColor:[UIColor grayColor]];
    [indicatorBaseView.layer setCornerRadius:28];
    [indicatorBaseView setAlpha:0.6];
    // ラベル
    labelLoadingMassage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, 100)];
    [labelLoadingMassage setTextColor:[UIColor whiteColor]];
    [labelLoadingMassage setText:@"Now loading..."];
    [labelLoadingMassage setFont:[UIFont systemFontOfSize:22]];
    [labelLoadingMassage setTextAlignment:NSTextAlignmentCenter];
    [labelLoadingMassage setAdjustsFontSizeToFitWidth:YES];
    
    
    // インジケーター
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = rect;//CGRectMake(0, 0, 100, 100);
    

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
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicatorBaseView removeFromSuperview];
    
}

@end
