//
//  kBITableViewCellHaveSwitch.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBITableViewCellHaveSwitch.h"

@implementation kBITableViewCellHaveSwitch

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)soundOnOffSwitch:(UISwitch *)sender {
}

+ (CGFloat)rowHeight{
    return 44.0;
}


- (IBAction)switch:(UISwitch *)sender {
    BOOL rollSoundEnable;
    if(sender.isOn){
        rollSoundEnable = YES;
        [[NSUserDefaults standardUserDefaults] setBool:rollSoundEnable forKey:@"KEY_RollSoundEnableState"];
    }else{
        rollSoundEnable = NO;
        [[NSUserDefaults standardUserDefaults] setBool:rollSoundEnable forKey:@"KEY_RollSoundEnableState"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
