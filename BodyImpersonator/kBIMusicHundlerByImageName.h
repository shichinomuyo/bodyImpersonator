//
//  kBIMusicHundlerByImageName.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface kBIMusicHundlerByImageName : NSObject<NSCoding>
@property NSString *imageName;
@property BOOL rollSoundOn; // rollSoundOnの場合、snareかtimpaniのどちらかをYesにしておく必要がある
@property BOOL snareSoundOn;
@property BOOL timpaniSoundOn;
@property BOOL originalMusicOn;
@property BOOL iPodLibMusicOn;
@property NSURL  *mediaItemURL;
@property MPMediaItemCollection *mediaItemCollection; // 曲がDRM,Deviceにない問題でmediaItemURLがnullになってしまったときだけ使う
@property NSString *artist;
@property NSString *trackTitle;

-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;
@end
