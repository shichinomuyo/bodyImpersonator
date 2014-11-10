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
     // (audioplayer)再生する効果音のパスを取得しインスタンス生成
    [self initializeAVAudioPlayers];
    // selectedPhotoImageを非表示に設定
    [self.BFCV.knobImageView setHidden:1];
    [self playDrumRoll];

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

#pragma mark actionControlls
- (IBAction)stopBtn:(UIButton *)sender {
    if (_rollPlayerAlt.isPlaying || _rollPlayerTmp.isPlaying) {
        [self stopDrumRoll];
    }else{
        [self performSegueWithIdentifier:@"unwindFromPlayVC" sender:self];
    }
    
}

-(void)stopDrumRoll{

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
                             self.BFCV.backgroundColor = [UIColor whiteColor];
                             
                         } completion:nil];
    [self.BFCV.knobImageView setImage:_selectedImage];

    // 拡大してくるアニメーション
    [self.BFCV.knobImageView appearWithScaleUp];
}

-(void)playDrumRoll{

    // ドラムロールを再生する
    [_rollPlayerTmp playRollStopCrash:_crashPlayer setVolumeZero:_rollPlayerAlt ];
    // playerControllを一定間隔で呼び出すタイマーを作る
    [self playerControll];
    
    // アニメーションタイマーを破棄する
    [self animationTimerInvalidate];
    
    
    // Btn,Icon,Logoを非表示にする
    
    // viewのバックグラウンドカラーをnearlyBlackにする
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.BFCV.backgroundColor = RGB(17, 34, 48);//nearlyBlack
                     } completion:nil];
    
    // flashAnimation開始
    _flashAnimationTimer =
    [NSTimer scheduledTimerWithTimeInterval:0.9f
                                     target:self.lightEffectImageView
                                   selector:@selector(flashAnimation)
                                   userInfo:nil
                                    repeats:YES];
    
}


#pragma mark -
#pragma mark motionAction
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    // selectedPhotoImageが非表示(起動時の画面)のときにだけ反応
    if (self.BFCV.knobImageView.hidden == 1) {
        // バイブレーションを動作させる
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self stopDrumRoll];

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
