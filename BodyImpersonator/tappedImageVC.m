//
//  tappedImageVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/16.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "tappedImageVC.h"

@interface tappedImageVC (){
    UIActionSheet *_actionSheetAlert;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
- (IBAction)selectMusic:(UIBarButtonItem *)sender;

- (IBAction)removeItemBtn:(UIBarButtonItem *)sender;
- (IBAction)setImageBtn:(UIBarButtonItem *)sender;
- (IBAction)btnCoverAllDisplay:(UIButton *)sender;
- (IBAction)actionBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet kBIUIViewShowMusicHundlerInfo *customUIView;
@property (weak, nonatomic) IBOutlet UIView *kUIViewMiniPlayerWrapper;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSetImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsCustomUIViewWidth_iPad;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsCustomUIViewWidth_iPhone;

@end

@implementation tappedImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar.items[0] setTitle:self.viewTitle]; // Veiwのタイトルをメインビューから引き継いだviewTitleにより動的に変更


    // viewTitleがSelected Imageだった場合、setImageBtnを削除(MusicFlexible Spaceも削除)
    NSString *locTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"Selected Image", nil)];
    if ([self.viewTitle isEqualToString:locTitle]) {
        NSMutableArray *items = [[NSMutableArray alloc] initWithArray:_toolBar.items];
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc]init];
        [indexSet addIndex:3];
        [indexSet addIndex:4];
        [items removeObjectsAtIndexes:indexSet];
        [_toolBar setItems:items];
    }
    
    
    // GoogleAnalytics導入のため以下設定
    self.screenName = @"BI_TappedVC";
    
    // 操作無効解除
    [[UIApplication sharedApplication] endIgnoringInteractionEvents]; // 遷移元で操作無効にしているので解除
    
    // 遷移元のviewControllerからもらった画像をセット
    [_previewImageView setImage:_selectedImage];
    
    //デフォルトのナビゲーションコントロールを非表示にする
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    UIPanGestureRecognizer *backGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backGesture:)];
    [self.view addGestureRecognizer:backGestureRecognizer];
    
    NSInteger countViewChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"KEY_countUpViewChanged"];
    countViewChanged ++;
    [[NSUserDefaults standardUserDefaults] setInteger:countViewChanged forKey:@"KEY_countUpViewChanged"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"viewchanged:%ld",(long)countViewChanged);
    
    [self.customUIView setHidden:1];
    
    //バックグラウンド時の対応
    if (&UIApplicationDidEnterBackgroundNotification) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(appDidEnterBackground:)
         name:UIApplicationDidEnterBackgroundNotification
         object:[UIApplication sharedApplication]];
    }
    
    //フォアグラウンド時の対応
    if (&UIApplicationWillEnterForegroundNotification) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(appWillEnterForeground:)
         name:UIApplicationWillEnterForegroundNotification
         object:[UIApplication sharedApplication]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
//        [self viewSizeMake:1.0];
    // kAVAudioPlayerManagerから再生終了時に通知を受け取る
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didFinishPlayingAVAudioPlayer)
                                                name:@"AVAudioPlayerDidFinishPlaying"
                                              object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    BOOL purchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_Purchased"];
    // 広告表示フラグ確認
    if (purchased == NO) {
        // インタースティシャル広告表示
        [[kADMOBInterstitialSingleton sharedInstans] interstitialControll];
    }
    self.customUIView.selectedIndexNum = self.tappedIndexPath.row;
    [self.customUIView showMusicHundlerInfo];
    { // 色々サイズ調整してみる
//    [self.customUIView setFrame:CGRectMake(self.customUIView.frame.origin.x, self.customUIView.frame.origin.y, self.customUIView._contentView.frame.size.width, 20)];
//    [self.customUIView.viewHaveLabel setFrame:CGRectMake(self.customUIView.viewHaveLabel.frame.origin.x, self.customUIView.viewHaveLabel.frame.origin.y, 100, 20)];
//    [self.customUIView._contentView sizeToFit];
//    [self.customUIView sizeToFit];
   
        NSLog(@"customUIView.contentView.bounds.size.width:%.2f",self.customUIView._contentView.bounds.size.width);
        NSLog(@"self.customUIView.viewHaveLabel.bounds.size.width:%.2f",self.customUIView.viewHaveLabel.bounds.size.width);
        NSLog(@"self.customUIView.labelMusicHundlerInfo.bounds.size.width:%.2f",self.customUIView.labelMusicHundlerInfo.bounds.size.width);
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
                 self.constraintsCustomUIViewWidth_iPhone.constant = self.customUIView._contentView.bounds.size.width - self.customUIView.viewHaveLabel.bounds.size.width + self.customUIView.labelMusicHundlerInfo.bounds.size.width;
            if (self.constraintsCustomUIViewWidth_iPhone.constant >= 200) {
                self.constraintsCustomUIViewWidth_iPhone.constant = 200;
            }
        }
        else{
            NSLog(@"iPadの処理");
                 self.constraintsCustomUIViewWidth_iPad.constant = self.customUIView._contentView.bounds.size.width - self.customUIView.viewHaveLabel.bounds.size.width + self.customUIView.labelMusicHundlerInfo.bounds.size.width;
            if (self.constraintsCustomUIViewWidth_iPad.constant >= 360) {
                self.constraintsCustomUIViewWidth_iPad.constant = 360;
            }
        }

     }
    [NSObject slideInUIViewToCenter:self.customUIView];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(didFinishPlayingMPMusicPlayerController)
                                                   name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                 object:self.customUIView._mpMusicPlayer];
    [self.customUIView._mpMusicPlayer beginGeneratingPlaybackNotifications];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // ナビゲーションバー非表示
    [self.customUIView stopMusicPlayer];


}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"PVCviewDidDisappear");
        [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)didFinishPlayingAVAudioPlayer{
    [self.customUIView stopMusicPlayer];
}

- (void)didFinishPlayingMPMusicPlayerController{
    NSLog(@"didFinishPlayingMPMusicPlayer");
    if (self.customUIView._mpMusicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        NSLog(@"MPMStateStopped");
        [self.customUIView stopMusicPlayer];
        [_customUIView.layer removeAllAnimations];
    }
}

//- (void)viewSizeMake:(CGFloat)scale{
//    // スクリーンサイズを取得
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
//    // popoverするサイズを決定
//    CGSize popoverSize = CGSizeMake(screenRect.size.width*scale, screenRect.size.height*scale); // size of view in popover
//    // popoverするサイズを設定
//    self.preferredContentSize = popoverSize;
//    self.modalInPopover = YES;
//    
//    UIImage *image = _selectedImage; // 遷移元のビューから渡された画像をセット
//    // imageviewのpreviewImageViewに画像を設定
//    [self.previewImageView setImage:[self popoverWithImage:image screenSize:screenSize popoverScale:scale]];
//    
//    // previewImageViewの位置とサイズを親ビューに合わせる
//    [self.previewImageView setFrame:CGRectMake(0, 0,popoverSize.width, popoverSize.height)];
//    
//    //    NSLog(@"popoverSize (%.1f,%.1f)", popoverSize.width,popoverSize.height);
//    //    NSLog(@"self.view.frame (%.1f,%.1f,%.1f,%.1f)", self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
//    //    NSLog(@"previewImageView.frame (%.1f,%.1f,%.1f,%.1f)", self.previewImageView.frame.origin.x,self.previewImageView.frame.origin.y,self.previewImageView.frame.size.width,self.previewImageView.frame.size.height);
//}

//// 縦横長い方に合わせて縮小する
//-(UIImage *)popoverWithImage:(UIImage *)image screenSize:(CGSize)size popoverScale:(CGFloat)scale{
//    // ビューとイメージの比率を計算する
//    CGFloat widthRatio  = size.width  / image.size.width;
//    CGFloat heightRatio = size.height / image.size.height;
//    // (widthRatio < heightRatio)が真なら ratio = widthRatio/ 偽ならratio = heightRatio
//    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
//    
//    NSLog(@"widthRatio:%.2f",widthRatio);
//    NSLog(@"heightRatio:%.2f",heightRatio);
//    NSLog(@"ratio:%.2f",ratio);
//    CGRect rect;
//    if (ratio > 1.0) {
//        rect = CGRectMake(0, 0,
//                          image.size.width  / ratio,
//                          image.size.height / ratio);
//    } else{
//        rect = CGRectMake(0,0,image.size.width * scale, image.size.height * scale);
//    }
//    
//    
//    UIGraphicsBeginImageContext(rect.size);
//    
//    [image drawInRect:rect];
//    
//    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    NSLog(@"rect.size (%.2f,%.2f)", rect.size.width,rect.size.height);
//    return shrinkedImage;
//}

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
- (IBAction)selectMusic:(UIBarButtonItem *)sender {
    // ミュージック選択VCを開く
    kBISelectMusicViewController *selectMusicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectMusicVC"];
    selectMusicVC.tappedIndexPath = self.tappedIndexPath;
    [self presentViewController:selectMusicVC animated:YES completion:nil];
}

- (IBAction)removeItemBtn:(UIBarButtonItem *)sender {
    
    
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"RemoveThisImage?", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"RemoveThisImageFromThisApp.", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"RemoveThisImage", nil)];
    NSString *action2 = [[NSString alloc] initWithFormat:NSLocalizedString(@"Cancel", nil)];
    
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // アクションコントローラー生成
        UIAlertController *actionController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:action1
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               // 最初の画面にBackFromPreviewVCRemoveItemBtnで戻ると削除メソッドが動く
                                                               [self performSegueWithIdentifier:@"BackFromTappedImageVCRemoveItemBtn" sender:self];
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:action2
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
    }else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = title;
        [actionSheet addButtonWithTitle:action1];
        [actionSheet addButtonWithTitle:action2];
        actionSheet.cancelButtonIndex = 1;
        
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
            // アクションシートを表示
            [actionSheet showInView:self.view.superview]; // self.view.superviewにしないとずれる
        }
        else{
            NSLog(@"iPadの処理");
            // アクションシートをpopoverで表示
            UIBarButtonItem *btn = sender;
            [actionSheet showFromBarButtonItem:btn animated:YES];
        }
    }
}

- (void)actionSetImage:(UIBarButtonItem *)barBtn UIBtn:(UIButton *)uiBtn{
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"SetThisImage?", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"SetThisImage", nil)];
    NSString *action2 = [[NSString alloc] initWithFormat:NSLocalizedString(@"Cancel", nil)];
    
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
    // アクションコントローラー生成
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:title
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    [actionController addAction:[UIAlertAction actionWithTitle:action1
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self performSegueWithIdentifier:@"BackFromTappedImageVCSetImageBtn" sender:self];
                                                       }]];
    [actionController addAction:[UIAlertAction actionWithTitle:action2
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
        if (barBtn == nil) {
            actionController.popoverPresentationController.sourceView = self.view;
            actionController.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
            [actionController.popoverPresentationController setPermittedArrowDirections:0];
            [self presentViewController:actionController animated:YES completion:nil];
        }else{
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:actionController];
            [popover presentPopoverFromBarButtonItem:barBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    }else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = title;
        [actionSheet addButtonWithTitle:action1];
        [actionSheet addButtonWithTitle:action2];
        actionSheet.cancelButtonIndex = 1;
        
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
            // アクションシートを表示
            [actionSheet showInView:self.view.superview]; // self.view.superviewにしないとずれる
        }
        else{
            NSLog(@"iPadの処理");
            // アクションシートをpopoverで表示
            UIBarButtonItem *btn = barBtn;
            [actionSheet showFromBarButtonItem:btn animated:YES];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"SetThisImage", nil)]]) {
        [self performSegueWithIdentifier:@"BackFromTappedImageVCSetImageBtn" sender:self];
    } else if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"RemoveThisImage", nil)]]){
        [self performSegueWithIdentifier:@"BackFromTappedImageVCRemoveItemBtn" sender:self];
    }
}

- (IBAction)setImageBtn:(UIBarButtonItem *)sender {
    [self actionSetImage:sender UIBtn:nil];
    
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


- (IBAction)btnCoverAllDisplay:(UIButton *)sender {
    [self actionSetImage:nil UIBtn:sender];
    
//    if (!_navigationBar.hidden) {
//        [NSObject animationHideNavBar:_navigationBar ToolBar:_toolBar kView:_kUIViewMiniPlayerWrapper];
//    }else{
//        [NSObject animationAppearNavBar:_navigationBar ToolBar:_toolBar kView:_kUIViewMiniPlayerWrapper];
//    }
}

#pragma mark -
#pragma mark Gesture
-(void)backGesture:(UIPanGestureRecognizer *)sender{
    CGPoint transition = [sender translationInView:sender.view];
    if (60 < transition.x) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.view removeGestureRecognizer:sender];
    }
    
}

#pragma -mark notificationRecieveMethod
- (void)appDidEnterBackground:(NSNotification *)notification{
    NSLog(@"Preview_appDidEnterBackground");
    if (self.customUIView._mpMusicPlayerIsPlaying) {
            NSLog(@"Preview)playbackState:%d",(int)self.customUIView._mpMusicPlayer.playbackState);
        if (self.customUIView._mpMusicPlayer.playbackState == 1) { //     MPMusicPlaybackStatePlaying
            [self.customUIView._mpMusicPlayer pause];
        }
    }
}

- (void)appWillEnterForeground:(NSNotification *)notification{
    NSLog(@"Preview_appWillEnterForeground");
    if (self.customUIView._mpMusicPlayerIsPlaying) {
            NSLog(@"Preview)playbackState:%d",(int)self.customUIView._mpMusicPlayer.playbackState);
        if (self.customUIView._mpMusicPlayer.playbackState == 2) { //     MPMusicPlaybackStatePaused
            [self.customUIView._mpMusicPlayer play];
        }
    }
}


//スクリーンショット撮影用
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}


@end
