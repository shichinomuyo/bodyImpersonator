//
//  playVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "playVC.h"

@interface playVC (){
    // オーディオプレイヤー
    AVAudioPlayer *_rollPlayerTmp;
    AVAudioPlayer *_rollPlayerAlt;
    AVAudioPlayer *_crashPlayer;
    AVAudioPlayer *_originalMusicPlayer;
    AVAudioPlayer *_iPodLibMusicPlayer;
    MPMusicPlayerController *_mpMusicPlayer;
    
    BOOL _mpMusicPlayerUsing;
    
    // タイマー
    NSTimer *_playTimer; // AVAudioPlayerコントロール用
    
    // アニメーションタイマー

    NSTimer *_flashAnimationTimer; // flashAnimation用タイマー
    
}


@property (weak, nonatomic) IBOutlet UIImageView *lightEffectImageView;
@property (strong, nonatomic) IBOutlet BugFixContainerView *BFCV; // imageViewを持つ

@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
- (IBAction)stopBtn:(UIButton *)sender;


@end

@implementation playVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // GoogleAnalytics導入のため以下設定
    self.screenName = @"BI_PlayVC";
    // mpMusicPlayerUsingフラグ初期化
    _mpMusicPlayerUsing = NO;
    // ダブルタップジェスチャーを作る
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapImage:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    self.BFCV.userInteractionEnabled = YES;
    [self.BFCV addGestureRecognizer:doubleTapGesture];
    
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
    
    // selectedPhotoImageを非表示に設定
    [self.BFCV.knobImageView setHidden:1];
    [self.BFCV.knobImageView setImage:_selectedImage];
    
    // settingsStateLoad
    self.musicOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_MusicOn"];
    self.crashSoundOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_CrashSoundOn"];
    
    self.flashOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_FlashEffectOn"];
    self.bgColorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_PlayVCBGColor"];
    self.finishPlayingByShakeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_FinishPlayingByShakeOn"];
    self.finishPlayingByDoubleTapOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_FinishPlayingByDoubleTapOn"];
    self.finishPlayingWithVibeOn= [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_FinishPlayingWithVibeOn"];

    NSLog(@"bgColorName:%@",self.bgColorName);
   
    {
        //kBIMusicHundlerから色々取得
        NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
        NSData *data = hundlers[self.selectedIndexPath.row];
        kBIMusicHundlerByImageName *hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
        
        self.rollSoundOn = hundler.rollSoundOn;
        self.originalMusicOn = hundler.originalMusicOn;
        self.iPodLibMusicOn = hundler.iPodLibMusicOn;
    }

    if (self.musicOn) {
         NSLog(@"musicon");
        if (self.rollSoundOn) {
            [self initializeAVAudioPlayers_Roll];
            NSLog(@"rollsoundon");
        }

        if (self.originalMusicOn) {
            [self initializeAVAudioPlayers_OriginalMusic];
            NSLog(@"originalmusicon");
        }
        if (self.iPodLibMusicOn) {
            [self initializeMusicPlayerController];
             NSLog(@"iPODLIBsoundon");
        }
    }
    if (self.crashSoundOn) {
        [self initializeAVAudioPlayers_Crash];
        NSLog(@"crashsoundon");
    }

 

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

#pragma mark AudioControlls
- (void)initializeAVAudioPlayers_Roll{
    // (audioplayer)再生する効果音のパスを取得する
    // ロールtmp
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];

    
    // ロールalt
    _rollPlayerAlt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // プレイヤーを準備
    [_rollPlayerTmp prepareToPlay];
    [_rollPlayerAlt prepareToPlay];
}

- (void)initializeAVAudioPlayers_Crash{
    // クラッシュ
    NSString *path_clash = [[NSBundle mainBundle] pathForResource:@"crash13" ofType:@"mp3"];
    NSURL *url_clash = [NSURL fileURLWithPath:path_clash];
    _crashPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_clash error:NULL];
    // プレイヤーを準備
    [_crashPlayer prepareToPlay];
}

- (void)initializeAVAudioPlayers_OriginalMusic{
    // オリジナルミュージック
    NSString *path_originalMusic = [[NSBundle mainBundle] pathForResource:@"Theme05" ofType:@"mp3"];
    NSURL *url_originalMusic = [NSURL fileURLWithPath:path_originalMusic];
    _originalMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_originalMusic error:NULL];
    _originalMusicPlayer.numberOfLoops = -1;//無限ループ
    // プレイヤーを準備
    [_originalMusicPlayer prepareToPlay];
}

- (void)initializeMusicPlayerController{
    NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSData *data = hundlers[self.selectedIndexPath.row];
    kBIMusicHundlerByImageName *hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    
    NSURL *url = hundler.mediaItemURL;
    if (url) {
        _iPodLibMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        [_iPodLibMusicPlayer prepareToPlay];
    }else{
        _mpMusicPlayerUsing = YES;
        _mpMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        [_mpMusicPlayer setQueueWithItemCollection:hundler.mediaItemCollection];
    }

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

#pragma mark actionControlls
- (IBAction)stopBtn:(UIButton *)sender {
    
        if (_rollPlayerAlt.isPlaying || _rollPlayerTmp.isPlaying) { // ロールが鳴っているとき
            [self stopDrumRollAndPlayCrash]; // ロールを止めてクラッシュを鳴らしアニメーション

        } else if (_originalMusicPlayer.isPlaying){ // ロールが鳴っていなくてオリジナル曲が鳴っているとき
            [_originalMusicPlayer stop];
            [self playCrash]; // クラッシュを鳴らしてアニメーション

        } else if (_iPodLibMusicPlayer.isPlaying) { // 自前のフラグ
            NSLog(@"stopMPM");
            if (!_mpMusicPlayerUsing) {
                [_iPodLibMusicPlayer stop];
            } else{
                [_mpMusicPlayer stop];
            }

            [self playCrash];

        }
        else{ // 音が鳴っていない時
            if (self.BFCV.knobImageView.hidden == 1) {
                [self playCrash]; // ロールがなっていないのでクラッシュだけを鳴らしアニメーション

               
            }else{
                if (!_finishPlayingByDoubleTapOn) {
                    [self performSegueWithIdentifier:@"unwindFromPlayVC" sender:self]; // 最初の画面に戻る
                }
            }
        }
}

- (void)doubleTapImage:(UITapGestureRecognizer *)gesture {
    if (_finishPlayingByDoubleTapOn) {
        [self performSegueWithIdentifier:@"unwindFromPlayVC" sender:self]; // 最初の画面に戻る
    }
}

-(void)stopDrumRollAndPlayCrash{

        // ドラムロール再生中にctrlBtnが押されたときクラッシュ再生
        // ドラムロールを止めcrash再生
        [self playCrashStopRolls:_rollPlayerTmp :_rollPlayerAlt];
        
        // プレイヤータイマーを破棄する
        [_playTimer invalidate];
        
        // アニメーションタイマーを破棄する
        [self animationTimerInvalidate];
        
        // viewのバックグラウンドカラーを白にする
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.BFCV.backgroundColor = [UIColor whiteColor];
                         } completion:nil];

    // 拡大してくるアニメーション
    [self.BFCV.knobImageView appearWithScaleUp];
    if (_finishPlayingByDoubleTapOn) {
        [self.view bringSubviewToFront:self.BFCV];
    }
}

// クラッシュを再生するメソッドを実装
-(void)playCrashStopRolls:(AVAudioPlayer *)rollPlayer_tmp :(AVAudioPlayer *)rollPlayer_alt
{
    // ループしているドラムロールを止める
    [rollPlayer_tmp stop];
    rollPlayer_tmp.currentTime = 0.0;
    [rollPlayer_alt stop];
    rollPlayer_alt.currentTime = 0.0;
    
    if (self.crashSoundOn) {
        // クラッシュを再生する
        [_crashPlayer play];
    }

}

- (void)playCrash{
    if (self.crashSoundOn) { // crashOn
        // クラッシュを再生
        [_crashPlayer play];
    } // crashOff
    
    // アニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    
    // viewのバックグラウンドカラーを白にする
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.BFCV.backgroundColor = [UIColor whiteColor];
                         
                     } completion:nil];
    
    // 拡大してくるアニメーション
    [self.BFCV.knobImageView appearWithScaleUp];
    
    if (_finishPlayingByDoubleTapOn) {
        [self.view bringSubviewToFront:self.BFCV];
    }
    
}


#pragma mark - playStart
-(void)playStart{
    if (self.rollSoundOn) {
            NSLog(@"Drumrollはいってる？？？？");
        // ドラムロールを再生する
        [_rollPlayerTmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayerAlt ];
        // playerControllを一定間隔で呼び出すタイマーを作る
        [self playerControll];
    } else if (self.originalMusicOn){
            NSLog(@"orinalMusicはいってる？？？？");
        [_originalMusicPlayer play];
    } else if (self.iPodLibMusicOn){
        NSLog(@"iPodはいってる？？？？");
        if (!_mpMusicPlayerUsing) {
            [_iPodLibMusicPlayer play];
        }else{
            [_mpMusicPlayer play];
        }

    }

    // アニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    [self setBackgroundColorWithAnimation];
    [self setFlashAnimation];
}

- (void)setBackgroundColorWithAnimation {
    NSString *localizedBlack = [[NSString alloc] initWithFormat:NSLocalizedString(@"Black", nil)];
    NSString *localizedWhite = [[NSString alloc] initWithFormat:NSLocalizedString(@"White", nil)];
    if ([self.bgColorName isEqualToString:localizedBlack]) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.BFCV.backgroundColor = RGB(17, 34, 48);//nearlyBlack
                             NSLog(@"black?");
                         } completion:nil];
    }else if ([self.bgColorName isEqualToString:localizedWhite]){
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.BFCV.backgroundColor = RGB(255, 255, 255);//White
                             NSLog(@"White?");
                         } completion:nil];
    }
}

- (void)setFlashAnimation {
    if (self.flashOn) {
        // flashAnimation開始
        _flashAnimationTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.9f
                                         target:self.lightEffectImageView
                                       selector:@selector(flashAnimation)
                                       userInfo:nil
                                        repeats:YES];
    }
}


#pragma mark -
#pragma mark motionAction
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    // selectedPhotoImageが非表示(起動時の画面)のときにだけ反応
    if (_finishPlayingByShakeOn) {
        if (self.BFCV.knobImageView.hidden == 1) {
            if (_finishPlayingWithVibeOn) {
                // バイブレーションを動作させる
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            if (self.rollSoundOn) {
                [self stopDrumRollAndPlayCrash]; // ドラムロールを止めてクラッシュ再生と画像表示
            } else if (self.originalMusicOn){
                [_originalMusicPlayer stop];
                [self playCrash];
            } else if (self.iPodLibMusicOn){
                if (!_mpMusicPlayerUsing) {
                    [_iPodLibMusicPlayer stop];
                } else{
                    [_mpMusicPlayer stop];
                }
                [self playCrash];
            }
        }
    }
}

// アニメーションタイマーをまとめて破棄
- (void)animationTimerInvalidate {
    if (_flashAnimationTimer != nil) {
        [_flashAnimationTimer invalidate];
    }
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

-(void)viewWillAppear:(BOOL)animated{
    [self playStart];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSInteger countViewChanged = [[NSUserDefaults standardUserDefaults] integerForKey:@"KEY_countUpViewChanged"];
    countViewChanged ++;
    [[NSUserDefaults standardUserDefaults] setInteger:countViewChanged forKey:@"KEY_countUpViewChanged"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

// statusBarを非表示にする
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == _crashPlayer) {
        NSLog(@"detected");
    }
      NSLog(@"detected");
}
//- (void) onAudioSessionEvent: (NSNotification *) notification
//{
//    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
//    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
//        NSLog(@"Interruption notification received!");
//        
//        //Check to see if it was a Begin interruption
//        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
//            NSLog(@"Interruption began!");
//            
//        } else {
//            NSLog(@"Interruption ended!");
//            //Resume your audio
//        }
//    }
//}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
}





@end
