//
//  tappedImageVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/16.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tappedImageVC : UIViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIImage *selectedImage;

@end
