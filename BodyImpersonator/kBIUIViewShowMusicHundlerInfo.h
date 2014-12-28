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

@interface kBIUIViewShowMusicHundlerInfo : UIView<AVAudioPlayerDelegate,UINavigationControllerDelegate>{
    kBIMusicHundlerByImageName *_hundler;
    IBOutlet UIView *contentView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *btnPlayerControll;
    IBOutlet UILabel *labelMusicHundlerInfo;
    // オーディオプレイヤー
    BOOL _musicPlayerIsPlaying;
    AVAudioPlayer *_instantPlayer;
}
- (IBAction)btnPlay:(UIButton *)sender;

@property NSIndexPath *selectedIndexPath;
@property NSInteger selectedIndexNum;


-(void)updateViewItems;
-(void)showMusicHundlerInfo;
- (void)stopMusicPlayer;
@end