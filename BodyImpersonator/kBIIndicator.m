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
    //indicatorBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 320, 320);
    UIViewController *presentingVC = [[UIViewController alloc] presentingViewController];
    [indicatorBaseView setCenter:presentingVC.view.center];
    [indicatorBaseView setBackgroundColor:[UIColor grayColor]];
    [indicatorBaseView setAlpha:0.6];
    [indicatorBaseView addSubview:indicator];
    
    [indicator setCenter:presentingVC.view.center];
    [indicator startAnimating];
	
    [presentingVC.view addSubview:indicator];
}

- (void)indicatorStop{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [indicatorBaseView removeFromSuperview];
    
}
@end
