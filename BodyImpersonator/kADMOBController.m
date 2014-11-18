//
//  kADMOBController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/18.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kADMOBController.h"

@implementation kADMOBController
#pragma mark -
#pragma mark interstitialInitialize
- (void)interstitialInitialize{
    // 【Ad】インタースティシャル広告の表示
    self.interstitial = [[GADInterstitial alloc] init];
    _interstitial.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    _interstitial.delegate = self;
    [_interstitial loadRequest:[GADRequest request]];
}
#pragma mark -
#pragma mark AdMobDelegate
//// AdMobバナーのloadrequestが失敗したとき
//-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
//    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
//
//    // 他の広告ネットワークの広告を表示させるなど。
//}

/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    NSLog(@"adfrag:%d",[defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"]);
}

// AdMobインタースティシャルの再ロード
- (void)interstitialLoad{
    // 【Ad】インタースティシャル広告の表示
    _interstitial = [[GADInterstitial alloc] init];
    _interstitial.adUnitID = MY_INTERSTITIAL_UNIT_ID;
     _interstitial.delegate = self;
    [_interstitial loadRequest:[GADRequest request]];
}

@end
