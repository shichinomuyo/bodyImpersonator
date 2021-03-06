//
//  ViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> // import済み
#import <AudioToolbox/AudioToolbox.h>// import済み
#import <QuartzCore/QuartzCore.h>// import済み
#import "AVAudioPlayer+CustomControllers.h"// import済み
#import "NSArray+IndexHelper.h"
#import "GADBannerView.h"
#import "NADView.h"
#import "AppDelegate.h"
#import "secondVC.h"
#import "playVC.h" // indexpath受け渡し用にインポート
#import "kBIMediaPickerController.h" // segmentedControllの2のボタンをタップでメディアピッカーを開く
#import "FrameOutCollectionViewFlowLayout.h"
#import "BICollectionViewCell.h"
#import "BICollectionReusableView.h"
#import "tappedImageVC.h"
#import "kBIIndicator.h"
#import "kBIUIViewShowMusicHundlerInfo.h"
#import "GAITrackedViewController.h"
#import "kADMOBInterstitialSingleton.h"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface ViewController : GAITrackedViewController<GADBannerViewDelegate,NADViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout>{
    //【Ad】AdMobバナー：インスタンス変数として1つ宣言
    GADBannerView *bannerView_;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property(nonatomic,retain)NADView *nadView;
@property (strong,nonatomic) NSIndexPath *selectedIndexPath;
@property (strong,nonatomic) UIImage *selectedImage;
@property (strong,nonatomic) NSIndexPath *tappedIndexPath;
@property int limitedNumberOfImages;
@property BOOL purchased;
@property BOOL startPlayingByShakeOn;
@property BOOL startPlayingWithVibeOn;

@end