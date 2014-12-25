//
//  secondVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/09/09.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitialDelegate.h"
#import "AppDelegate.h"
#import "kBIIndicator.h"
#import "kBIMusicHundlerByImageName.h"
#import "GAITrackedViewController.h"

#ifdef DEBUG
#define LOG(fmt,...) NSLog((@"%s %d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...)
#endif

@interface secondVC : GAITrackedViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, GADInterstitialDelegate>
{
    GADInterstitial *interstitial_;
}

@property (weak, nonatomic) IBOutlet UIImage *selectedImage;
@end
