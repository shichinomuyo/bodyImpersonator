//
//  kBIShowMusicHundlerInfo.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/26.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBIMusicHundlerByImageName.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AVAudioPlayer+CustomControllers.h"
#import "kAVAudioPlayerManager.h"
#import "BugFixContainerView.h"
#import "NSObject+MyMethod.h"

@interface kBIUIViewShowMusicHundlerInfo : UIView<AVAudioPlayerDelegate,UINavigationControllerDelegate>{
    kBIMusicHundlerByImageName *_hundler;

    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *btnPlayerControll;


    // オーディオプレイヤー制御
    BOOL _musicPlayerIsPlaying;
    AVAudioPlayer *_instantPlayer;

    // labeleアニメーション制御変数
    BOOL labelIsMoving;
    BOOL labelAnimationNeeds;
    float textWidth;
    int textLength;
    float transitionDuration;

}
- (IBAction)btnPlay:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *_contentView;
@property IBOutlet UIView *viewHaveLabel;
@property IBOutlet UILabel *labelMusicHundlerInfo;
@property NSIndexPath *selectedIndexPath;
@property NSInteger selectedIndexNum;
@property BOOL _mpMusicPlayerIsPlaying;
@property MPMusicPlayerController *_mpMusicPlayer;

-(void)showMusicHundlerInfo;
- (void)stopMusicPlayer;
@end
