//
//  kADMOBController.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/18.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"

#define MY_BANNER_UNIT_ID @"ca-app-pub-5959590649595305/8782306070"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/1259039270"

@interface kADMOBController : NSObject<GADBannerViewDelegate,GADInterstitialDelegate>
@property GADBannerView *banner;
@property GADInterstitial *interstitial;
@end
