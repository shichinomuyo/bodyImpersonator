//
//  kBIShowMusicHundlerInfo.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/26.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBIMusicHundlerByImageName.h"

@interface kBIUIViewShowMusicHundlerInfo : UIView{
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *btnPlayerControll;
    IBOutlet UILabel *labelMusicHundlerInfo;
}

@property NSIndexPath *selectedIndexPath;

-(void)showMusicHundlerInfo;
@end
