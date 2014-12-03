//
//  BICollectionViewCell.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/29.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "BICollectionViewCell.h"

@implementation BICollectionViewCell
-(void)prepareForReuse{
    [super prepareForReuse];
    _imageView.image = nil;
    _imageViewFrame.image = nil;
    _imageViewSelectedFrame.image = nil;
}

+ (CGFloat)cellWidth{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat width = (int)(rect.size.width / 3);
    return width;
}
@end
