//
//  previewVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/07.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+Animation.h"

#import "kBIUIViewShowMusicHundlerInfo.h"
#import "kBISelectMusicViewController.h"
#import "GAITrackedViewController.h"
#import "kADMOBInterstitialSingleton.h"

@interface previewVC : GAITrackedViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIImage *selectedImage;
@property NSIndexPath *selectedIndexPath;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@end
