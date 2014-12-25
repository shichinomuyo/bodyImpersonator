//
//  kBIMusicHundlerByImageName.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kBIMusicHundlerByImageName : NSObject
@property NSString *imageName;
@property BOOL rollSoundOn;
@property BOOL originalMusicOn;
@property BOOL iPodLibMusicOn;
@property NSURL  *mediaItemURL;
@end
