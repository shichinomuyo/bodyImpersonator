//
//  kBITableViewCellHaveSwitch.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kBITableViewCellHaveSwitch : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelSwitchName;
@property (weak, nonatomic) IBOutlet UISwitch *kBIUISwitch;
- (IBAction)switch:(UISwitch *)sender;
- (IBAction)soundOnOffSwitch:(UISwitch *)sender;
+ (CGFloat)rowHeight;

@end
