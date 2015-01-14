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

- (id) initWithCoder:(NSCoder*)coder {
    NSLog(@"initwithcoder");
    self = [super initWithCoder:coder];
    if(self) {
        if (!self.subviews.count) {
            NSLog(@"coder");
            [self _init];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         NSLog(@"initwithframe");
        [self _init];
    }
    return self;
}

-(void)_init{
    NSString *className = NSStringFromClass([self class]);
    [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
    // ロードしたViewのframeをSuperviewのサイズと合わせる
    __contentView.frame = self.bounds;
    NSLog(@"contentView.frame:%.2f",__contentView.frame.size.width);
    // Superviewのサイズが変わった時に一緒に引き伸ばされれるように設定。
    // 以下は明示的に設定しなくてもデフォルトでそうなっているが念のため。
    // こういう場合は、Visual Format Languageを使うよりAutoresizingMaskを使ったほうが手軽。
    __contentView.translatesAutoresizingMaskIntoConstraints = YES;
    __contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    labelIsMoving = NO;
    labelAnimationNeeds = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentView:)];
    tapGesture.numberOfTapsRequired = 1;
    [__contentView setUserInteractionEnabled:YES];
    [__contentView addGestureRecognizer:tapGesture];
    
    // SuperviewにロードしたViewをSubviewとして追加
    NSLog(@"initializeView");
    [self addSubview:__contentView];
    

    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
}

-(void)showMusicHundlerInfo{
    NSLog(@"showMusicHundlerInfo");
     self._mpMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];

    //kBIMusicHundlerから色々取得
    NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSData *data = [hundlers safeObjectAtIndex:self.selectedIndexNum];
    UIImage *imageSelectedTypeOfMusic;  // 画像設定
    NSString *artistName; // 文字列設定
    NSString *trackTitle;// 文字列設定
    if (data) { // コレクションビューに画像がひとつ以上追加されていてhundlerが紐付いてるとき
        _hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"selectedNum:%ld",(long)self.selectedIndexNum);
        

        _musicPlayerIsPlaying = NO;
        __mpMusicPlayerIsPlaying = NO;
        if (_hundler.originalMusicOn) {
            imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_MUSIC_26x26"]; // 画像設定
            NSLog(@"ICONorimusic");
            artistName = @"Preset1";// nil;    // 文字列設定
            trackTitle = @"Preset Music";// nil;    // 文字列設定
        }else if (_hundler.rollSoundOn) {
            imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_Drum26x26"]; // 画像設定 ICON_Drum
            NSLog(@"ICONdrum");
            artistName = @"Preset2";// nil;    // 文字列設定
            trackTitle = @"Drum Roll"; //nil;    // 文字列設定
        }else if (_hundler.iPodLibMusicOn) {
            imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_Album26x26"]; // 画像設定
            NSLog(@"ICONipod");
            artistName = _hundler.artist;    // 文字列設定
            trackTitle = _hundler.trackTitle;    // 文字列設定
        }
        
        [btnPlayerControll setEnabled:YES];
        NSString *musicInfo = [NSString stringWithFormat:@"%@/%@",artistName,trackTitle];
        [labelMusicHundlerInfo setAdjustsFontSizeToFitWidth:NO];
        [labelMusicHundlerInfo setText:musicInfo];
        
    }else{ // コレクションビューに画像がひとつも追加されていないとき
        NSString *sentenceAppearCollectionHaveNoItem1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"First,PleaseAddImage.", nil)];
        NSString *sentenceAppearCollectionHaveNoItem2 = [[NSString alloc] initWithFormat:NSLocalizedString(@"Tap+IconToAddImageFromAlbumOrCam", nil)];
        imageSelectedTypeOfMusic = nil;
         [btnPlayerControll setEnabled:NO];
        artistName = nil;
        trackTitle = nil;
        NSString *musicInfo = [NSString stringWithFormat:@"%@/%@",sentenceAppearCollectionHaveNoItem1,sentenceAppearCollectionHaveNoItem2];
        [labelMusicHundlerInfo setAdjustsFontSizeToFitWidth:NO];
        [labelMusicHundlerInfo setText:musicInfo];
    }
    [imageView setImage:imageSelectedTypeOfMusic];


    [viewHaveLabel setClipsToBounds:YES]; // はみ出した部分を表示しない

    // アニメーション処理
    {
        {// メインビューから他のビューへ遷移後、また戻ってきた時のための処理
            NSLog(@"アニメーション初期化");
            labelMusicHundlerInfo.transform = CGAffineTransformIdentity; // ラベルの座標を初期化
            [labelMusicHundlerInfo.layer removeAllAnimations]; // ラベルのアニメーションを止める

        }
        
        // 文字列の長さを取得
                textWidth = [labelMusicHundlerInfo.text sizeWithAttributes:@{NSAttachmentAttributeName:[UIFont fontWithName:labelMusicHundlerInfo.font.fontName size:labelMusicHundlerInfo.font.pointSize]}].width; // 移動後の座標計算に使用

        NSLog(@"custumUIView.frame (%d,%d,%d,%d)",(int)__contentView.frame.origin.x,(int)__contentView.frame.origin.y,(int)__contentView.frame.size.width,(int)__contentView.frame.size.height);
        NSLog(@"__contentView.width:%.2f",__contentView.frame.size.width);
        NSLog(@"labelMusicHundlerInfo.width:%.2f",labelMusicHundlerInfo.frame.size.width);
        NSLog(@"labelCenter.x:%.2f",labelMusicHundlerInfo.center.x);
        NSLog(@"textWidth%.2f",textWidth);
        
        if (viewHaveLabel.frame.size.width < textWidth ) { // テキストの長さが親ビューより大きい時だけスライドアニメーション実行
            labelAnimationNeeds = YES;
            // 文字数を取得
            textLength = (int)labelMusicHundlerInfo.text.length; // アニメーションにかける時間を計算するのに使用
            // アニメーションにかける時間
            transitionDuration = textLength/4;
            
            [self moveAffineLabelX_FirstTime:transitionDuration]; // スライドアニメーション
            NSLog(@"アニメーションあり");
        }else{ // テキストの長さが親ビュー(viewHaveLabel)より小さい時
            NSLog(@"アニメーションなし");
            NSLog(@"customUIView.frame.size:%.2f,%.2f",__contentView.frame.size.width,__contentView.frame.size.height);
            // __contentViewのサイズ調整
            [__contentView setFrame:CGRectMake(__contentView.frame.origin.x, __contentView.frame.origin.y, (viewHaveLabel.frame.size.width - labelMusicHundlerInfo.frame.size.width), 20)];
            [viewHaveLabel setFrame:CGRectMake(viewHaveLabel.frame.origin.x, viewHaveLabel.frame.origin.y, labelMusicHundlerInfo.frame.size.width, 20)];
//            [labelMusicHundlerInfo sizeToFit];
//            [viewHaveLabel sizeToFit];
//            [__contentView sizeToFit];
//            [self sizeToFit];


        }
        
    }

}


- (IBAction)btnPlay:(UIButton *)sender {
    
    if (!_musicPlayerIsPlaying) { // 再生中ではないときに押された場合
          NSLog(@"btn_startPlay");
        _musicPlayerIsPlaying = YES; // フラグを再生中に変更
        [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Stop26x26"] forState:UIControlStateNormal]; // 画像を停止ボタンに変更
        NSString *soundPath;
        NSURL *soundURL;
        MPMediaItemCollection *mediaItemCollection;
        if (_hundler.originalMusicOn) { // プリセットミュージックURLセット
            soundPath = [[NSBundle mainBundle] pathForResource:@"Theme05" ofType:@"mp3"];
            soundURL = [NSURL fileURLWithPath:soundPath];
        }else if (_hundler.rollSoundOn) { // ドラムロールURLセット
            soundPath = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
            soundURL = [NSURL fileURLWithPath:soundPath];
        }else if (_hundler.iPodLibMusicOn) { // ライブラリから選択している曲のURLセット
            NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
            NSData *data = [hundlers safeObjectAtIndex:self.selectedIndexNum];
            kBIMusicHundlerByImageName *hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            soundURL = hundler.mediaItemURL;
            if (!soundURL) { // DRM問題でitemのURLが取得できない場合はAVAudioPlayerで再生ができないのでmpMusicPlayerで再生するためmediaItemCollectionを準備。
                mediaItemCollection = hundler.mediaItemCollection;
            }
        }
         NSLog(@"BOOL:%d",_musicPlayerIsPlaying);
        // 再生開始
        if (soundURL) { // AVAudioPlayerで再生できる場合はkAVAudioPlayerManagerで再生させる。
            [[kAVAudioPlayerManager sharedManager] playSound:soundURL];
        } else{// DRM問題でitemのURLが取得できないのでmpMusicPlayerで再生させる。
            NSLog(@"Use MPMUsicPlayerController");
//             self._mpMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
            [__mpMusicPlayer setQueueWithItemCollection:mediaItemCollection];
            [__mpMusicPlayer play];
            __mpMusicPlayerIsPlaying = YES;

        }
        
        if (labelAnimationNeeds) {
            [self moveAffineLabelX:transitionDuration];
        }
        if (labelIsMoving) {
            // 何もしない
        }else{
            NSLog(@"labelMoveStart");
  
        }

    } else{ // 再生中に押された場合
         NSLog(@"btn_stop");
        [self stopMusicPlayer];
        NSLog(@"labelisMoving:%@", labelIsMoving ? @"YES":@"NO");
        if (labelIsMoving) {
                NSLog(@"btn_stoplabelMoving");
            labelIsMoving = NO;
        }else{
            // 何もしない
                NSLog(@"btn_stoplabelStoped");
        }
        
    }
}

- (void)stopMusicPlayer{

    [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Play26x26"] forState:UIControlStateNormal]; // 画像を再生ボタンに変更
    [labelMusicHundlerInfo.layer removeAllAnimations];
    labelMusicHundlerInfo.transform = CGAffineTransformIdentity; // 止める
    if (!__mpMusicPlayerIsPlaying) {
        if (_musicPlayerIsPlaying) {
            NSLog(@"kAVAudioPlayer stop");
            [[kAVAudioPlayerManager sharedManager] stopSound];
        }
    }else{
        NSLog(@"mpmplayer stop");
        [__mpMusicPlayer stop];
    }
    _musicPlayerIsPlaying = NO; // フラグを初期状態に変更
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
 NSLog(@"willMoveToSuperview");
//    [self showMusicHundlerInfo];
//    if (self.superview) {
//        
//        if (!self) {
//            NSLog(@"superview^!self");
//            
//        }else{
//            NSLog(@"superview^self");
//            self.bounds = CGRectMake(self.bounds.origin.x, 0, 320, 20);
//            __contentView.frame = self.bounds;
//        }
//        
//    } else {
//        if (!self) {
//            
//            NSLog(@"!superview^!self");
//        }else{
//            NSLog(@"!superview^self");
//            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320, 20);
//            __contentView.frame = self.bounds;
//        }
//    }

}

-(void)didMoveToSuperview{
    NSLog(@"didMoveToSuperView");
    if ([labelMusicHundlerInfo.text length] == 0) {
        NSLog(@"まだない");
    }else {
        NSLog(@"もうある");
        
    }



}

- (void)layoutSubviews
{
//    static CGPoint fixCenter = {0};
//    [super layoutSubviews];
//    if (CGPointEqualToPoint(fixCenter, CGPointZero)) {
//        fixCenter = [labelMusicHundlerInfo center];
//    } else {
//        labelMusicHundlerInfo.center = fixCenter;
//    }
}

-(void)dealloc{

}

// アニメーション
- (void)moveAffineLabelX_FirstTime:(float)duration{
    labelMusicHundlerInfo.transform = CGAffineTransformIdentity;
    labelIsMoving = YES;

    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options: 3<<16 | UIViewAnimationOptionAllowUserInteraction// 3<<16はUIViewAnimationCurveLinearのバイナリ。バイナリなら指定できる。
                              animations:^{

                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.15
                                                                animations:^{
                                                                    // 何もせず止めておく
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.25
                                                          relativeDuration:0.8
                                                                animations:^{
                                                                    labelMusicHundlerInfo.transform = CGAffineTransformMakeTranslation(-1.4*textWidth, 0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.7
                                                          relativeDuration:0.05
                                                                animations:^{
//　何もせず止めておく
                                                                }];

                              } completion:^(BOOL finished){
                                     labelMusicHundlerInfo.transform = CGAffineTransformIdentity;

                              }];

    
}

- (void)moveAffineLabelX:(float)duration{
    labelMusicHundlerInfo.transform = CGAffineTransformIdentity;
    labelIsMoving = YES;
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options: 3<<16 | UIViewAnimationOptionAllowUserInteraction | UIViewKeyframeAnimationOptionRepeat// 3<<16はUIViewAnimationCurveLinearのバイナリ。バイナリなら指定できる。
                              animations:^{
                                  
//                                  [UIView addKeyframeWithRelativeStartTime:0.0
//                                                          relativeDuration:0.25
//                                                                animations:^{
//                                                                    // 何もせず止めておく
//                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.9
                                                                animations:^{
                                                                    labelMusicHundlerInfo.transform = CGAffineTransformMakeTranslation(-1.4*textWidth, 0);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.9
                                                          relativeDuration:0.1
                                                                animations:^{
                                                                    //　何もせず止めておく
                                                                }];
                                  
                              } completion:^(BOOL finished){
                                  labelMusicHundlerInfo.transform = CGAffineTransformIdentity;

                              }];
    
    
}

- (void)tapContentView:(UITapGestureRecognizer *)gesture{
    [self btnPlay:nil];
}



@end
