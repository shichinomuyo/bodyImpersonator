//
//  previewVC.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/07.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface previewVC : UIViewController<UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UIActionSheetDelegate>
@property NSIndexPath *receiveIndexPath;
@end
