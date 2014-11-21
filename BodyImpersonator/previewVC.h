//
//  previewVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/07.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "AppDelegate.h"
#import "NSObject+Animation.h"
#import "kBIIndicator.h"


@interface previewVC : UIViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate,GADInterstitialDelegate>
{
    // 【Ad】AdMobインタースティシャル：インタンス変数として1つ宣言
    GADInterstitial *interstitial_;
}

@property (strong,nonatomic) UIImage *selectedImage;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@end
