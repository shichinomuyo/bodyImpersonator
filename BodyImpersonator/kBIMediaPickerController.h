//
//  kBIMediaPickerVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface kBIMediaPickerController : MPMediaPickerController <MPMediaPickerControllerDelegate>
@property MPMusicPlayerController *musicPlayer;
@end
