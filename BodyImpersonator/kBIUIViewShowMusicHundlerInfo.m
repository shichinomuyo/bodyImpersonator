//
//  kBIShowMusicHundlerInfo.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/26.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBIUIViewShowMusicHundlerInfo.h"

@implementation kBIUIViewShowMusicHundlerInfo
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)awakeFromNib{
//    [super awakeFromNib];
//
//}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self) {
        if (!self.subviews.count) {
            NSLog(@"coder");
            [self initializeView];
        }
      
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         NSLog(@"frame");
        [self initializeView];
    }
    return self;
}


-(void)initializeView{
    NSString *className = NSStringFromClass([self class]);
    [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
    // ロードしたViewのframeをSuperviewのサイズと合わせる
    contentView.frame = self.bounds;
    // Superviewのサイズが変わった時に一緒に引き伸ばされれるように設定。
    // 以下は明示的に設定しなくてもデフォルトでそうなっているが念のため。
    // こういう場合は、Visual Format Languageを使うよりAutoresizingMaskを使ったほうが手軽。
    contentView.translatesAutoresizingMaskIntoConstraints = YES;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    // SuperviewにロードしたViewをSubviewとして追加
    [self showMusicHundlerInfo];
    [self addSubview:contentView];
 
}

-(void)showMusicHundlerInfo{
    NSLog(@"showMusicHundlerInfo");
    // selectedImageNameから何番目のセルが選択中であるかを検出する
//    NSArray *imageNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_imageNames"];
//    NSString *selectedImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_selectedImageName"];
//    NSInteger index = [imageNames indexOfObject:selectedImageName];

//    self.selectedIndexNum = index;
    
    //kBIMusicHundlerから色々取得
    NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSData *data = hundlers[self.selectedIndexNum];
    _hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"selectedNum:%ld",(long)self.selectedIndexNum);
   
    UIImage *imageSelectedTypeOfMusic;  // 画像設定
    NSString *artistName; // 文字列設定
    NSString *trackTitle;// 文字列設定
    
    // 再生状態フラグの初期化
    _musicPlayerIsPlaying = NO;
    if (_hundler.originalMusicOn) {
        imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_MUSIC_26x26"]; // 画像設定
        NSLog(@"ICONorimusic");
        artistName = @"Preset1";// nil;    // 文字列設定
        trackTitle = @"Preset MusicMusicMusicMusicMusicMusicMusicMusicMusicMusic";// nil;    // 文字列設定
        [self initializeAVAudioPlayers_OriginalMusic];
    }else if (_hundler.rollSoundOn) {
        imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_Drum"]; // 画像設定 ICON_Drum
        NSLog(@"ICONdrum");
        artistName = @"Preset2";// nil;    // 文字列設定
        trackTitle = @"Drum Roll"; //nil;    // 文字列設定
        [self initializeAVAudioPlayers_Roll];
    }else if (_hundler.iPodLibMusicOn) {
        imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_Album26x26"]; // 画像設定
        NSLog(@"ICONipod");
        artistName = _hundler.artist;    // 文字列設定
        trackTitle = _hundler.trackTitle;    // 文字列設定
        [self initializeMPMusicPlayerController]; // サウンド準備
    }
    
    [imageView setImage:imageSelectedTypeOfMusic];

    NSString *musicInfo = [NSString stringWithFormat:@"%@/%@",artistName,trackTitle];
    [labelMusicHundlerInfo setAdjustsFontSizeToFitWidth:NO];
    [labelMusicHundlerInfo setText:musicInfo];
    
    NSLog(@"custumUIView.frame x:%d y:%d",(int)self.frame.origin.x,(int)self.frame.origin.y);
}



-(void)updateViewItems{
     [self showMusicHundlerInfo];
}

- (void)initializeAVAudioPlayers_Roll{
    // (audioplayer)再生する効果音のパスを取得する
    // ロールtmp
    NSString *path_roll = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
    NSURL *url_roll = [NSURL fileURLWithPath:path_roll];
    _rollPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    _rollPlayerTmp.delegate = self;
    
    
    // ロールalt
    _rollPlayerAlt = [[AVAudioPlayer alloc] initWithContentsOfURL:url_roll error:NULL];
    
    // プレイヤーを準備
    [_rollPlayerTmp prepareToPlay];
    [_rollPlayerAlt prepareToPlay];
}

- (void)initializeAVAudioPlayers_OriginalMusic{
    // オリジナルミュージック
    NSString *path_originalMusic = [[NSBundle mainBundle] pathForResource:@"Theme05" ofType:@"mp3"];
    NSURL *url_originalMusic = [NSURL fileURLWithPath:path_originalMusic];
    if (_originalMusicPlayer != nil) {

        _originalMusicPlayer = nil;
    }
    _originalMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url_originalMusic error:NULL];

    _originalMusicPlayer.delegate = self;
    // プレイヤーを準備
    [_originalMusicPlayer prepareToPlay];
}

- (void)initializeMPMusicPlayerController{
    NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSData *data = hundlers[self.selectedIndexNum];
    kBIMusicHundlerByImageName *hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    
    NSURL *url = hundler.mediaItemURL;
    _iPodLibMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    _iPodLibMusicPlayer.delegate = self;
    [_iPodLibMusicPlayer prepareToPlay];
}

- (IBAction)btnPlay:(UIButton *)sender {
    NSLog(@"btntapped");
    if (!_musicPlayerIsPlaying) { // 再生中ではないときに押された場合
        _musicPlayerIsPlaying = YES; // フラグを再生中に変更
        [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Stop26x26"] forState:UIControlStateNormal]; // 画像を停止ボタンに変更
        if (_hundler.originalMusicOn) {
            [_originalMusicPlayer setCurrentTime:0.0];
            [_originalMusicPlayer play];
        }else if (_hundler.rollSoundOn) {
            [_rollPlayerTmp setCurrentTime:0.0];
            [_rollPlayerTmp play];
        }else if (_hundler.iPodLibMusicOn) {
            [_iPodLibMusicPlayer setCurrentTime:0.0];
            [_iPodLibMusicPlayer play];
        }
    } else{ // 再生中に押された場合
        _musicPlayerIsPlaying = NO; // フラグを初期状態に変更
        [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Play26x26"] forState:UIControlStateNormal]; // 画像を再生ボタンに変更
        if (_hundler.originalMusicOn) {
            [_originalMusicPlayer stop];

        }else if (_hundler.rollSoundOn) {
            [_rollPlayerTmp stop];

        }else if (_hundler.iPodLibMusicOn) {
            [_iPodLibMusicPlayer stop];

        }
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"再生終わり");
    _musicPlayerIsPlaying = NO; // フラグを初期状態に変更
    [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Play26x26"] forState:UIControlStateNormal]; // 画像を再生ボタンに変更
    if (_hundler.originalMusicOn) {
        [_originalMusicPlayer stop];
    }else if (_hundler.rollSoundOn) {
        [_rollPlayerTmp stop];
    }else if (_hundler.iPodLibMusicOn) {
        [_iPodLibMusicPlayer stop];
    }
}

- (void)stopMusicPlayer{
    _musicPlayerIsPlaying = NO; // フラグを初期状態に変更
    [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Play26x26"] forState:UIControlStateNormal]; // 画像を再生ボタンに変更
    if (_hundler.originalMusicOn) {
        [_originalMusicPlayer stop];
    }else if (_hundler.rollSoundOn) {
        [_rollPlayerTmp stop];
    }else if (_hundler.iPodLibMusicOn) {
        [_iPodLibMusicPlayer stop];
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview{

}

-(void)didMoveToSuperview{
         NSLog(@"didMoveToSuperView");

}

-(void)dealloc{

}
@end
