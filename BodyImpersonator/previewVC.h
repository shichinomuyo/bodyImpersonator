//
//  previewVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/07.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/7827912478"//@"ca-app-pub-5959590649595305/1259039270"
@interface previewVC : UIViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate,GADInterstitialDelegate>
{
    // 【Ad】AdMobインタースティシャル：インタンス変数として1つ宣言
    GADInterstitial *interstitial_;
}

@property (strong,nonatomic) UIImage *selectedImage;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@end
