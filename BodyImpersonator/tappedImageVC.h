//
//  tappedImageVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/16.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/7827912478"//@"ca-app-pub-5959590649595305/1259039270"

@interface tappedImageVC : UIViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate,GADInterstitialDelegate>
{
    GADInterstitial *interstitial_;
}

@property (strong,nonatomic) UIImage *selectedImage;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@end
