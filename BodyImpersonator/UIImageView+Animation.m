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

// 回転しながら拡大してギザギザになるアニメーション　1.09sec
- (void)appearWithScaleUp{
    self.transform = CGAffineTransformIdentity;
    // NSUserDefaultsから画像を取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSDataとして情報を取得
    NSData *imageData = [defaults objectForKey:@"KEY_selectedImage"];
    // NSDataからUIImageを作成
    UIImage *selectedImage = [UIImage imageWithData:imageData];
    // selectedImageをUIImageviewの画像に設定
    [self setImage:selectedImage];
    [self setHidden:0];
    
    float scale = sqrtf(sqrtf(10));
    float adjustX = (self.bounds.size.width - self.frame.size.width) / 2;
    float adjustY = (self.bounds.size.height - self.frame.size.height) / 2;
    
    CGAffineTransform t1 = CGAffineTransformMakeRotation(M_PI_2); // M_PI 180度 M_PI_2 90度 回転
    CGAffineTransform t2 = CGAffineTransformMakeScale(scale, scale); // 拡大
    CGAffineTransform t3 = CGAffineTransformMakeTranslation(adjustX, adjustY); // 拡大の際に発生する中心座標の調整
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


// 拡大して現れる。ctrlBtnALIZARINの出現時のみに使用。0.4sec
- (void)appearALIZARINWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"hitR1.png"]];
    [self setHidden:0];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 10.1, 10.1);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.01, 1.01);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.transform = CGAffineTransformIdentity;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
    
                     }];
}

- (void)appearEmeraldWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"ctrlBtnDF.png"]];
    [self setHidden:0];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 10.75, 10.75);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.01, 1.01);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                   self.transform = CGAffineTransformIdentity;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}


// 縮小して消える。ctrlBtnEmeraldの消失時のみに使用。
- (void)disappearEmeraldWithScaleDown:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"ctrlBtnDF.png"]];
    [self setHidden:0];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}


// 縮小して消える。ctrlBtnALIZARINの消失時のみに使用。
- (void)disappearALIZARINWithScaleUp:(NSTimer *)timer{
    self.transform = CGAffineTransformIdentity;
    [self setImage:[UIImage imageNamed:@"hitR1.png"]];
    [self setHidden:0];
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [self setHidden:1];
                                                                   [timer invalidate];
                                                                   
                                                                   
                                                               }];
                                              
                                              
                                          }];
                         
                     }];
}

@end
