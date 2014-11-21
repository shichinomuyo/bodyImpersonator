//
//  kBIIndicator.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/21.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kBIIndicator : NSObject{
    UIView *indicatorBaseView;
    UIActivityIndicatorView *indicator;
}
- (void)indicatorStart;
- (void)indicatorStop;
@end
