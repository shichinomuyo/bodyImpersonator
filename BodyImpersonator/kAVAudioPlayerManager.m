//
//  kAVAudioPlayerManager.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kAVAudioPlayerManager.h"

@implementation kAVAudioPlayerManager

static kAVAudioPlayerManager *_sharedData = nil;

+(kAVAudioPlayerManager *)sharedManager{
    @synchronized(self){
        if (!_sharedData) {
            _sharedData = [[kAVAudioPlayerManager alloc] init];
        }
    }
    return _sharedData;
}

-(id)init{
    self = [super init];
    if (self) {
        arraySounds = [[NSMutableArray alloc] init];
        _soundVolume = 1.0;
    }
    return self;
}

-(void)playSound:(NSURL *)urlOfSound{
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:0];
    player.volume = _soundVolume;
    player.delegate = (id)self;
    [arraySounds insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

-(void)stopSound{
    AVAudioPlayer *currentplayer = [arraySounds safeObjectAtIndex:0];
    if (currentplayer) { // 再生しているインスタンスがあるときだけプレイヤー停止と削除実行
        [currentplayer stop];
        [arraySounds removeObject:currentplayer];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [arraySounds removeObject:player];
    // 他のクラスへ再生終了を通知する
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AVAudioPlayerDidFinishPlaying" object:nil];
}
@end
