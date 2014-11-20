//
//  tappedImageVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/16.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "tappedImageVC.h"
//#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/1259039270" // メインビュー
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-5959590649595305/7827912478" //previewView用

@interface tappedImageVC (){
    UIActionSheet *_actionSheetAlert;
}


@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
- (IBAction)removeItemBtn:(UIBarButtonItem *)sender;
- (IBAction)setImageBtn:(UIBarButtonItem *)sender;
- (IBAction)btnCoverAllDisplay:(UIButton *)sender;
- (IBAction)actionBtn:(UIBarButtonItem *)sender;

@end

@implementation tappedImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        //            self.contentSizeForViewInPopover = CGSizeMake(220, 340);
    }
    else{
        NSLog(@"iPadの処理");
    }
    

    
    //デフォルトのナビゲーションコントロールを非表示にする
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // Modalなので縮小しない
        [self viewSizeMake:1.0];
    }
    else{
        NSLog(@"iPadの処理");
        // popoverなので縮小する
        [self viewSizeMake:0.5];
    }
    NSInteger countViewChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"KEY_countUpViewChanged"];
    countViewChanged ++;
    [[NSUserDefaults standardUserDefaults] setInteger:countViewChanged forKey:@"KEY_countUpViewChanged"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)viewDidAppear:(BOOL)animated{
    // インタースティシャル広告表示
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countViewChanged = [defaults integerForKey:@"KEY_countUpViewChanged"];
    NSInteger memoryCountNumberOfInterstitialDidAppear = [defaults integerForKey:@"KEY_memoryCountNumberOfInterstitialDidAppear"];

    if (countViewChanged != memoryCountNumberOfInterstitialDidAppear) {
        if (((countViewChanged % kINTERSTITIAL_DISPLAY_RATE) == 0)) {
            // 広告表示フラグ確認
            _adsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_adsRemoved"];
            //    _adsRemoved = NO; // デバッグ用 YESで購入後の状態
            if (_adsRemoved == NO) {
                // 広告表示
                [self interstitialLoad];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // ナビゲーションバー非表示

}

- (void)viewSizeMake:(CGFloat)scale{
    // スクリーンサイズを取得
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
    // popoverするサイズを決定
    CGSize popoverSize = CGSizeMake(screenRect.size.width*scale, screenRect.size.height*scale); // size of view in popover
    // popoverするサイズを設定
    self.preferredContentSize = popoverSize;
    self.modalInPopover = YES;
    
    UIImage *image = _selectedImage; // 遷移元のビューから渡された画像をセット
    // imageviewのpreviewImageViewに画像を設定
    [self.previewImageView setImage:[self popoverWithImage:image screenSize:screenSize popoverScale:scale]];
    
    // previewImageViewの位置とサイズを親ビューに合わせる
    [self.previewImageView setFrame:CGRectMake(0, 0,popoverSize.width, popoverSize.height)];
    
    //    NSLog(@"popoverSize (%.1f,%.1f)", popoverSize.width,popoverSize.height);
    //    NSLog(@"self.view.frame (%.1f,%.1f,%.1f,%.1f)", self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    //    NSLog(@"previewImageView.frame (%.1f,%.1f,%.1f,%.1f)", self.previewImageView.frame.origin.x,self.previewImageView.frame.origin.y,self.previewImageView.frame.size.width,self.previewImageView.frame.size.height);
}

// 縦横長い方に合わせて縮小する
-(UIImage *)popoverWithImage:(UIImage *)image screenSize:(CGSize)size popoverScale:(CGFloat)scale{
    // ビューとイメージの比率を計算する
    CGFloat widthRatio  = size.width  / image.size.width;
    CGFloat heightRatio = size.height / image.size.height;
    // (widthRatio < heightRatio)が真なら ratio = widthRatio/ 偽ならratio = heightRatio
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    NSLog(@"widthRatio:%.2f",widthRatio);
    NSLog(@"heightRatio:%.2f",heightRatio);
    NSLog(@"ratio:%.2f",ratio);
    CGRect rect;
    if (ratio > 1.0) {
        rect = CGRectMake(0, 0,
                          image.size.width  / ratio,
                          image.size.height / ratio);
    } else{
        rect = CGRectMake(0,0,image.size.width * scale, image.size.height * scale);
    }
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"rect.size (%.2f,%.2f)", rect.size.width,rect.size.height);
    return shrinkedImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// 表示されている画像を削除
- (IBAction)removeItemBtn:(UIBarButtonItem *)sender {
    // アクションコントローラー生成
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Remove this Image?"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    [actionController addAction:[UIAlertAction actionWithTitle:@"Remove this Image"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           // 最初の画面にBackFromPreviewVCRemoveItemBtnで戻ると削除メソッドが動く
                                                           [self performSegueWithIdentifier:@"BackFromTappedImageVCRemoveItemBtn" sender:self];
                                                       }]];
    [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
        // キャンセルタップ時の処理
    }]];
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
            [self presentViewController:actionController animated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:actionController];
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)actionSetImage:(UIBarButtonItem *)sender{
    // アクションコントローラー生成
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Set this Image?"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    [actionController addAction:[UIAlertAction actionWithTitle:@"Set this Image"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self performSegueWithIdentifier:@"BackFromTappedImageVCSetImageBtn" sender:self];
                                                       }]];
    [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           // キャンセルタップ時の処理
                                                       }]];
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
            [self presentViewController:actionController animated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        if (sender == nil) {
            actionController.popoverPresentationController.sourceView = self.view;
            actionController.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
            [actionController.popoverPresentationController setPermittedArrowDirections:0];
            [self presentViewController:actionController animated:YES completion:nil];
        }else{
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:actionController];
            [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }




}

- (IBAction)setImageBtn:(UIBarButtonItem *)sender {
    [self actionSetImage:sender];
    
}

// アクションメニューを作成・表示
- (IBAction)actionBtn:(UIBarButtonItem *)sender {
    NSArray *activityItems = @[_selectedImage];
    // 連携できるアプリを取得する
    //    UIActivity *activity = [[UIActivity alloc]init]; // twitter等画像を共有はさせない
    //    NSArray *activities = @[activity];
    // アクティビティコントローラーを作る
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];// 画像を共有されないようにnil
    // 無効にする機能を指定
    NSArray *excludedActivityTypes =@[UIActivityTypePostToTwitter,UIActivityTypePostToFacebook,UIActivityTypePostToFlickr,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludedActivityTypes;
    // アクティビティコントローラーを表示する
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){    // デバイスがiphoneであるかそうでないかで分岐
        NSLog(@"iPhoneの処理");
            [self presentViewController:activityVC animated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:activityVC];
            [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)btnCoverAllDisplay:(UIButton *)sender {
    [self actionSetImage:nil];
    
}

// デバッグ用
- (void)removeAllDocumentsFiles{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSData *arrayData = [defaults objectForKey:@"arrayImages"];
    //    NSMutableArray *tmpArray = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    //    [tmpArray removeAllObjects];
    //    arrayData = [NSKeyedArchiver archivedDataWithRootObject:tmpArray];
    //    [defaults setObject:arrayData forKey:@"arrayImages"];
    
    // usserdefaultsからarrayImagesとimageCountを削除
    //    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSError *error;
    //    [fileManager removeItemAtPath:path error:&error];
    [defaults removeObjectForKey:@"KEY_arrayImages"];
    //    [defaults removeObjectForKey:@"KEY_imageCount"];
    [defaults synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

#pragma mark -
#pragma mark AdMobDelegate
//// AdMobバナーのloadrequestが失敗したとき
//-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
//    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
//
//    // 他の広告ネットワークの広告を表示させるなど。
//}

/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    // 他の広告ネットワークの広告を表示させるなど。
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];

}
-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{

}


// AdMobインタースティシャルの再ロード
- (void)interstitialLoad{
    // 【Ad】インタースティシャル広告の表示
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
    // 広告表示準備完了状況フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger memoryCountNumberOfInterstitialDidAppear = [defaults integerForKey:@"KEY_countUpViewChanged"];
    [defaults setInteger:memoryCountNumberOfInterstitialDidAppear forKey:@"KEY_memoryCountNumberOfInterstitialDidAppear"];
    [defaults synchronize];
}
@end
