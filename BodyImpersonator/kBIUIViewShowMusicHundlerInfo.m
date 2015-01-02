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
    NSData *data = [hundlers safeObjectAtIndex:self.selectedIndexNum];
    UIImage *imageSelectedTypeOfMusic;  // 画像設定
    NSString *artistName; // 文字列設定
    NSString *trackTitle;// 文字列設定
    if (data) { // コレクションビューに画像がひとつ以上追加されていてhundlerが紐付いてるとき
        _hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"selectedNum:%ld",(long)self.selectedIndexNum);
        

        _musicPlayerIsPlaying = NO;
        if (_hundler.originalMusicOn) {
            imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_MUSIC_26x26"]; // 画像設定
            NSLog(@"ICONorimusic");
            artistName = @"Preset1";// nil;    // 文字列設定
            trackTitle = @"Preset MusicMusicMusicMusicMusicMusicMusicMusicMusicMusic";// nil;    // 文字列設定
        }else if (_hundler.rollSoundOn) {
            imageSelectedTypeOfMusic = [UIImage imageNamed:@"ICON_Drum"]; // 画像設定 ICON_Drum
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
        
        NSLog(@"custumUIView.frame x:%d y:%d",(int)self.frame.origin.x,(int)self.frame.origin.y);
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

    NSLog(@"labelMusicHundlerInfo.width:%.2f",labelMusicHundlerInfo.frame.size.width);
    NSLog(@"labelCenter.x:%.2f",labelMusicHundlerInfo.center.x);

    [viewHaveLabel setClipsToBounds:YES];

}



-(void)updateViewItems{
     [self showMusicHundlerInfo];
}

- (IBAction)btnPlay:(UIButton *)sender {
    
    if (!_musicPlayerIsPlaying) { // 再生中ではないときに押された場合
          NSLog(@"btn_startPlay");
        _musicPlayerIsPlaying = YES; // フラグを再生中に変更
        [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Stop26x26"] forState:UIControlStateNormal]; // 画像を停止ボタンに変更
        NSString *soundPath;
        NSURL *soundURL;
        if (_hundler.originalMusicOn) {
            soundPath = [[NSBundle mainBundle] pathForResource:@"Theme05" ofType:@"mp3"];
            soundURL = [NSURL fileURLWithPath:soundPath];
        }else if (_hundler.rollSoundOn) {
            soundPath = [[NSBundle mainBundle] pathForResource:@"roll13" ofType:@"mp3"];
            soundURL = [NSURL fileURLWithPath:soundPath];
        }else if (_hundler.iPodLibMusicOn) {
            NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
            NSData *data = hundlers[self.selectedIndexNum];
            kBIMusicHundlerByImageName *hundler = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
            
            soundURL = hundler.mediaItemURL;
        }
         NSLog(@"BOOL:%d",_musicPlayerIsPlaying);
        [[kAVAudioPlayerManager sharedManager] playSound:soundURL];
    } else{ // 再生中に押された場合
         NSLog(@"btn_stop");
        [self stopMusicPlayer];
    }
}

- (void)stopMusicPlayer{
    _musicPlayerIsPlaying = NO; // フラグを初期状態に変更
    [btnPlayerControll setImage:[UIImage imageNamed:@"ICON_Play26x26"] forState:UIControlStateNormal]; // 画像を再生ボタンに変更
    [[kAVAudioPlayerManager sharedManager] stopSound];
    
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
 NSLog(@"willMoveToSuperview");
    // アニメーション処理
    {
        // 文字列の長さを取得
        textWidth = [labelMusicHundlerInfo.text sizeWithAttributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:labelMusicHundlerInfo.font.pointSize]}].width; // 移動後の座標計算に使用
        
        if (viewHaveLabel.frame.size.width < textWidth ) { // テキストの長さが親ビューより大きい時だけスライドアニメーション実行
            // 文字数を取得
            textLength = (int)labelMusicHundlerInfo.text.length; // アニメーションにかける時間を計算するのに使用
            // アニメーションにかける時間
            transitionDuration = textLength/4;
            [self moveAffineLabelX:transitionDuration]; // スライドアニメーション
        }
    }

}

-(void)didMoveToSuperview{
         NSLog(@"didMoveToSuperView");


}

-(void)dealloc{

}

// アニメーション
- (void)moveAffineLabelX:(float)duration{
    labelMusicHundlerInfo.transform = CGAffineTransformIdentity;

    [UIView animateKeyframesWithDuration:duration
                                   delay:4.0
                                 options: 3<<16  // 3<<16はUIViewAnimationCurveLinearのバイナリ。バイナリなら指定できる。
                              animations:^{
                                  NSLog(@"textWidth:%d",textWidth);
                                  NSLog(@"なんで:%d",textWidth);

                                  labelMusicHundlerInfo.transform = CGAffineTransformMakeTranslation(-1.1*textWidth, 0);
                              } completion:^(BOOL finished){
//                                  [self moveAffineLabelX:duration];
                              }
     ];

    
}
@end
