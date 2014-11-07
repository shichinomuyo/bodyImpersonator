//
//  ViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "ViewController.h"
// collectionViewの最大アイテム数
static const NSInteger kMAX_ITEM_NUMBER = 9;

@interface ViewController ()
{
    UIImagePickerController *_imagePicker;
    UIPopoverController *_imagePopController;
    BICollectionViewCell *_selectedCell;
    BICollectionReusableView *_collectionHeaderView;

}

// IBOutlet Btn
@property (weak, nonatomic) IBOutlet UIButton *ctrlBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previewIcon;
// IBOutlet Image
@property (weak, nonatomic) IBOutlet UIImageView *selectedPhotoImage; // secondVCへの画像データ渡し用
// IBOutlet collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// previewImageViewの表示をコントールするために宣言
@property (weak, nonatomic) IBOutlet UIButton *nestViewCtrlBtn;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIView *nestView;

// IBAction Btn
- (IBAction)previewBtn:(UIBarButtonItem *)sender;
- (IBAction)showOrgBtn:(UIBarButtonItem *)sender;


// IBAction プレビューウィンドウをポップアップの子ビューにするときの非表示ボタン
- (IBAction)nestViewCtrlBtn:(UIButton *)sender;

@end

#pragma mark -
@implementation ViewController
#pragma mark initialize
+ (void) initialize{
    // 初回起動時の初期データ
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setObject:@"0" forKey:@"KEY_countUpCrashPlayed"]; //　crash再生回数
    [appDefaults setObject:@"NO" forKey:@"KEY_ADMOBinterstitialRecieved"]; // インタースティシャル広告受信状況
    // collectionViewに表示する画像を保存する配列の作成・初期化
    NSMutableArray *imageNames = [NSMutableArray array];
    NSArray *array = [imageNames copy];
    [appDefaults setObject:array forKey:@"KEY_imageNames"];
    // collectionViewに表示する画像に番号を振るために整数値を作成・初期化
    [appDefaults setObject:@"0" forKey:@"KEY_imageCount"];
    
    // ユーザーデフォルトの初期値に設定する
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:appDefaults];
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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // 広告表示
    //    [self viewAdBanners];
    NSLog(@"最初のviewDidLoad");
    
    // iOS7以上の場合はnavigationBarの高さを64pxにする
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.naviBarHeight.constant = 64;
    }
    // collectionViewにヘッダーを追加
 //   [_collectionView registerClass:[combineIconLogo class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewHeader"];
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
//    [self.collectionView performBatchUpdates:^{
//        NSLog(@"入ってる");
//        [UIView animateWithDuration:0
//                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             [_selectedCell.imageViewSelectedFrame setAlpha:1];
//                         } completion:nil];
//    } completion:nil];

    // 再生回数が3の倍数かつインタースティシャル広告の準備ができていればインタースティシャル広告表示
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger i = [defaults integerForKey:@"KEY_countUpCrashPlayed"];
    BOOL b = [defaults boolForKey:@"KEY_ADMOBinterstitialRecieved"];
    NSLog(@"countUpCrashPlayed %ld", (long)i);
    
    if (b == NO) {
        [self interstitialLoad];
    }
    
    if (((i % 3) == 0) && (b == YES)) {
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

#pragma mark -
#pragma mark Segue
// previewVCとplayVCへ遷移するときの値渡し
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToPreviewVC"]) {
        previewVC *pVC = [segue destinationViewController];
        pVC.selectedImage = _selectedImage;
        
    }else if([segue.identifier isEqualToString:@"moveToPlayVC"]){
        playVC *playVC = [segue destinationViewController];
        playVC.selectedImage = _selectedImage;
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
        if ([imageNames safeObjectAtIndex:(int)(_selectedIndexPath.row)] == nil) {
            [self actionShowAlert];
            return NO;
        }else {
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
        [self.collectionView reloadData];
    }else if ([segue.identifier isEqualToString:@"BackFromPreviewVCRemoveItemBtn"]){
        // _selectedIndexPathのアイテムを削除
        [self actionRemoveItem:_selectedIndexPath];
        NSLog(@"BackFromPreviewVCRemoveItemBtn");
        NSLog(@"selectedIndexPath:%d",(int)_selectedIndexPath);
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
//    if (count < kMAX_ITEM_NUMBER) {
//        return count+1;
//    } else {
//        return count;
//    }
    return  count + 1;
    NSLog(@"numberOfItemsInSection%d",count);
}

// セルの内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"-----------------------------------------");
    // セルを作成する
    BICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1]; // cell.imageViewで置き換え済み
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    
    NSString *selectedImageName = [defaults objectForKey:@"KEY_selectedImageName"];

    if ([imageNames safeObjectAtIndex:(int)(indexPath.row)] == nil) {
        NSLog(@"nilだ");
        UIImage *image = [UIImage imageNamed:@"AddImage.png"];
        [cell.imageView setImage:image];
        // frameをつける
//        cell.backgroundColor = [UIColor whiteColor];
//        UIImage *imageFrame = [UIImage imageNamed:@"CollectionViewCellFrame188x188.png"];
//        [cell.imageViewFrame setImage:imageFrame];
        //        NSLog(@"黒いFrameつけるお");
    } else{
        // NSDataからUIImageを作成
        NSLog(@"nilじゃない");
        NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"filePath:%@",filePath);
        NSLog(@"imageName:%@",imageName);
        if ([imageName isEqualToString:selectedImageName]) {
            _selectedIndexPath = indexPath; // 画像追加時はうまく動く
            _selectedImage = image;
            
            // _selectedCellを利用
            _selectedCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            // frameをつける
            UIImage *imageFrame = [UIImage imageNamed:@"SelectTag@2x.png"];
            [cell.imageViewSelectedFrame setImage:imageFrame];
            [cell.imageViewSelectedFrame setAlpha:1];
//            [_selectedCell.imageView setImage:image];
            
            NSLog(@"選択中Frameつけるお");
            NSLog(@"imageviewSizeSelected:(%.2f,%.2f)",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
            NSLog(@"imageviewFrameRect:(%.2f,%.2f,%.2f,%.2f)",cell.imageViewFrame.frame.origin.x, cell.imageViewFrame.frame.origin.y, cell.imageViewFrame.frame.size.width,cell.imageViewFrame.frame.size.height);
        }
        [cell.imageView setImage:image];

    }
    return cell;
}

// セクションに画像を追加
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        _collectionHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        // headerに画像をセット
        [_collectionHeaderView.imageView setImage:[UIImage imageNamed:@"karadamonomaneLogo3@2x.png"]];
        _collectionHeaderView.imageView.tintColor =  RGB(241, 197, 18);//nearlyBlack

        reusableView = _collectionHeaderView;
    }
    return reusableView;
}

#pragma mark -
#pragma mark touchAction

// previewImageViewが乗ったnestViewの表示を消す
- (IBAction)nestViewCtrlBtn:(UIButton *)sender {
    [self.nestView setHidden:1];
    [self.nestViewCtrlBtn setHidden:1];
}

- (IBAction)previewBtn:(UIBarButtonItem *)sender {
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

// カメラ起動のピッカー生成
- (void)launchCam{
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;// シミュレーターだと'Source type 1 not available'のエラーが出るのは仕様。実機を使ってテストしてね。
    _imagePicker.delegate = self;
    [self presentViewController:_imagePicker
                       animated:YES completion:nil];
    
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
            // フォトライブラリから画像を選ぶ
            [self presentViewController:_imagePicker animated:YES completion:nil];
            // Popoverの確認・開かれている場合は一度閉じる
            //            if (_imagePopController) {
            //                if ([_imagePopController isPopoverVisible]) {
            //                    [_imagePopController dismissPopoverAnimated:YES];
            //                }
            //            }
            //
            //            // popoverを開く
            //            _imagePicker.preferredContentSize = CGSizeMake(768, 1024);
            //            _imagePopController = [[UIPopoverController alloc] initWithContentViewController:_imagePicker];
            //
            //            // popoverをバーボタンから表示
            //            [_imagePopController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    }
    
}


// アクションコントローラ表示
- (IBAction)showOrgBtn:(UIBarButtonItem *)sender {

    [self actionShowOrg];
}

// 画面遷移できないときのアラート表示
- (void)actionShowAlert{
    //処理
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"First,Please tap + icon to add Image."
                                            message:nil
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"First,Please tap + icon to add Image"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        //        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        //        actionSheet.delegate = self;
        //        actionSheet.title = @"First,Please tap + icon to add Image.?";
        //        [actionSheet addButtonWithTitle:@"Cancel"];
        //        //        actionSheet.destructiveButtonIndex = 0;
        //        actionSheet.cancelButtonIndex = 0;
        
        // アクションシートを表示
        [alert show];
        
    }
    
}

// 保存できる画像を９個までに制限するアラート
- (void)actionShowSaveLimitAlert{
    //処理
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"It is up to 9 can be saved"
                                            message:nil
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"It is up to 9 can be saved."
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        //        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        //        actionSheet.delegate = self;
        //        actionSheet.title = @"First,Please tap + icon to add Image.?";
        //        [actionSheet addButtonWithTitle:@"Cancel"];
        //        //        actionSheet.destructiveButtonIndex = 0;
        //        actionSheet.cancelButtonIndex = 0;
        
        // アクションシートを表示
        [alert show];
        
    }
}

// collectionView内のセルが押された時の処理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *imageNames = [defaults objectForKey:@"KEY_imageNames"];
    
    if ([imageNames safeObjectAtIndex:(int)indexPath.row] == nil) {
        [self actionShowOrg];
        
    } else{
        //処理
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (class) {
            // iOS8の処理
            
            // アクションコントローラー生成
            UIAlertController *actionController =
            [UIAlertController alertControllerWithTitle:@"Image selected"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [actionController addAction:[UIAlertAction actionWithTitle:@"Set this Image"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self actionSetSelectedImage:indexPath];
                                                               }]];
            
            [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                                   // Cancel タップ時の処理
                                                               }]];
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            
            // UIActionSheetを生成
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            actionSheet.title = @"Edit Image?";
            [actionSheet addButtonWithTitle:@"Set this Image"];
            [actionSheet addButtonWithTitle:@"Cancel"];
            //        actionSheet.destructiveButtonIndex = 0;
            actionSheet.cancelButtonIndex = 1;
            
            // アクションシートを表示
            [actionSheet showInView:self.view];
            
        }
        
    }
    
    
}

#pragma mark -
#pragma mark imagePickerController

// chooseボタンのデリゲートメソッド
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
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"Edit image?"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Edit this Image"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self actionShowEditor:self.selectedPhotoImage.image];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Add this Image"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self actionAddItem:self.selectedPhotoImage.image];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // カメラ起動した場合は消さないとビューが止まっちゃうので
                                                               if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                                                                   [picker dismissViewControllerAnimated:YES completion:nil];
                                                               }
                                                               
                                                               
                                                           }]];
        // アクションコントローラーを表示
        [picker presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = @"Edit Image?";
        [actionSheet addButtonWithTitle:@"Edit this Image"];
        [actionSheet addButtonWithTitle:@"Add this Image"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        //        actionSheet.destructiveButtonIndex = 0;
        actionSheet.cancelButtonIndex = 2;
        
        // アクションシートを表示
        [actionSheet showInView:picker.view];
        
    }
}

// actionShowEditorボタンが押された時の処理
- (void)actionShowEditor:(UIImage *)image
{
    
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
        sVC.selectedImage = image;
        [_imagePicker presentViewController:sVC animated:YES completion:nil];
        //        [_imagePicker dismissViewControllerAnimated:YES completion:nil];
        //       [self.navigationController pushViewController:sVC animated:YES];
        
    }
    else{
        NSLog(@"iPadの処理");
        [_imagePopController dismissPopoverAnimated:YES];
        // secondVCを表示
        secondVC *sVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVC"];
        sVC.selectedImage = image;
        [self presentViewController:sVC animated:YES completion:nil];
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
    }
    
    [defaults synchronize];
    [self.collectionView reloadData];
    
    
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

#pragma mark -
#pragma mark actionSheet

// カメラロール表示orカメラ起動を選択するアクションコントローラー生成
- (void)actionShowOrg
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"KEY_imageNames"];
    if ([array count] == kMAX_ITEM_NUMBER) { // 保存できる画像を９個に制限
        [self actionShowSaveLimitAlert];
    }else{
        //処理
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (class) {
            // iOS8の処理
            
            // アクションコントローラー生成
            UIAlertController *actionController =
            [UIAlertController alertControllerWithTitle:@"Add Image"
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [actionController addAction:[UIAlertAction actionWithTitle:@"Open CameraRoll"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self launchOrg];
                                                                   
                                                               }]];
            [actionController addAction:[UIAlertAction actionWithTitle:@"Take a Photo"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [self launchCam];
                                                                   
                                                               }]];
            [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                                   // Cancel タップ時の処理
                                                                   
                                                                   
                                                               }]];
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            
            // UIActionSheetを生成
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            actionSheet.title = @"Add Image";
            [actionSheet addButtonWithTitle:@"Open CameraRoll"];
            [actionSheet addButtonWithTitle:@"Take a Photo"];
            [actionSheet addButtonWithTitle:@"Cancel"];
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
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Open CameraRoll"]) {
        [self launchOrg];
    }else if ([buttonTitle isEqualToString:@"Take a Photo"]){
        [self launchCam];
    }else if ([buttonTitle isEqualToString:@"Set this Image"]){
        // タップされたセルのindexPathを取得
        NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [selectedItems objectAtIndex:0];
        [self actionSetSelectedImage:indexPath];
    }else if ([buttonTitle isEqualToString:@"Edit this Image"]){
        [self actionShowEditor:self.selectedPhotoImage.image];
    }else if ([buttonTitle isEqualToString:@"Add this Image"]){
        [self actionAddItem:self.selectedPhotoImage.image];
    }
}

// 選択したセルの画像をセット
- (void)actionSetSelectedImage:(NSIndexPath *)indexPath{
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
    _selectedIndexPath = indexPath;
    
    [defaults synchronize];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView reloadData];
    
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
- (void)actionRemoveItem:(NSIndexPath *)indexPath{
    // データソースから項目を削除する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"KEY_imageNames"];
    NSMutableArray *imageNames = [array mutableCopy];
    NSString *imageName = [imageNames objectAtIndex:(int)(indexPath.row)];
    // となりのセルを選択状態にする
    if ((int)(indexPath.row) == 0) { // 削除するのが配列の一番最初のアイテムだった場合
        if ([imageNames count] == 1) { // かつ最後のひとつのアイテムだった場合
            [defaults setObject:@"NO Images." forKey:@"KEY_selectedImageName"]; // No Images
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
    
    NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    [imageNames removeObjectAtIndex:indexPath.row];
    array = [imageNames copy];
    [defaults setObject:array forKey:@"KEY_imageNames"];
    [defaults synchronize];
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    if ([imageNames count] == 8) { // 削除後９個目のセルに画像追加ボタンを表示するためにBathchUpdateしないでreloadDataしちゃう
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
        NSLog(@"image.size (%.2f,%.2f)", image.size.width,image.size.height);
        return image;
    }
    
    CGRect rect = CGRectMake(0, 0,
                             image.size.width  * ratio,
                             image.size.height * ratio);
    NSLog(@"rect.size (%.2f,%.2f)", rect.size.width,rect.size.height);
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

// ステータスバーの文字色を設定
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //文字を白くする
   //    return UIStatusBarStyleDefault; // デフォルト値（文字色は黒色）
}
@end