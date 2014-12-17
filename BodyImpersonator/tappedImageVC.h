//
//  tappedImageVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/16.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "AppDelegate.h"
#import "NSObject+Animation.h"
#import "kBIIndicator.h"
#import "GAITrackedViewController.h"


@interface tappedImageVC : GAITrackedViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate,GADInterstitialDelegate>
{
    GADInterstitial *interstitial_;
}

@property (strong,nonatomic) UIImage *selectedImage;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@end
