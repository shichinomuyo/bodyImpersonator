//
//  BIComposeActionTableViewCell.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIFeedbakAndActionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFeedbackAction;

@property (strong, nonatomic) IBOutlet UILabel *labelFeedbackAction;




+ (CGFloat)rowHeight;
@end
