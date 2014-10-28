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
#import "AVAudioPlayer+CustomControllers.h"
#import "UIImageView+Animation.h"
#define RGB(r, g, b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface playVC : UIViewController<AVAudioPlayerDelegate>

@end
