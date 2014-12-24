//
//  playVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AVAudioPlayer+CustomControllers.h"
#import "UIImageView+Animation.h"
#import "BugFixContainerView.h"
#import "GAITrackedViewController.h"


#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface playVC : GAITrackedViewController<AVAudioPlayerDelegate,AVAudioSessionDelegate>
@property (strong,nonatomic) UIImage *selectedImage;
@property BOOL rollSoundOn;
@property BOOL musicOn;
@property BOOL crashSoundOn;
@property BOOL originalMusicOn;
@property BOOL flashOn;
@property BOOL finishPlayingByShakeOn;
@property BOOL finishPlayingWithVibeOn;
@property NSString *bgColorName;
@property MPMusicPlayerController *musicPlayer;

@end
