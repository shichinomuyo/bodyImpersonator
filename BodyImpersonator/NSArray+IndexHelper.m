//
//  NSArray+IndexHelper.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "NSArray+IndexHelper.h"

@implementation NSArray (IndexHelper)
-(id) safeObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}
@end
