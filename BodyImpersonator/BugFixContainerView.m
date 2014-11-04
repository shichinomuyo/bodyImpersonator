//
//  BugFixContainerView.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/04.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "BugFixContainerView.h"

@implementation BugFixContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    static CGPoint fixCenter = {0};
    [super layoutSubviews];
    if (CGPointEqualToPoint(fixCenter, CGPointZero)) {
        fixCenter = [self.knobImageView center];
    } else {
        self.knobImageView.center = fixCenter;
    }
}
@end
