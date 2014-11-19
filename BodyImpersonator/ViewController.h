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
#import "GADInterstitial.h"
#import "NADView.h"
#import "AppDelegate.h"
#import "secondVC.h"
#import "previewVC.h"
#import "playVC.h" // indexpath受け渡し用にインポート
#import "FrameOutCollectionViewFlowLayout.h"
#import "BICollectionViewCell.h"
#import "BICollectionReusableView.h"
#import "tappedImageVC.h"

#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface ViewController : UIViewController<GADBannerViewDelegate,GADInterstitialDelegate,NADViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    //【Ad】AdMobバナー：インスタンス変数として1つ宣言
    GADBannerView *bannerView_;
    
    // 【Ad】AdMobインタースティシャル：インタンス変数として1つ宣言
    GADInterstitial *interstitial_;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property(nonatomic,retain)NADView *nadView;
@property (strong,nonatomic) NSIndexPath *selectedIndexPath;
@property (strong,nonatomic) UIImage *selectedImage;
@property (strong,nonatomic) NSIndexPath *tappedIndexPath;
@property BOOL adsRemoved;
@property BOOL limitNumberOfImagesRemoved;
@property int limitedNumberOfImages;


@end