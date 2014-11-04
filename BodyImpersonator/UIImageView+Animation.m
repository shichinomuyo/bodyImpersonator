//
//  UIImageView+Animation.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/08/08.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)
// フラッシュ
- (void)flashAnimation{
    [self setHidden:0];
    [self setAlpha:0.0];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setAlpha:0.6];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              [self setAlpha:0.0];
                                          } completion:^(BOOL finished) {
                                              [self setHidden:1];
                                              [self setAlpha:0.0];
                                          }];
                     }];
}

// 拡大
- (void)appearWithScaleUp{
    self.transform = CGAffineTransformIdentity;
    [self setHidden:0];
    
    float scale = sqrtf(sqrtf(10)); 
//    float adjustX = (self.bounds.size.width - self.frame.size.width) / 2;
  //  float adjustY = (self.bounds.size.height - self.frame.size.height) / 2;
    
 //   CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度 回転
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale); // 拡大
   // CGAffineTransform t3 = CGAffineTransformMakeTranslation(adjustX, adjustY); // 拡大の際に発生する中心座標の調整
//    CGAffineTransform concat = CGAffineTransformConcat(CGAffineTransformConcat(t1, t2), t3); //  回転　+ 拡大 + 座標調整
    // CGAffineTransform concat = CGAffineTransformConcat(t1, t2); //　回転 + 拡大
    // 中心座標の調整するための座標。以下をsetCenterすると位置がずれない。
    // CGPoint adjustedCenterPoint = CGPointMake(self.center.x + adjustX,self.center.y + adjustY);
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.05f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform =  CGAffineTransformConcat(self.transform, t2);
                         [self setAlpha:0.25];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.05f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.transform =  CGAffineTransformConcat(self.transform, t2);
                                              [self setAlpha:0.5];
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.05f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   self.transform =  CGAffineTransformConcat(self.transform, t2);
                                                                   [self setAlpha:0.75];
                                                               }completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.05f //ここまでで0.20f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                        self.transform =  CGAffineTransformConcat(self.transform, t2);
                                                                                        [self setAlpha:1];
                                                                                    }completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.02f // 0.22f
                                                                                                              delay:0.0f
                                                                                                            options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionBeginFromCurrentState
                                                                                                         animations:^{ // パーン
                                                                                                             //    self.transform =  CGAffineTransformConcat(self.transform, concat);
                                                                                                             self.transform =  CGAffineTransformScale(self.transform, 1.4, 1.4);
                                                                                                             
                                                                                                         }completion:^(BOOL finished) {
                                                                                                             [UIView animateWithDuration:0.4f
                                                                                                                                   delay:0.0f
                                                                                                                                 options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState
                                                                                                                              animations:^{// 元の大きさに戻る
                                                                                                                                  self.transform = CGAffineTransformIdentity;
                                                                                                                                  
                                                                                                                                  
                                                                                                                              }completion:^(BOOL finished) {
                                                                                                                                  
                                                                                                                                  
                                                                                                                              }];
                                                                                                             
                                                                                                         }];
                                                                                        
                                                                                    }];
                                                               }];
                                          }];
                     }];
}

@end
