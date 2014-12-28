//
//  kBISelectMusicViewController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIFeedbakAndActionCell.h"
#import "GAITrackedViewController.h"
#import "kBIMediaPickerController.h"
#import "kBIMusicHundlerByImageName.h"

@interface kBISelectMusicViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property NSIndexPath *tappedIndexPath;


@end
