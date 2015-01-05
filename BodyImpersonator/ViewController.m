//
//  ViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ViewController.h"
// collectionViewの最大アイテム数
static const NSInteger kLIMITED_ITEM_NUMBER = 9;
static const NSInteger kMAX_ITEM_NUMBER = 18;

#define MY_BANNER_UNIT_ID @"ca-app-pub-5959590649595305/8782306070"
#define MY_BANNER_UNIT_ID_FOR_iPAD @"ca-app-pub-5959590649595305/6784511271"

@interface ViewController ()
{
    UIImagePickerController *_imagePicker;
    UIViewController *_pickerContainerView;
    UIPopoverPresentationController *_popoverPresentation;
    BICollectionViewCell *_selectedCell;
    kBIIndicator *_kIndicator;
    CGFloat _iOSVer;
    UIPopoverController *_popoverController;

}

// IBOutlet Btn
@property (weak, nonatomic) IBOutlet UIView *baseViewBtns;
@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLIne;
@property (weak, nonatomic) IBOutlet UIButton *btnSerch;
@property (weak, nonatomic) IBOutlet UIButton *btnPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;

// IBOutlet Image
@property (weak, nonatomic) IBOutlet UIImageView *selectedPhotoImage; // secondVCへの画像データ渡し用

// IBOutlet CustomUIView
@property (weak, nonatomic) IBOutlet kBIUIViewShowMusicHundlerInfo *customUIView;


// IBOutlet collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
// IBAction Btn
- (IBAction)searchUIBtn:(UIButton *)sender;
- (IBAction)previewUIBtn:(UIButton *)sender;
- (IBAction)settingsUIBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerVeiwHaveBtnsVerticalSpaceFromBottom;

@end

#pragma mark -
@implementation ViewController
#pragma mark initialize
+ (void) initialize{
    // 初回起動時の初期データ
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setObject:@"0" forKey:@"KEY_countUPViewChanged"]; // ビューの切り替わりをカウント
    // collectionViewに表示する画像を保存する配列の作成・初期化
    NSMutableArray *imageNames = [NSMutableArray array];
    NSArray *array = [imageNames copy];
    [appDefaults setObject:array forKey:@"KEY_imageNames"];
    // collectionViewに表示する画像に番号を振るために整数値を作成・初期化
    [appDefaults setObject:@"0" forKey:@"KEY_imageCount"];
    // previewVCで曲選択したときの情報を保存する配列の作成・初期化
    NSMutableArray *hundlers = [NSMutableArray array];
    NSArray *array_hunders = [hundlers copy];
    [appDefaults setObject:array_hunders forKey:@"KEY_MusicHundlersByImageName"];

    // 選択中の画像の名前を入れておくKEY_selectedImageNameをNO_IMAGEで初期化
    [appDefaults setObject:@"NO_IMAGE" forKey:@"KEY_selectedImageName"];
    // settingsを初期化
    [appDefaults setObject:@"YES" forKey:@"KEY_MusicOn"];
    [appDefaults setObject:@"YES" forKey:@"KEY_CrashSoundOn"];
    [appDefaults setObject:@"YES" forKey:@"KEY_FlashEffectOn"];
    [appDefaults setObject:@"YES" forKey:@"KEY_StartPlayingByShakeOn"];
    [appDefaults setObject:@"YES" forKey:@"KEY_FinishPlayingByShakeOn"];
    [appDefaults setObject:@"NO"  forKey:@"KEY_StartPlayingWithVibeOn"];
    [appDefaults setObject:@"YES" forKey:@"KEY_FinishPlayingWithVibeOn"];
    // 再生中のバックグランドカラーを初期化
    NSString *initColor = [[NSString alloc] initWithFormat:NSLocalizedString(@"Black", nil)];
    [appDefaults setObject:initColor forKey:@"KEY_PlayVCBGColor"];
    // アプリ内課金状況を初期化
    [appDefaults setObject:@"NO" forKey:@"KEY_Purchased"];
    
    // ユーザーデフォルトの初期値に設定する
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:appDefaults];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 購入フラグを確認
    _purchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_Purchased"];
    _startPlayingByShakeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_StartPlayingByShakeOn"];
    _startPlayingWithVibeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_StartPlayingWithVibeOn"];
    
    // OSヴァージョンを取得
    _iOSVer = [[[UIDevice currentDevice] systemVersion] floatValue];
  
    // ナビゲーションコントローラのステータスバーの透過表示が気に入らないので隠す。
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
    NSLog(@"最初のviewDidLoad");
    
    // iOS7以上の場合はnavigationBarの高さを64pxにする
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.naviBarHeight.constant = 64;
    }

    NSString *titleImageiPhone = NSLocalizedString(@"titleImageiPhone", nil);
    NSString *titleImageiPad = NSLocalizedString(@"titleImageiPad", nil);
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
            [self pushImageOnNavigationBar:self.navigationBar :[UIImage imageNamed:titleImageiPhone]];
    }
    else{
        NSLog(@"iPadの処理");
        self.navigationBar.alpha = 1;
            [self pushImageOnNavigationBar:self.navigationBar :[UIImage imageNamed:titleImageiPad]];
    }



    _kIndicator = [kBIIndicator alloc];
    
    // GoogleAnalytics導入のため以下設定
    self.screenName = @"BI_MainVC";
    
    // ハンドラーがないとき(v1.2より前から使ってる場合)一度だけ初期化 v1.2以降から使用を開始した場合はsecondVCでその都度追加していく。
    NSMutableArray *hundlers = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSData *data = [hundlers safeObjectAtIndex:0];
    if (!data) {
        NSLog(@"hundlerがない");
        NSMutableArray *imageNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_imageNames"]; // for文の終了条件に配列のカウントを使うので
        hundlers = [NSMutableArray array];
        int i;
        for (i = 0; i < [imageNames count]; i++) {
                kBIMusicHundlerByImageName *defaultHundler = [kBIMusicHundlerByImageName alloc];
                defaultHundler.imageName = imageNames[i];
                defaultHundler.rollSoundOn = NO;
                defaultHundler.originalMusicOn = YES;
                defaultHundler.iPodLibMusicOn = NO;
                NSData *defaultData = [NSKeyedArchiver archivedDataWithRootObject:defaultHundler];
                [hundlers addObject:defaultData];
        }
        NSArray *array = [hundlers mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"KEY_MusicHundlersByImageName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KEY_MusicHundlersByImageName"];
    }
}

// NavigationBarに画像を配置 高さ調整
- (void)pushImageOnNavigationBar:(UINavigationBar *)navi Image:(UIImage *)image Height:(CGFloat)height
{
    // navigationBarMainに画像を設定
    // イメージのサイズを調節
    CGSize imageSize = CGSizeMake(image.size.width,image.size.height);
    CGSize size = CGSizeMake(imageSize.width * (height / imageSize.height), height);
    
//    NSLog(@"imagesize(%.2f,%.2f)",image.size.width,image.size.height);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, height)];
    imgView.image = image;
    
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    // navigationItemに設定
    UINavigationItem *navigationItemIcon = [[UINavigationItem alloc]init];
    navigationItemIcon.titleView = imgView;
    [navi pushNavigationItem:navigationItemIcon animated:YES];
    
}

// NavigationBarに画像を配置 高さ調整なし
- (void)pushImageOnNavigationBar:(UINavigationBar *)navi :(UIImage *)image
{
    // navigationBarMainに画像を設定
    // イメージのサイズを調節
    CGSize imageSize = CGSizeMake(image.size.width,image.size.height);
    
    NSLog(@"imagesize(%.2f,%.2f)",image.size.width,image.size.height);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    imgView.image = image;
    
    [imgView setContentMode:UIViewContentModeCenter];
    // navigationItemに設定
    UINavigationItem *navigationItemIcon = [[UINavigationItem alloc]init];
    navigationItemIcon.titleView = imgView;
    [navi pushNavigationItem:navigationItemIcon animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    // 画面が表示されたら定期ロード再開
    [self.nadView resume];
    // Addon購入状態を取得
    NSLog(@"viewwillAppear");
    _startPlayingByShakeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_StartPlayingByShakeOn"];
    _startPlayingWithVibeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_StartPlayingWithVibeOn"];
    

    

}

-(void)viewDidLayoutSubviews{
     NSLog(@"purchased in mainview:%d",_purchased);

    // AppDelegateからの購入通知を登録する
    _purchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_Purchased"];

    if (_purchased == NO) {
        // 広告表示のためのストーリボード上のレイアウト

    } else {
        [self adjustLayoutPurchased];
    }

}

// ビューが表示されたときに実行される
- (void)viewDidAppear:(BOOL)animated
{

       NSLog(@"viewdidAppear");
    // customUIViewのラベルに曲情報を表示
    self.customUIView.selectedIndexNum = self.selectedIndexPath.row;
    [self.customUIView updateViewItems];
    
    // 最初のviewControllerに戻ったときplayVCで表示完了した回数が3の倍数かつインタースティシャル広告の準備ができていればインタースティシャル広告表示
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countViewChanged = [defaults integerForKey:@"KEY_countUpViewChanged"];

    NSLog(@"countUpViewChanged %ld", (long)countViewChanged);

    // 広告表示
    if (!_purchased) {
        // バナー広告表示
        [self addAdBanners];
         // インタースティシャル広告表示       
         [[kADMOBInterstitialSingleton sharedInstans] interstitialControll]; // 生成、表示の判断含め全部この中でやる
    }else{
        if (bannerView_){
            [bannerView_ removeFromSuperview];
        }
    }
    
    // 最大登録可能数の決定
    if (_purchased == NO) {
        _limitedNumberOfImages = kLIMITED_ITEM_NUMBER; // 9個
    } else {
        _limitedNumberOfImages = kMAX_ITEM_NUMBER; // 18個
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    // 画面が隠れたらNend定期ロード中断
    [self.nadView pause];
    
    [_customUIView stopMusicPlayer];
    [_customUIView.layer removeAllAnimations];

}
-(void)viewDidDisappear:(BOOL)animated{

}
// AddOn購入後のレイアウト調整
- (void)adjustLayoutPurchased{
    NSLog(@"adjustLayoutPurchased");
    int baseViewBtnsHeight;
    int collectionViewHeghtOriginal;
    int expansionY;
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        baseViewBtnsHeight = 136;// StoryBoard上で課金前の状態で136pxとして作成
        collectionViewHeghtOriginal = 106 * 3;
        expansionY = 50;
        //        [_collectionView setFrame:CGRectMake(0, 64, self.view.bounds.size.width, 106 * 3 + 50)]; // bannerのheight50px分、heightを大きくする
                self.containerVeiwHaveBtnsVerticalSpaceFromBottom.constant = 0;
    }
    else{
        NSLog(@"iPadの処理");
        baseViewBtnsHeight = 102;// StoryBoard上で課金前の状態で102pxとして作成
        collectionViewHeghtOriginal = 256 * 3;
        expansionY = 90;
        
        [_collectionView setFrame:CGRectMake(0, 64, self.view.bounds.size.width, collectionViewHeghtOriginal + expansionY)];// bannerのheight90px分、heightを大きくする
        [_baseViewBtns setFrame:CGRectMake(0, self.view.frame.size.height - baseViewBtnsHeight, self.view.frame.size.width, baseViewBtnsHeight)];
    }
    
    if (bannerView_) {
        [bannerView_ removeFromSuperview];
    }
}
- (void)dealloc{
    // AdMobBannerviewの開放
    bannerView_ = nil;
    // nendの開放
    [self.nadView setDelegate:nil];//delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease,nilをセット

    // [super dealloc]; // MRC(非アーク時には必要)
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Segue
// previewVCとplayVCへ遷移するときの値渡し
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToPreviewVC"]) {
        previewVC *pVC = [segue destinationViewController];
        pVC.selectedImage = _selectedImage;
        pVC.selectedIndexPath = _selectedIndexPath;
        
        
    }else if([segue.identifier isEqualToString:@"moveToPlayVC"]){
        playVC *playVC = [segue destinationViewController];
        playVC.selectedImage = _selectedImage;
        playVC.selectedIndexPath = _selectedIndexPath;
    }
    // Assuming you've hooked this all up in a Storyboard with a popover presentation style
    //    if ([segue.identifier isEqualToString:@"showPopover"]) {
    //        UINavigationController *destNav = segue.destinationViewController;
    //        previewVC *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"previewVC"];
    //        previewController = destNav.viewControllers.firstObject;
    //
    //        // This is the important part
    //        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
    //        popPC.delegate = self;
    //    }
    
}

// previewVCとplayVCへ遷移するときの条件設定
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"pushToPreviewVC"] || [identifier isEqualToString:@"moveToPlayVC"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
        // 選択していた_selectedIndexPath.rowにimageNamesが無い場合は画面遷移させない
        if ([imageNames safeObjectAtIndex:(int)(_selectedIndexPath.row)] == nil) { // 画像の登録が０のとき
            [self actionShowAlert];
            return NO;
        }else { // 選択中の画像がimageNamesにないとき
            NSString *imageName = [imageNames objectAtIndex:(int)(_selectedIndexPath.row)];
            NSString *selectedImageName = [defaults objectForKey:@"KEY_selectedImageName"];
            NSLog(@"imageNameAtIndexPath.row:%@",imageName);
            NSLog(@"selectedImageName:%@",selectedImageName);
            // 選択していた_selectedIndexPath.rowのimageNameとselectedImageNameが異なる場合は遷移させない
            if (![imageName isEqualToString:selectedImageName]) {
                [self actionShowAlert];
                return NO;
            }
        }
    }
    return YES;
}

// previewVCとplayVCから戻ってきたときの処理
- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"backFromSecondVC"]) {
        // ここに必要な処理を記述
            NSLog(@"ここまではきてる");
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
        }
        else{
            NSLog(@"iPadの処理");
            if (_pickerContainerView) {
                          [_pickerContainerView dismissViewControllerAnimated:YES completion:nil];
            }
        }
        [self.collectionView reloadData];
     
    }else if ([segue.identifier isEqualToString:@"BackFromPreviewVCRemoveItemBtn"]){
        // _selectedIndexPathのアイテムを削除
        [self actionRemoveItem:_selectedIndexPath];

        NSLog(@"BackFromPreviewVCRemoveItemBtn");
        NSLog(@"selectedIndexPath:%d",(int)_selectedIndexPath);
    }else if ([segue.identifier isEqualToString:@"BackFromTappedImageVCSetImageBtn"]){
        [self actionSetSelectedImage:_tappedIndexPath];
        NSLog(@"BackFromPreviewVCSetImage");
    }else if ([segue.identifier isEqualToString:@"BackFromTappedImageVCRemoveItemBtn"]){
        [self actionRemoveItem:_tappedIndexPath];
    }else if ([segue.identifier isEqualToString:@"BackFromSettingVC"]){
        [self viewDidLayoutSubviews];
    }else if ([segue.identifier isEqualToString:@"BackFromPurcasedVC"]){
        [self viewDidLayoutSubviews];
    }
}

#pragma mark -
#pragma mark collectionView delegate
// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *) collectionView{
    return 1;
}
// アイテム数
- (NSInteger)collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger)section{
    // arrayにデータが入ってる配列数を返す
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    int count = (int)[imageNames count];
    
    // userdefaultsの中身確認(デバッグ用)
    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //    NSDictionary *dic = [defaults persistentDomainForName:appDomain];
    //    NSLog(@"defualts:%@", dic);
    
    return  count + 1;
    NSLog(@"numberOfItemsInSection%d",count);
}

// セルの内容を作る
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"-----------------------------------------");

    // セルを作成する
    BICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    
    NSString *selectedImageName = [defaults objectForKey:@"KEY_selectedImageName"];
    
//    [cell.imageView setFrame:cell.frame];
//    [cell.imageViewSelectedFrame setFrame:cell.frame];
    if ([imageNames safeObjectAtIndex:(int)(indexPath.row)] == nil) {
//        NSLog(@"nilだ");
        UIImage *image = [UIImage imageNamed:@"AddImageSoftWhitePink"]; // from AssetCatalog
        [cell.imageView setImage:image];
        NSLog(@"imageViewSize:%@",NSStringFromCGSize(cell.imageView.frame.size));
        NSLog(@"addViewSize:%@",NSStringFromCGSize(cell.imageViewSelectedFrame.frame.size));
        

    } else{
        // NSDataからUIImageを作成
//        NSLog(@"nilじゃない");
        NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];

        if ([imageName isEqualToString:selectedImageName]) {// 黄色い三角形を右上に表示させる
            _selectedIndexPath = indexPath; // ここで初めてselectedIndexPathを更新
            _selectedImage = image;
            
            // frameをつける
            UIImage *imageFrame = [UIImage imageNamed:@"SelectTagOnDarkRed"]; // from AssetCatalog
            [cell.imageViewSelectedFrame setImage:imageFrame];
            [cell.imageViewSelectedFrame setAlpha:0.4];

NSLog(@"selectTagViewSize:%@",NSStringFromCGSize(cell.imageViewSelectedFrame.frame.size));
            
            [UIView animateWithDuration:0.6
                             animations:^{
                                  [cell.imageViewSelectedFrame setAlpha:1];
                             }
                             completion:^(BOOL finished){
                                 
                             }];
            [_selectedCell.imageView setImage:image];

            NSLog(@"CustomUIView.selectedIndexNum:%d",(int)self.customUIView.selectedIndexNum);
             NSLog(@"Main_customUIView.frame x:%d y:%d",(int)self.customUIView.frame.origin.x,(int)self.customUIView.frame.origin.y);

        }
                [cell.imageView setImage:image];

    }
    return cell;
}

// UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = floor(_collectionView.bounds.size.width / 3);
    CGFloat cellHeight = cellWidth;
    CGSize size = CGSizeMake(cellWidth, cellHeight);
//    NSLog(@"colVWidth:%f",_collectionView.bounds.size.width);
//    NSLog(@"cellSize:%@", NSStringFromCGSize(size));
    return size;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat viewWidth = _collectionView.bounds.size.width;
    int cellMargin = (int)viewWidth % 3;
    UIEdgeInsets spacing;
    if (cellMargin == 0) {
        spacing = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (cellMargin == 2){
        spacing = UIEdgeInsetsMake(0, 1, 0, 1);
    }
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing;
    spacing = 0;
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing;
    spacing = 0;
    return spacing;
}

// セクションヘッダーに画像を追加

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
//        _collectionHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//        // headerに画像をセット
//        [_collectionHeaderView.imageView setImage:[UIImage imageNamed:@"karadamonomaneLogo3@2x.png"]];
//        _collectionHeaderView.imageView.tintColor =  RGB(231, 76, 69);//ALIZALIN
//
//        reusableView = _collectionHeaderView;
//    }
//    return reusableView;
//}


#pragma - mart motionAction
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    // 選択中の画像がimageNamesにないとき
        NSString *selectedImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_selectedImageName"];
        NSLog(@"selectedImageName:%@",selectedImageName);
        // 選択していた_selectedIndexPath.rowのimageNameとselectedImageNameが異なる場合は遷移させない
        if ([selectedImageName isEqualToString:@"NO_IMAGE"]) {
            [self actionShowAlert];
        }else {
            if (_startPlayingByShakeOn) {
                if (_startPlayingWithVibeOn) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                [self performSegueWithIdentifier:@"moveToPlayVC" sender:self];
            }

        }
}
#pragma mark -
#pragma mark touchAction
- (IBAction)previewUIBtn:(UIButton *)sender {
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        // iPhoneの処理
        // storyboard上でpushでの画面遷移処理は完結。画像表示処理をpreviewVCで実装。
        
    }
    else{
        // iPadの処理
        // storyboard上でポップアップ表示処理は完結。画像表示処理をpreviewVCで実装。
    }
}

- (IBAction)settingsUIBtn:(UIButton *)sender {

    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        // iPhoneの処理
        // storyboard上でpushでの画面遷移処理は完結。画像表示処理をpreviewVCで実装。
        
    }
    else{
        // iPadの処理
        // storyboard上でポップアップ表示処理は完結。画像表示処理をpreviewVCで実装。
    }
}


// サファリを起動
- (IBAction)searchUIBtn:(UIButton *)sender { // UIButton用
    
    NSURL *url = [NSURL URLWithString:@"https://www.google.com/search?tbm=isch&q="];
    
    [[UIApplication sharedApplication] openURL:url];
}

// カメラ起動のピッカー生成
- (void)launchCam{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;// シミュレーターだと'Source type 1 not available'のエラーが出るのは仕様。実機を使ってテストしてね。
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:_imagePicker
                               animated:YES completion:nil];
        }];
    }

}

// カメラロールのピッカー生成
- (void)launchOrg{
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
            if (_pickerContainerView) {
                [_pickerContainerView dismissViewControllerAnimated:YES completion:nil];
            }
            // フォトライブラリから画像を選ぶ

            _pickerContainerView = [[UIViewController alloc] init];

            [_pickerContainerView.view addSubview:_imagePicker.view];
            if (_iOSVer > 8.0) { // iOS8のとき
                [_pickerContainerView setPreferredContentSize:CGSizeMake(580, 600)]; // 580,600
                _pickerContainerView.modalPresentationStyle = UIModalPresentationPopover;
                _popoverPresentation = _pickerContainerView.popoverPresentationController;
                _popoverPresentation.sourceView = self.view;
                _popoverPresentation.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
                [_popoverPresentation setPermittedArrowDirections:0];
                 [self presentViewController:_pickerContainerView animated:YES completion:nil];
            } else{ // iOS7のとき
                if (_popoverController) {
                    [_popoverController dismissPopoverAnimated:YES];
                }
                 [_pickerContainerView setPreferredContentSize:CGSizeMake(self.view.frame.size.width/1.4, self.view.frame.size.width/1.4)]; // 580,600
                _popoverController = [[UIPopoverController alloc] initWithContentViewController:_pickerContainerView];
                [_popoverController presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1) inView:self.view permittedArrowDirections:0 animated:YES];
            }
        }
    }
    
}


// アクションコントローラ表示
- (IBAction)showOrgBtn:(UIBarButtonItem *)sender {

    [self actionShowOrg];
}
// 画面遷移できないときのアラート表示
- (void)actionShowAlert{

    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"First,PleaseAddImage.", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"Tap+IconToAddImageFromAlbumOrCam", nil)];
    
    //処理
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // Cancel タップ時の処理
                                                               
                                                           }]];
        // アクションコントローラーを表示
        [self presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        
        // アクションシートを表示
        [alert show];
        
    }
    
}

// 保存できる画像を９個までに制限するアラート
- (void)actionShowSaveLimitAlert{
    //処理
    NSString *tmp = NSLocalizedString(@"ImagesThatCanBeSavedIs%d", nil);
    NSString *title = [NSString stringWithFormat:tmp, _limitedNumberOfImages];
    NSString *message;
    if (_purchased) {
        message = nil;
    }else{
        message = [[NSString alloc] initWithFormat:NSLocalizedString(@"UpgradeFrom9To18InSetting", nil)];
    }


    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理

        
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // Cancel タップ時の処理
                                                               
                                                           }]];
        // アクションコントローラーを表示
        [self presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        
        // アクションシートを表示
        [alert show];
        
    }
}

// セルをタップしたらpreviewVCに遷移しその画像を表示させる
- (void)actionImageTapped:(NSIndexPath *)indexPath{

    _tappedIndexPath = indexPath;
    if (_tappedIndexPath == _selectedIndexPath) {
        previewVC *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"previewVC"];
        pVC.selectedImage = _selectedImage;
        pVC.selectedIndexPath = _tappedIndexPath; // 曲情報を更新・保存するために使う
        [self.navigationController pushViewController:pVC animated:YES];

    } else{
        tappedImageVC *tappedImgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tappedImageVC"];
        // 選択したセルの画像をselectedImageに保存
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
        NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
        
        // NSDataからUIImageを作成
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        tappedImgVC.selectedImage = image;
        tappedImgVC.tappedIndexPath = _tappedIndexPath; // 曲情報を更新・保存するために使う
        [self.navigationController pushViewController:tappedImgVC animated:YES];
    }



}

// collectionView内のセルが押された時の処理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 操作無効
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; // 次の画面が表示されたら解除
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    
    if ([imageNames safeObjectAtIndex:(int)indexPath.row] == nil) {
        [self actionShowOrg];
    } else{
        // iOS8の処理
        [self actionImageTapped:indexPath]; // previewViewに飛ぶ
    }
}

#pragma mark -
#pragma mark imagePickerController

// 写真が選ばれたとき,写真撮影後のデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //   NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //    UIImage *imageEdited = [info objectForKey:UIImagePickerControllerEditedImage];

    UIImage *imagePicked = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"Original width = %f height= %f ",imagePicked.size.width, imagePicked.size.height);
    //Original width = 1440.000000 height= 1920.000000

    // 端末ごとに対応不要にするためスクリーンサイズを取得
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize finalSize;
    finalSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
    NSLog(@"finalSize (%.1f,%.1f)", finalSize.width,finalSize.height);
    
    // selectedPhotoImageに画像を設定
    [self.selectedPhotoImage setImage:[self imageWithImage:imagePicked ConvertToSize:finalSize]];
    
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"EditImage?", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"EditThisImage", nil)];
    NSString *action2 = [[NSString alloc] initWithFormat:NSLocalizedString(@"AddThisImageWithoutEditing", nil)];
    NSString *action3 = [[NSString alloc] initWithFormat:NSLocalizedString(@"Cancel", nil)];

    
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理

        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        [actionController addAction:[UIAlertAction actionWithTitle:action1
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self actionShowEditor:self.selectedPhotoImage.image];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:action2
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self actionAddItem:self.selectedPhotoImage.image];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:action3
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // カメラ起動した場合は消さないとビューが止まっちゃうので
                                                               if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                                                                   [picker dismissViewControllerAnimated:YES completion:nil];
                                                               }
                                                               
                                                               
                                                           }]];

        
        actionController.popoverPresentationController.sourceView = self.view;
        
            // アクションコントローラーを表示
            [picker presentViewController:actionController animated:YES completion:nil];

        
        
        
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = title;
        [actionSheet addButtonWithTitle:action1];
        [actionSheet addButtonWithTitle:action2];
        [actionSheet addButtonWithTitle:action3];
        //        actionSheet.destructiveButtonIndex = 0;
        actionSheet.cancelButtonIndex = 2;
        
        // アクションシートを表示
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
                    [actionSheet showInView:picker.view];
        }
        else{
            NSLog(@"iPadの処理");
                    [actionSheet showInView:self.view];
        }


        
    }
}

// actionShowEditorボタンが押された時の処理
- (void)actionShowEditor:(UIImage *)image
{
    secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
    sVC.selectedImage = image;
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        [_imagePicker presentViewController:sVC animated:YES completion:nil];
    }
    else{
        NSLog(@"iPadの処理");
        if (_imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [_imagePicker dismissViewControllerAnimated:YES completion:^{
                [self presentViewController:sVC animated:YES completion:nil];
            }];
        } else{
            if (_iOSVer >= 8.0) {
                [_pickerContainerView dismissViewControllerAnimated:YES completion:^{
                    [self presentViewController:sVC animated:YES completion:nil];
                }];
            }else {
                [_popoverController dismissPopoverAnimated:YES];
                [self presentViewController:sVC animated:YES completion:nil];
            }
        }

    }
}

// actionAddItemボタンが押された時の処理
- (void)actionAddItem:(UIImage *)image
{
    // ビューのselectedImageに保存
    _selectedImage = image;
    
    // 選択した画像をNSUserDefaultsのKEY_selectedImageに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *tmpImage = UIImagePNGRepresentation(image);
    
    {
        // コレクションビューのデータソースとして保存
        NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
        NSMutableArray *tmpArray = [imageNames mutableCopy];
        
        // 同じ画像をアプリケーションのDocumentsフォルダ内に保存
        NSInteger imageCount = [defaults integerForKey:@"KEY_imageCount"];
        imageCount ++;

        
        NSString *path = [NSString stringWithFormat:@"%@/image%@.png",[NSHomeDirectory() stringByAppendingString:@"/Documents"],[NSString stringWithFormat:@"%d",(int)imageCount]];
        NSString *pathShort = [NSString stringWithFormat:@"/image%@.png",[NSString stringWithFormat:@"%d",(int)imageCount]];
        
        [tmpImage writeToFile:path atomically:YES];
        [defaults setInteger:imageCount forKey:@"KEY_imageCount"];
        
        [tmpArray addObject:pathShort];
        // [tmpArray addObject:[NSString stringWithFormat:@"../Documents/image%@.png",[NSString stringWithFormat:@"%d",(int)imageCount]]];
        imageNames = [tmpArray copy];
        [defaults setObject:imageNames forKey:@"KEY_imageNames"];
        
        // KEY_selectedImageNameを更新
        [defaults setObject:pathShort forKey:@"KEY_selectedImageName"];
        {
        // KEY_MusicHundlersByImageNameを追加 ※secondVCからコピペ
        NSArray *array_hundlers = [defaults objectForKey:@"KEY_MusicHundlersByImageName"];
        NSMutableArray *hundlers = [array_hundlers mutableCopy];
        kBIMusicHundlerByImageName *hundler = [kBIMusicHundlerByImageName alloc];
        NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSString stringWithFormat:@"%d",(int)imageCount]];
        hundler.imageName = imageName; // 先頭に"/"も含まれてない ex)"1.png"　何に使うデータかは未定だけど取り敢えずとっておく。
        hundler.rollSoundOn = NO;
        hundler.originalMusicOn = YES;
        hundler.iPodLibMusicOn = NO;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hundler];
        [hundlers addObject:data];
        array_hundlers = [hundlers copy];
        [defaults setObject:array_hundlers forKey:@"KEY_MusicHundlersByImageName"];
        }
    }
    
    [defaults synchronize];
    
    [self.collectionView reloadData];
    
    // 最初の画面に戻る
    [self dismissViewControllerAnimated:YES completion:^{
        self.customUIView.selectedIndexNum = self.selectedIndexPath.row;
        [self.customUIView updateViewItems];

    }];
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
    }
    else{
        NSLog(@"iPadの処理");
        if (_iOSVer < 8.0) {
            [_popoverController dismissPopoverAnimated:YES];
            self.customUIView.selectedIndexNum = self.selectedIndexPath.row;
            [self.customUIView updateViewItems];
        }
    }
}

// action3ボタンが押された時の処理
- (void)action3

{
    
}

#pragma mark -
#pragma mark actionSheet

// カメラロール表示orカメラ起動を選択するアクションコントローラー生成
- (void)actionShowOrg
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"KEY_imageNames"];
    
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"AddImage", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OpenAlbum", nil)];
    NSString *action2 = [[NSString alloc] initWithFormat:NSLocalizedString(@"TakeAPhoto", nil)];
    NSString *action3 = [[NSString alloc] initWithFormat:NSLocalizedString(@"Cancel", nil)];
    
    if ([array count] >= _limitedNumberOfImages) { // 保存できる画像を9個/18個に制限
        [self actionShowSaveLimitAlert];

    }else{
        //処理
//        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (_iOSVer >=8.0) {// iOS8の処理
            // アクションコントローラー生成
            UIAlertController *actionController =
            [UIAlertController alertControllerWithTitle:title
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
            [actionController addAction:[UIAlertAction actionWithTitle:action1
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self launchOrg];
                                                                   
                                                               }]];
            [actionController addAction:[UIAlertAction actionWithTitle:action2
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self launchCam];
                                                                   
                                                               }]];
            [actionController addAction:[UIAlertAction actionWithTitle:action3
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                                   // Cancel タップ時の処理
                                                                   
                                                                   
                                                               }]];
            actionController.popoverPresentationController.sourceView = self.view;

            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            // UIActionSheetを生成
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            actionSheet.title = title;
            [actionSheet addButtonWithTitle:action1];
            [actionSheet addButtonWithTitle:action2];
            [actionSheet addButtonWithTitle:action3];
            //        actionSheet.destructiveButtonIndex = 0;
            actionSheet.cancelButtonIndex = 2;

            // アクションシートを表示
            [actionSheet showInView:self.view];
        }

    }

}

// iOS 7でアクションシートのボタンが押された時の処理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex]; // ボタンのタイトルで処理を分岐させる
    if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"OpenAlbum", nil)]]) {
        [self launchOrg];
    }else if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"TakeAPhoto", nil)]]){
        [self launchCam];
    }else if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"EditThisImage", nil)]]){
        [self actionShowEditor:self.selectedPhotoImage.image];
    }else if ([buttonTitle isEqualToString:[[NSString alloc] initWithFormat:NSLocalizedString(@"AddThisImageWithoutEditing", nil)]]){
        [self actionAddItem:self.selectedPhotoImage.image];
    }
}

// 選択したセルの画像をセット
- (void)actionSetSelectedImage:(NSIndexPath *)indexPath{
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
    }
    else{
        NSLog(@"iPadの処理");
        if (_iOSVer < 8.0) {
              [_popoverController dismissPopoverAnimated:YES];
        }
    }

    // 選択したセルの画像をselectedImageに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
    
    // NSDataからUIImageを作成
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    // ビューのselectedImageに保存
    _selectedImage = image;

    [defaults setObject:imageName forKey:@"KEY_selectedImageName"];
    [defaults synchronize];
    
    _selectedIndexPath = indexPath;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView reloadData];
    
}

- (void)actionRemoveItem:(NSIndexPath *)indexPath{
    // データソースから項目を削除する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"KEY_imageNames"];
    NSMutableArray *imageNames = [array mutableCopy];
    NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
    
    // 次の選択中セルを決める
    if (indexPath == _selectedIndexPath) { // indexPathがtappedIndexPathの場合はselectedImageNameの変更は不要
        // KEY_selectedImageNameを更新することでとなりのセルを選択状態にする
        if ((int)(indexPath.row) == 0) { // 削除するのが配列の一番最初のアイテムだった場合
            if ([imageNames count] == 1) { // かつ最後のひとつのアイテムだった場合
                [defaults setObject:@"NO_IMAGE" forKey:@"KEY_selectedImageName"]; // No Images
            }else{// アイテムが2つ以上残っている場合
                NSString *rightImageName = [imageNames objectAtIndex:(int)(indexPath.row)+1];
                [defaults setObject:rightImageName forKey:@"KEY_selectedImageName"];
            }
            
        }else if((int)(indexPath.row) == ([imageNames count]-1)){ // 削除するのが配列の最後のアイテムだった場合
            NSString *leftImageName = [imageNames objectAtIndex:(int)(indexPath.row)-1];
            [defaults setObject:leftImageName forKey:@"KEY_selectedImageName"];
        }else { // 上記以外の場合
            NSString *rightImageName = [imageNames objectAtIndex:(int)(indexPath.row)+1];
            [defaults setObject:rightImageName forKey:@"KEY_selectedImageName"];
        }
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    [imageNames removeObjectAtIndex:indexPath.row];
    array = [imageNames copy];
    [defaults setObject:array forKey:@"KEY_imageNames"];
    NSArray *array_hundlers = [defaults objectForKey:@"KEY_MusicHundlersByImageName"];
    NSMutableArray *hundlers = [array_hundlers mutableCopy];
    [hundlers removeObjectAtIndex:indexPath.row];
    array_hundlers = [hundlers copy];
    [defaults setObject:array_hundlers forKey:@"KEY_MusicHundlersByImageName"];
    [defaults synchronize];
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    if ([imageNames count] == (kLIMITED_ITEM_NUMBER -1)) { // 削除後９個目のセルに画像追加ボタンを表示するためにBathchUpdateしないでreloadDataしちゃう
        [self.collectionView reloadData];
    } else{
        [self.collectionView performBatchUpdates:^{
            NSLog(@"入ってる");
            // コレクションビューから項目を削除する
            [self.collectionView deleteItemsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
        } completion:^(BOOL finish){

            [self.collectionView reloadData]; // 明示的にreloadしてセルを再度生成

        }];
    }
}



// 縦横長い方に合わせて縮小する
-(UIImage *)imageWithImage:(UIImage *)image ConvertToSize:(CGSize)size {
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
             [self dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark AdMobBannerDelegate

- (void)addAdBanners{
    NSLog(@"AdBanners");
    // サイズを指定してAdMobインスタンスを生成
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // AdMobのパブリッシャーIDを指定
    NSString *bannerUnitID;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){ // nendのバナー広告をメディエーションで組み込んでおり、nendのバナー広告は自動でサイズ調整を行わないので２つのADMOBバナー広告を用意している。
        bannerUnitID = MY_BANNER_UNIT_ID;
    }
    else{
        bannerUnitID = MY_BANNER_UNIT_ID;
        //        bannerUnitID = MY_BANNER_UNIT_ID_FOR_iPAD;
    }
    bannerView_.adUnitID = bannerUnitID;
    
    // AdMob広告を表示するViewController(自分自身)を指定し、ビューに広告を追加
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // ビューの一番下に表示
    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - bannerView_.bounds.size.height/2)];
    
    // 【Ad】AdMob広告データの読み込みを要求
    { // iPadテスト用バナー表示
        GADRequest *testRequest = [GADRequest request];
        testRequest.testDevices = [NSArray arrayWithObjects:
                                   GAD_SIMULATOR_ID,@"728ca28ae78b1830d399efec414dd550", nil];// iPhone
//        testRequest.testDevices = [NSArray arrayWithObjects:
//                                   GAD_SIMULATOR_ID,@"45f1d4a8dbc44781969f09433ccac7e0", nil]; // ipad
        [bannerView_ loadRequest:testRequest];
    }
        [bannerView_ loadRequest:[GADRequest request]]; // 本番はこの行だけでいい
    
    
    // AdMobバナーの回転時のautosize
    //        bannerView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    //NADViewの作成
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //            NSLog(@"iPhoneの処理");
    //            self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    //            [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)];
    //            // (3) ログ出力の指定
    //            [self.nadView setIsOutputLog:YES];
    //            // (4) set apiKey, spotId.
    //            //        [self.nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"]; // テスト用
    //            [self.nadView setNendID:@"139154ca4d546a7370695f0ba43c9520730f9703" spotID:@"208229"];
    //
    //        }
    //        else{
    //            NSLog(@"iPadの処理");
    //            self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
    //            [self.nadView setCenter:CGPointMake(self.view.bounds.size.width/2, self.nadView.bounds.size.height/2)]; // ヘッダー
    //            // (3) ログ出力の指定
    //            [self.nadView setIsOutputLog:NO];
    //            // (4) set apiKey, spotId.
    //            //      [self.nadView setNendID:@"2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a" spotID:@"70999"]; // テスト用
    //            [self.nadView setNendID:@"19d17a40ad277a000f27111f286dc6aaa0ad146b" spotID:@"220604"];
    //
    //        }
    //        [self.nadView setDelegate:self]; //(5)
    //        [self.nadView load]; //(6)
    //        [self.view addSubview:self.nadView]; // 最初から表示する場合
}


// AdMobバナーのloadrequestが失敗したとき
-(void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
    // 他の広告ネットワークの広告を表示させるなど。
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

// ステータスバーの文字色を設定
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //文字を白くする
   //    return UIStatusBarStyleDefault; // デフォルト値（文字色は黒色）
}

//スクリーンショット撮影用
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
@end