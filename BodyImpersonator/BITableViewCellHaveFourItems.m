//
//  BIOtherAppsTableViewCell.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "BITableViewCellHaveFourItems.h"

@implementation BITableViewCellHaveFourItems

- (void)awakeFromNib {
    // Initialization code
//    [self.labelDescription setAdjustsFontSizeToFitWidth:NO];
//    [self.labelDescription setMinimumScaleFactor:9];
//    [self.labelDescription setFrame:CGRectMake(0, self.labelDescription.superview.center.y, self.labelDescription.frame.size.width, self.labelDescription.frame.size.height)];
//    [self.labelDescription sizeToFit];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
//    [self.labelDescription.font fontWithSize:13];

//    [self.labelDescription setNumberOfLines:1];
//                [self.labelDescription setAdjustsFontSizeToFitWidth:YES];
    
//                [self.labelDescription setFrame:CGRectMake(0, self.labelDescription.superview.center.y, self.labelDescription.frame.size.width, self.labelDescription.frame.size.height)];
    // デバイスがiphoneであるかそうでないかで分岐

//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        NSLog(@"screenWidth:%.2f",screenRect.size.width);
//            [self.labelDescription setNumberOfLines:2];
//
//        CGRect screenBounds = [[UIScreen mainScreen]bounds];
//        float fontSize;
//              fontSize = 13.0;
//        if (screenBounds.size.width <= 320 ) {
//            fontSize = 8.0;
//        }
//  
//        UIFont *font = self.labelDescription.font;
//        self.labelDescription.font = [UIFont fontWithName:font.fontName size:fontSize];
//    }
//    else{
//
//    }


    
}

+ (CGFloat)rowHeight{
    return 64.0;
}


@end
