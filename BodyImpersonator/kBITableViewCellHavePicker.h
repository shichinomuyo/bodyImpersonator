//
//  kBITableViewCellHavePicker.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kBITableViewCellHavePicker : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pickerTitle;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
+(CGFloat)rowHeight;
@end
