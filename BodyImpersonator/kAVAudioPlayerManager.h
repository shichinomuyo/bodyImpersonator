//
//  kAVAudioPlayerManager.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSArray+IndexHelper.h"

@interface kAVAudioPlayerManager : NSObject<AVAudioPlayerDelegate>{
    NSMutableArray *arraySounds;
    AVAudioPlayer *_player;
}

@property(nonatomic) float soundVolume;

+(kAVAudioPlayerManager *)sharedManager;
-(void)playSound:(NSURL *)urlOfSound;
-(void)stopSound;
@end
