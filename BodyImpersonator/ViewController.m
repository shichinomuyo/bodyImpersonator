//
//  ViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ViewController.h"
#import "secondVC.h"

@interface ViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *_rollPlayerTmp;
    AVAudioPlayer *_rollPlayerAlt;
    AVAudioPlayer *_crashPlayer;
    ImageViewCircle *greenCircle;
    ImageViewCircle *redCircle;
    // タイマー
    NSTimer *_playTimer; // AVAudioPlayerコントロール用
    // アニメーションタイマー
    NSTimer *_rippleAnimationTimer; // rippleアニメーションコントロール用
    NSTimer *_ctrlBtnAnimationTimer; // ctrlBtnアニメーションコントロール用
    NSTimer *_animationWaitTimer; // 拡大/縮小アニメーション終了待ちタイマー
    NSTimer *_flashAnimationTimer; // flashAnimation用タイマー
    
    // 【アニメーション】ロール再生中のコマを入れる配列
    NSArray *animationSeq;
    
    UIImagePickerController *_imagePicker;
    UIPopoverController *_imagePopController;
}

@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectedPhotoImage; // ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備


@property (weak, nonatomic) IBOutlet UIImageView *imgLightL;

- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender;
- (IBAction)touchDownCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragExitCtrlBtn:(UIButton *)sender;
- (IBAction)touchDragEnterCtrlBtn:(UIButton *)sender;

- (IBAction)touchDownBackgroundBtn:(UIButton *)sender;
- (IBAction)touchUpInsideBackgroundBtn:(UIButton *)sender;
- (IBAction)previewSelectedImageBtn:(UIBarButtonItem *)sender;

- (IBAction)selectPhoto:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UIToolbar *toolBar; // hiddenプロパティを弄るために宣言

// previewImageViewの表示をコントールするために宣言
@property (weak, nonatomic) IBOutlet UIButton *previewImageControllBtn;
- (IBAction)previewImageControllBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIView *nestView;

@end
#pragma mark -
@implementation ViewController
#pragma mark audioControlls
+ (void) initialize{
    // 初回起動時の初期データ
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setObject:@"0" forKey:@"KEY_countUpCrashPlayed"]; //　crash再生回数
    [appDefaults setObject:@"NO" forKey:@"KEY_ADMOBinterstitialRecieved"]; // インタースティシャル広告受信状況
    NSData *defaultImageData = UIImagePNGRepresentation([UIImage imageNamed:@"41tSp5ic8NL.jpg"]);
    [appDefaults setObject:defaultImageData forKey:@"KEY_selectedPhotoImage"];
    // ユーザーデフォルトの初期値に設定する
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:defaultImageData forKey:@"KEY_selectedPhotoImage"];
    [userDefaults registerDefaults:appDefaults];
    
}

- (void)initializeAVAudioPlayers{
    // (audioplayer)再生する効果音のパスを取得する
    // ロールtmp
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // ロールalt
    _rollPlayerAlt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash13" ofType:@"mp3"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    
    // プレイヤーを準備
    [_rollPlayerTmp prepareToPlay];
    [_rollPlayerAlt prepareToPlay];
    [_crashPlayer prepareToPlay];
}

// タイマー生成
- (void)playerControll{
    // playerControllをrollPlayerTmp.duration - 2秒の間隔で呼び出すタイマーを作る
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:((float)_rollPlayerTmp.duration - 2.0f)
                                                  target:self
                                                selector:@selector(playerControllTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

// _playTimerから呼び出すメソッドでプレイヤーの交換、フェードイン・アウトをコントロール
- (void)playerControllTimer{
    NSTimer *timer;
    // playerの開始位置を以下で　2.0にしているためdurfation -3 にしないと、pleyerが再生完了してしまう
    if (_rollPlayerTmp.playing) {
        // altを代替プレイヤーとして再生
        [_rollPlayerAlt startAltPlayerSetStartTime:1.0 setVolume:0.4];
        
        // クロスフェード処理
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(crossFadePlayerTmpToAlt:)
                                               userInfo:nil
                                                repeats:YES];
    } else if(_rollPlayerAlt.playing) {
        // tmpを代替プレイヤーとして再生
        [_rollPlayerTmp startAltPlayerSetStartTime:1.0 setVolume:0.4];
        
        // クロスフェード処理
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(crossFadePlayerAltToTmp:)
                                               userInfo:nil
                                                repeats:YES];
    }
}

// 2つのロールプレイヤーをtmp→altへクロスフェードさせるメソッド
- (void)crossFadePlayerTmpToAlt:(NSTimer *)timer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    _rollPlayerTmp.volume = _rollPlayerTmp.volume - 0.1;
    _rollPlayerAlt.volume = _rollPlayerAlt.volume + 0.1;
    
    NSLog(@"tmp.volume %.2f",_rollPlayerTmp.volume);
    NSLog(@"alt.volume %.2f",_rollPlayerAlt.volume);
    
    if ((int)_rollPlayerAlt.volume == 1) {
        [timer invalidate];
        // tmpPlayerの再生を止めてcurrentTimeを0.0にセット
        [_rollPlayerTmp stopPlayer];
    }
}

// 2つのロールプレイヤーをalt→tmpへクロスフェードさせるメソッド
- (void)crossFadePlayerAltToTmp:(NSTimer *)timer{
    // tmpPlayerとaltPlayerのボリュームを0.1ずつ上げ下げ
    _rollPlayerTmp.volume = _rollPlayerTmp.volume + 0.1;
    _rollPlayerAlt.volume = _rollPlayerAlt.volume - 0.1;
    
    NSLog(@"tmp.volume %.2f",_rollPlayerTmp.volume);
    NSLog(@"alt.volume %.2f",_rollPlayerAlt.volume);
    
    if ((int)_rollPlayerTmp.volume == 1) {
        [timer invalidate];
        // altPlayerの再生を止めてcurrentTimeを0.0にセット
        [_rollPlayerAlt stopPlayer];
    }
}


#pragma mark rippleSetUp
- (void) greenRippleSetUp{
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // ストロークカラーを緑に設定
        UIColor *color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        CGFloat lineWidth = 2.5f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 0.95; //224
        // インスタンスを生成
        greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    else{
        NSLog(@"iPadの処理");
        // ストロークカラーを緑に設定
        UIColor *color = [UIColor colorWithRed:0.20 green:0.80 blue:0.40 alpha:1.0]; // EMERALD
        // ストロークの太さを設定
        CGFloat lineWidth = 10.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 0.95; // 448
        // インスタンスを生成
        greenCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    
    
    [greenCircle setImage:[greenCircle imageFillEllipseInRect]];
    
    // イメージビューのセンターをctrlAudioPlayerBtn.centerと合わせる
    [greenCircle setCenter:self.ctrlBtn.center];
    // アニメーション再生まで隠しておく
    [greenCircle setHidden:1];
}

- (void)redRippleSetUp{
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor colorWithRed:0.80 green:0.20 blue:0.00 alpha:1]; // ALIZARIN
        // ストロークの太さを設定
        CGFloat lineWidth = 2.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 1.2; // 286
        // インスタンスを生成
        redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
        
    }
    else{
        NSLog(@"iPadの処理");
        // ストロークカラーを赤に設定
        UIColor *color = [UIColor colorWithRed:0.80 green:0.20 blue:0.00 alpha:1]; // ALIZARIN
        // ストロークの太さを設定
        CGFloat lineWidth = 10.0f;
        // 半径を設定
        CGFloat radius = (int)self.ctrlBtn.bounds.size.width * 1.2;// 542
        // インスタンスを生成
        redCircle = [[ImageViewCircle alloc] initWithFrame:CGRectMake(0, 0, radius, radius) withColor:color withLineWidth:lineWidth];
    }
    
    
    
    [redCircle setImage:[redCircle imageFillEllipseInRect]];
    
    // 円をctrlBtn.centerと合わせる
    [redCircle setCenter:self.ctrlBtn.center];
    // ImageViewCircleをアニメーション開始までhiddenにする
    [redCircle setHidden:1];
}

- (void) ctrlBtnGrennRippleAnimationStart{
    // サークルアニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    // ctrlBtnの画像をnilに設定
    self.ctrlBtn.imageView.image = nil;
    
    
    // 円とctrlBtnのふわふわアニメーション
    // 【アニメーション】円の拡大アニメーションを3.0秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                             target:greenCircle
                                                           selector:@selector(rippleAnimation)
                                                           userInfo:nil
                                                            repeats:YES];
    _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                              target:self.ctrlBtn
                                                            selector:@selector(scaleUpBtn)
                                                            userInfo:nil
                                                             repeats:YES];
    
}

- (void) ctrlBtnRedRippleAnimationStart:(NSTimer *)timer{
    
    
    
    // 【アニメーション】円の縮小アニメーションを0.6秒間隔で呼び出すタイマーを作る
    _rippleAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                             target:redCircle
                                                           selector:@selector(rippleAnimationReverse)
                                                           userInfo:nil
                                                            repeats:YES];
    _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                              target:self.ctrlBtn
                                                            selector:@selector(scaleDownBtn)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [timer invalidate];
    
}

// ctrlBtnのハイライトアニメーション
- (void)ctrlBtnHighlightedAnimationStart {
    [self.ctrlBtn setEnabled:0];
    
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // ここにctrlBtnのぷるぷるアニメーション（強)を書く
        [self.ctrlBtn highlightedAnimation];
        _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                                  target:self.ctrlBtn
                                                                selector:@selector(strongVibeAnimationKeepTransform)
                                                                userInfo:nil
                                                                 repeats:YES];
    } else{
        // ここにctrlBtnのぷるぷるアニメーション(弱)を書く
        [self.ctrlBtn highlightedAnimation];
        // ぷるぷるアニメーション(弱)はやめた
        //        _ctrlBtnAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f
        //                                                                  target:self.ctrlBtn
        //                                                                selector:@selector(vibeAnimationKeepTransform)
        //                                                                userInfo:nil
        //                                                                 repeats:YES];
    }
}

// アニメーションタイマーをまとめて破棄
- (void)animationTimerInvalidate {
    
    
    // ctrl、rippleアニメーションタイマー破棄
    if (_ctrlBtnAnimationTimer != nil) {
        [_ctrlBtnAnimationTimer invalidate];
    }
    if (_rippleAnimationTimer != nil) {
        [_rippleAnimationTimer invalidate];
    }
    if (_animationWaitTimer != nil) {
        [_animationWaitTimer invalidate];
    }
    if (_flashAnimationTimer != nil) {
        [_flashAnimationTimer invalidate];
    }
}

- (void)viewAdBanners{
    //    // 【Ad】サイズを指定してAdMobインスタンスを生成
    //    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    //
    //    // 【Ad】AdMobのパブリッシャーIDを指定
    //    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    //
    //
    //    // 【Ad】AdMob広告を表示するViewController(自分自身)を指定し、ビューに広告を追加
    //    bannerView_.rootViewController = self;
    //    [self.view addSubview:bannerView_];
    //
    //    // ビューの一番下に表示
    //    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - bannerView_.bounds.size.height/2)];
    //
    //    // 【Ad】AdMob広告データの読み込みを要求
    //    [bannerView_ loadRequest:[GADRequest request]];
    //    // AdMobバナーの回転時のautosize
    //    bannerView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //
    //    // 【Ad】インタースティシャル広告の表示
    //    interstitial_ = [[GADInterstitial alloc] init];
    //    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    //    interstitial_.delegate = self;
    //    [interstitial_ loadRequest:[GADRequest request]];
    //
    //    //NADViewの作成
    //
    //
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //        NSLog(@"iPhoneの処理");
    //        self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    //        [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
    //        // (3) ログ出力の指定
    //        [self.nadView setIsOutputLog:YES];
    //        // (4) set apiKey, spotId.
    //        //        [self.nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"]; // テスト用
    //        [self.nadView setNendID:@"139154ca4d546a7370695f0ba43c9520730f9703" spotID:@"208229"];
    //
    //    }
    //    else{
    //        NSLog(@"iPadの処理");
    //        self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
    //        [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)]; // ヘッダー
    //        // (3) ログ出力の指定
    //        [self.nadView setIsOutputLog:NO];
    //        // (4) set apiKey, spotId.
    //        //      [self.nadView setNendID:@"2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a" spotID:@"70999"]; // テスト用
    //        [self.nadView setNendID:@"19d17a40ad277a000f27111f286dc6aaa0ad146b" spotID:@"220604"];
    //
    //    }
    //    [self.nadView setDelegate:self]; //(5)
    //    [self.nadView load]; //(6)
    //    [self.view addSubview:self.nadView]; // 最初から表示する場合
}

#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    
    // 広告表示
    //    [self viewAdBanners];
    
    
    // (audioplayer)再生する効果音のパスを取得しインスタンス生成
    [self initializeAVAudioPlayers];
    
    //    // 【アニメーション】ロール再生中の各コマのイメージを配列に入れる
    //    animationSeq = @[[UIImage imageNamed:@"hitR2.png"],
    //                     [UIImage imageNamed:@"hitR1.png"],
    //                     [UIImage imageNamed:@"hitR2.png"],
    //
    //                     [UIImage imageNamed:@"hitL2.png"],
    //                     [UIImage imageNamed:@"hitL1.png"],
    //                     [UIImage imageNamed:@"hitL2.png"]
    //
    //                     ];
    
    
    //    // ボタンのイメージビューにアニメーションの配列を設定する
    //    self.ctrlBtn.imageView.animationImages = animationSeq;
    //    // アニメーションの長さを設定する
    //    self.ctrlBtn.imageView.animationDuration = 1.2;//1.35
    //    // 無限の繰り返し回数
    //    self.ctrlBtn.imageView.animationRepeatCount = 0;
    
    
    
    // ctrlBtnを起動時だけ回転拡大で出現するために隠す
    //    [self.ctrlBtn setAlpha:0];
    //    [self.ctrlBtn setHidden:0];
    //    [self.ctrlBtn setEnabled:0];
    [self.selectedPhotoImage setHidden:1];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    // 画面が隠れたらNend定期ロード中断
    [self.nadView pause];
}


- (void)viewWillAppear:(BOOL)animated{
    // 画面が表示されたら定期ロード再開
    [self.nadView resume];
}

// ビューが表示されたときに実行される
- (void)viewDidAppear:(BOOL)animated
{
    
    [self animationTimerInvalidate];
    
    // 再生回数が3の倍数かつインタースティシャル広告の準備ができていればインタースティシャル広告表示
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger i = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
    BOOL b = [defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"];
    NSLog(@"countUpCrashPlayed %ld", (long)i);
    
    if (b == NO) {
        [self interstitialLoad];
    }
    
    if (((i % 5) == 0) && (b == YES)) {
        [interstitial_ presentFromRootViewController:self];
    }
    
}

- (void)dealloc{
    // AdMobBannerviewの開放
    bannerView_ = nil;
    // nendの開放
    [self.nadView setDelegate:nil];//delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease,nilをセット
    // AdMobinterstitialの開放　これをしないと再ロードできない
    [interstitial_ setDelegate:nil];
    interstitial_ = nil; //
    // [super dealloc]; // MRC(非アーク時には必要)
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appDidEnterBackground:(NSNotification *)notification{
    [_rollPlayerTmp stop];
    [_rollPlayerAlt stop];
    [_crashPlayer stop];
    
    [_playTimer invalidate];
    [self animationTimerInvalidate];
    
}

- (void)appWillEnterForeground:(NSNotification *)notification{
    [self viewDidAppear:1];
}

#pragma mark -
#pragma mark touchAction
// ctrlBtnのtouchUpInside時に実行される処理を実装
- (IBAction)touchUpInsideCtrlBtn:(UIButton *)sender {

        if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
            // ドラムロール再生中にctrlBtnが押されたときクラッシュ再生
            
            // crash再生する度に再生回数を+1してNSUserDefaultsに保存
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSInteger i = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
            i = i +1;
            [defaults setInteger:i forKey:@"KEY_countUpCrashPlayed"];
            [defaults synchronize];
            
            // ドラムロールを止めcrash再生
            [_crashPlayer playCrashStopRolls:_rollPlayerTmp :_rollPlayerAlt];
            
            // プレイヤータイマーを破棄する
            [_playTimer invalidate];
            
            // アニメーションタイマーを破棄する
            [self animationTimerInvalidate];
            
            // viewのバックグラウンドカラーを白にする
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.view.backgroundColor = [UIColor whiteColor];
                                 
                                 // ctrlBtnのテキストの中身を書く
                                 [self.ctrlBtn setTitle:@"Tap or Shake to Start!" forState:UIControlStateNormal];
                                 
                             } completion:nil];
            
            
            // touchDown時のtransformとdisabelにしたのを戻す
            [self.ctrlBtn clearTransformBtnSetEnable];
            [self.ctrlBtn setHidden:1];  // selectedPhotoImageをそのまま拡大アニメーションすると拡大されすぎる問題があったのでctrlBtn.aphaを0にする。hiddenにするとviewDidAppearでの拡大アニメーションが再生されてしまう問題あり
            
            // selectedPhotoImageの画像が回転しながら大きくなってくるアニメーション
            [self.selectedPhotoImage appearWithScaleUp]; // (1.09sec)ctrlBtnをそのまま同様のアニメーションをさせると、ctrlBtnをギュンギュンアニメーションさせている都合で、タイミングによって結果がとても大きくなることがあるため、本イメージビューをアニメーション用として準備
            // backgroundBtnを表示しタップ可能にする
            [self.backgroundBtn setHidden:0];
            
            
        } else {
            // ドラムロール停止中にctrlBtnが押されたとき
            
            // ドラムロールを再生する
            [_rollPlayerTmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayerAlt ];
            // playerControllを一定間隔で呼び出すタイマーを作る
            [self playerControll];
            
            // アニメーションタイマーを破棄する
            [self animationTimerInvalidate];
            
            // toolBarを非表示にする
            [self.toolBar setHidden:1];
            
            // touchDown時のtransformとdisabelにしたのを戻す
            [self.ctrlBtn clearTransformBtnSetEnable];
            
            // 画像が表示されるまでctrlBtnのテキストを隠す
            [self.ctrlBtn setTitle:nil forState:UIControlStateNormal];
            
            // viewのバックグラウンドカラーをmidnightblueにする
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.view.backgroundColor = [UIColor blackColor];// midnightblue [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0];
                             } completion:nil];
            
            // flashAnimation開始
            _flashAnimationTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.9f
                                             target:self.imgLightL
                                           selector:@selector(flashAnimation)
                                           userInfo:nil
                                            repeats:YES];
            
        }
    
}


/* ctrlBtnのハイライト処理 */
// タッチしたとき
- (IBAction)touchDownCtrlBtn:(UIButton *)sender {
    [_ctrlBtnAnimationTimer invalidate];
    [self ctrlBtnHighlightedAnimationStart]; // プルプルアニメーション
    
}
// ドラッグして外に出たとき
- (IBAction)touchDragExitCtrlBtn:(UIButton *)sender {
    [self.ctrlBtn clearTransformBtnSetEnable];
    if (_rollPlayerTmp.isPlaying || _rollPlayerAlt.isPlaying) {
        // あかを復活
        [self ctrlBtnRedRippleAnimationStart:nil];
    } else{
        // みどりをふっかつ
        [self ctrlBtnGrennRippleAnimationStart];
    }
}
// ドラッグして中に入ったとき
- (IBAction)touchDragEnterCtrlBtn:(UIButton *)sender {
    [_ctrlBtnAnimationTimer invalidate];
    [self ctrlBtnHighlightedAnimationStart];
    
}



- (IBAction)touchDownBackgroundBtn:(UIButton *)sender {
    [_crashPlayer stopPlayer];
    
}

- (IBAction)touchUpInsideBackgroundBtn:(UIButton *)sender {
    // 最初の画面に戻す
    if (self.selectedPhotoImage.hidden == NO) {
        [self.selectedPhotoImage setHidden:1];
        [self.backgroundBtn setHidden:1];
        [self.ctrlBtn setHidden:0];
        [self.toolBar setHidden:0];
        [self viewDidAppear:1];
        
        
    }
}

- (IBAction)previewSelectedImageBtn:(UIBarButtonItem *)sender {
    if (self.nestView.hidden) {
        
        // NSUserDefaultsから画像を取得
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // NSDataとして情報を取得
        NSData *imageData = [defaults objectForKey:@"KEY_selectedImage"];
        // NSDataからUIImageを作成
        UIImage *selectedImage = [UIImage imageWithData:imageData];
        CGSize finalSize;

        finalSize = CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height/2);

        [self.nestView setFrame:CGRectMake(self.view.center.x-5, self.view.center.y-50, self.view.frame.size.width/2, self.view.frame.size.height/2)];
        // imageviewのpreviewImageに画像を設定
//        [self.previewImage setFrame:CGRectMake(self.view.center.x-5, self.view.center.y-50, self.view.frame.size.width/2, self.view.frame.size.height/2)];
        
        [self.previewImage setImage:[self imageWithImage:selectedImage CovertToSize:finalSize]];
        self.nestView.layer.borderWidth = 2.0f;
        self.nestView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.nestView setHidden:0];
        [self.previewImageControllBtn setHidden:0];
    } else{
        [self.nestView setHidden:1];
        [self.previewImageControllBtn setHidden:1];
    }
}

// previewImageの表示を消す
- (IBAction)previewImageControllBtn:(UIButton *)sender {
    [self.nestView setHidden:1];
    [self.previewImageControllBtn setHidden:1];
}

#pragma mark -
#pragma mark imagePickerController

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"BackToFirstViewFromLastViewSegue"]) {
        // ここに必要な処理を記述
        [_imagePicker dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Back to first from last.");
    }
    
    NSLog(@"First view return action invoked.");
}

// 写真を選ぶメソッド
- (IBAction)selectPhoto:(UIBarButtonItem *)sender {
    // イメージピッカーコントローラを初期化する
    // フォトライブラリを利用できるかどうかチェックする
    if(([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])){
        // イメージピッカーコントローラを作る
        _imagePicker = [[UIImagePickerController alloc] init];
        
        // UIImagePickerのデリゲートになる
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
        
        // フォトライブラリから画像を取り込む設定にする
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
            // フォトライブラリから画像を選ぶ
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
        else{
            NSLog(@"iPadの処理");
            // Popoverの確認・開かれている場合は一度閉じる
            if (_imagePopController) {
                if ([_imagePopController isPopoverVisible]) {
                    [_imagePopController dismissPopoverAnimated:YES];
                }
            }
            
            // popoverを開く
            UIBarButtonItem *btn = sender;
            //            imagePicker.preferredContentSize = CGSizeMake(768, 1024);
            _imagePopController = [[UIPopoverController alloc] initWithContentViewController:_imagePicker];
            
            // popoverをバーボタンから表示
            [_imagePopController presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    }
    
}

// chooseボタンのデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //   NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //    UIImage *imageEdited = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *imagePicked = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    CGRect cropRect;
    cropRect = [[info valueForKey:@"UIImagePickerControllerCropRect"] CGRectValue];
    
    NSLog(@"Original width = %f height= %f ",imagePicked.size.width, imagePicked.size.height);
    //Original width = 1440.000000 height= 1920.000000
    
    //    NSLog(@"imageEdited width = %f height = %f",imageEdited.size.width, imageEdited.size.height);
    //imageEdited width = 640.000000 height = 640.000000
    
    NSLog(@"corpRect %@", NSStringFromCGRect(cropRect));
    //corpRect 80.000000 216.000000 1280.000000 1280.000000
    
    CGSize finalSize;
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        finalSize = CGSizeMake(320, 768);
    }
    else{
        NSLog(@"iPadの処理");
        finalSize = CGSizeMake(768, 1024);
    }
    
    // selectedPhotoImageに画像を設定
    [self.selectedPhotoImage setImage:[self imageWithImage:imagePicked CovertToSize:finalSize]];
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"Edit image?"
                                            message:@"Message"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Show editor"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               // Show editro タップ時の処理
                                                               [self action1];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Use this Image"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               // Use this Image タップ時の処理
                                                               [self action2];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // Cancel タップ時の処理
                                                           }]];
        // アクションコントローラーを表示
        [picker presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = @"Edit Image?";
        [actionSheet addButtonWithTitle:@"Show Editor"];
        [actionSheet addButtonWithTitle:@"Use this image"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        //        actionSheet.destructiveButtonIndex = 0;
        actionSheet.cancelButtonIndex = 2;
        // アクションシートを表示
        [actionSheet showInView:picker.view];
        
    }
    
    
    //    self.selectedPhotoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //    UIImage *finalImage =  [self cropImage:imagePicked cropRect:cropRect aspectFitBounds:finalSize fillColor:[UIColor grayColor]];
    //
    //    [self.selectedPhotoImage setImage:finalImage];
    
    // ここからが上記メソッドの内容と大方かぶる
    //    CGImageRef imagePickedRef = imagePicked.CGImage;
    //
    //    CGRect transformedRect = transformCGRectForUIImageOrientation(cropRect, imagePicked.imageOrientation, imagePicked.size);
    //    CGImageRef cropRectImage = CGImageCreateWithImageInRect(imagePickedRef, transformedRect);
    //    CGColorSpaceRef colorspace = CGImageGetColorSpace(imagePickedRef);
    //    CGContextRef context = CGBitmapContextCreate(NULL,
    //                                                 finalSize.width,
    //                                                 finalSize.height,
    //                                                 CGImageGetBitsPerComponent(imagePickedRef),
    //                                                 CGImageGetBytesPerRow(imagePickedRef),
    //                                                 colorspace,
    //                                                 CGImageGetAlphaInfo(imagePickedRef));
    //
    //    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    //    CGContextDrawImage(context, CGRectMake(0, 0, finalSize.width, finalSize.height), cropRectImage);
    //    CGImageRelease(cropRectImage);
    //
    //    CGImageRef instaImage = CGBitmapContextCreateImage(context);
    //
    //    CGContextRelease(context);
    //
    //    //assign the image to an UIImage Control
    //    UIImage *image = [UIImage imageWithCGImage:instaImage scale:imagePicked.scale orientation:imagePicked.imageOrientation];
    //    self.selectedPhotoImage.contentMode = UIViewContentModeScaleAspectFit;
    //    // 編集済みの画像をselectedPhotoImageに設定
    ////       [self.selectedPhotoImage setImage:[info objectForKey:UIImagePickerControllerEditedImage]]; // crop範囲をそのまま表示
    //    [self.selectedPhotoImage setImage:image];
    // ここまでがメソッドとかぶってる内容
    
    
    
    
}

// action1ボタンが押された時の処理
- (void)action1
{
    // Show editor タップ時の処理
    
    // 選択した画像をNSUserDefaultsに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *tmpImage = UIImagePNGRepresentation(self.selectedPhotoImage.image);
    [defaults setObject:tmpImage forKey:@"KEY_tmpImage"];
    [defaults synchronize];
    
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // secondVCを表示
        //        secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
        //        [self dismissViewControllerAnimated:YES completion:^{
        //            [self presentViewController:sVC animated:YES completion:nil];
        //        }];
        
        secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
        [_imagePicker presentViewController:sVC animated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        [_imagePopController dismissPopoverAnimated:YES];
        // secondVCを表示
        secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
        [self presentViewController:sVC animated:YES completion:nil];
    }
}

// action2ボタンが押された時の処理
- (void)action2
{
    // Use this Image タップ時の処理
    
    // 選択した画像をNSUserDefaultsのKEY_editedImageに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *tmpImage = UIImagePNGRepresentation(self.selectedPhotoImage.image);
    [defaults setObject:tmpImage forKey:@"KEY_selectedImage"];
    [defaults synchronize];
    
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // 最初の画面に戻る
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        [_imagePopController dismissPopoverAnimated:YES];
    }
}

// action3ボタンが押された時の処理
- (void)action3
{
    
}
// iOS 7でアクションシートのボタンが押された時の処理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self action1];
            break;
        case 1:
            [self action2];
            break;
        case 2:
            [self action3];
            break;
        default:
            break;
    }
}

// 縦横長い方に合わせて縮小する
-(UIImage *)imageWithImage:(UIImage *)image CovertToSize:(CGSize)size {
    // ビューとイメージの比率を計算する
    CGFloat widthRatio  = size.width  / image.size.width;
    CGFloat heightRatio = size.height / image.size.height;
    // (widthRatio < heightRatio)が真なら ratio = widthRatio/ 偽ならratio = heightRatio
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    //
    if (ratio >= 1.0) {
        return image;
    }
    
    CGRect rect = CGRectMake(0, 0,
                             image.size.width  * ratio,
                             image.size.height * ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return shrinkedImage;
}

// cancelボタンのデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;{
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // 最初の画面に戻る
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        [_imagePopController dismissPopoverAnimated:YES];
    }
}

//CGRect transformCGRectForUIImageOrientation(CGRect source, UIImageOrientation orientation, CGSize imageSize) {
//    switch (orientation) {
//        case UIImageOrientationLeft: { // EXIF #8
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
//            return CGRectApplyAffineTransform(source, txCompound);
//        }
//        case UIImageOrientationDown: { // EXIF #3
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
//            return CGRectApplyAffineTransform(source, txCompound);
//        }
//        case UIImageOrientationRight: { // EXIF #6
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI + M_PI_2);
//            return CGRectApplyAffineTransform(source, txCompound);
//        }
//        case UIImageOrientationUp: // EXIF #1 - do nothing
//        default: // EXIF 2,4,5,7 - ignore
//            return source;
//    }
//}
//
//// CropRect is assumed to be in UIImageOrientationUp, as it is delivered this way from the UIImagePickerController when using AllowsImageEditing is on.
//// The sourceImage can be in any orientation, the crop will be transformed to match
//// The output image bounds define the final size of the image, the image will be scaled to fit,(AspectFit) the bounds, the fill color will be
//// used for areas that are not covered by the scaled image.
//-(UIImage *)cropImage:(UIImage *)sourceImage cropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor {
//
//    CGImageRef sourceImageRef = sourceImage.CGImage;
//
//    //Since the crop rect is in UIImageOrientationUp we need to transform it to match the source image.
//    CGAffineTransform rectTransform = [self transformSize:sourceImage.size orientation:sourceImage.imageOrientation];
//    CGRect transformedRect = CGRectApplyAffineTransform(cropRect, rectTransform);
//
//    //Now we get just the region of the source image that we are interested in.
//    CGImageRef cropRectImage = CGImageCreateWithImageInRect(sourceImageRef, transformedRect);
//
//
//    //Figure out which dimension fits within our final size and calculate the aspect correct rect that will fit in our new bounds
//    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(cropRectImage);
//    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(cropRectImage);
//    CGFloat ratio = MIN(horizontalRatio, verticalRatio); //Aspect Fit
//    CGSize aspectFitSize = CGSizeMake(CGImageGetWidth(cropRectImage) * ratio, CGImageGetHeight(cropRectImage) * ratio);
//
//
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 finalImageSize.width,
//                                                 finalImageSize.height,
//                                                 CGImageGetBitsPerComponent(cropRectImage),
//                                                 0,
//                                                 CGImageGetColorSpace(cropRectImage),
//                                                 CGImageGetBitmapInfo(cropRectImage));
//
//    if (context == NULL) {
//        NSLog(@"NULL CONTEXT!");
//    }
//
//    //Fill with our background color
//    CGContextSetFillColorWithColor(context, fillColor.CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, finalImageSize.width, finalImageSize.height));
//
//    //We need to rotate and transform the context based on the orientation of the source image.
//    CGAffineTransform contextTransform = [self transformSize:finalImageSize orientation:sourceImage.imageOrientation];
//    CGContextConcatCTM(context, contextTransform);
//
//    //Give the context a hint that we want high quality during the scale
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//
//    //Draw our image centered vertically and horizontally in our context.
//    CGContextDrawImage(context, CGRectMake((finalImageSize.width-aspectFitSize.width)/2, (finalImageSize.height-aspectFitSize.height)/2, aspectFitSize.width, aspectFitSize.height), cropRectImage);
////    CGContextDrawImage(context, CGRectMake(0, 0, finalImageSize.width, finalImageSize.height), cropRectImage);
//
//    //Start cleaning up..
//    CGImageRelease(cropRectImage);
//
//    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
//    UIImage *finalImage = [UIImage imageWithCGImage:finalImageRef];
//
//    CGContextRelease(context);
//    CGImageRelease(finalImageRef);
//    return finalImage;
//}
//
////Creates a transform that will correctly rotate and translate for the passed orientation.
////Based on code from niftyBean.com
//- (CGAffineTransform) transformSize:(CGSize)imageSize orientation:(UIImageOrientation)orientation {
//
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    switch (orientation) {
//        case UIImageOrientationLeft: { // EXIF #8
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
//            transform = txCompound;
//            break;
//        }
//        case UIImageOrientationDown: { // EXIF #3
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
//            transform = txCompound;
//            break;
//        }
//        case UIImageOrientationRight: { // EXIF #6
//            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,-M_PI_2);
//            transform = txCompound;
//            break;
//        }
//        case UIImageOrientationUp: // EXIF #1 - do nothing
//        default: // EXIF 2,4,5,7 - ignore
//            break;
//    }
//    return transform;
//
//}




#pragma mark -
#pragma mark motionAction
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    // selectedPhotoImageが非表示(起動時の画面)のときにだけ反応
    if (self.selectedPhotoImage.hidden == 1) {
        // バイブレーションを動作させる
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        // ctrlBtnをtouchUpInsideしたときと同じ処理をする
        [self touchUpInsideCtrlBtn:self.ctrlBtn];
    }
    
    
}

#pragma mark -
#pragma mark interface rotated


// デバイス回転時に広告の表示位置を調整
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}



#pragma mark -
#pragma mark AdMobDelegate
// AdMobバナーのloadrequestが失敗したとき
-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
}

/// AdMobインタースティシャルのloadrequestが失敗したとき
-(void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitial:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    // フラグ更新
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"KEY_ADMOBinterstitialRecieved"];
    [defaults synchronize];
    NSLog(@"adfrag:%d",[defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"]);
}

// AdMobインタースティシャルの再ロード
- (void)interstitialLoad{
    // 【Ad】インタースティシャル広告の表示
    //    interstitial_ = [[GADInterstitial alloc] init];
    //    interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    //    interstitial_.delegate = self;
    //    [interstitial_ loadRequest:[GADRequest request]];
}

#pragma mark nendDelegate
// nend広告受け取ったらここで処理
- (void)nadViewDidReceiveAd:(NADView *)adView{
    
    
}

// スプラッシュ画面を1秒表示する
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ここでスレッドを止める
    [NSThread sleepForTimeInterval:2.0];
    //    sleep(1);
    
    return YES;
}


@end