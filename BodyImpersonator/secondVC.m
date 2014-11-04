//
//  secondVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/09/09.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "secondVC.h"
#import "ViewController.h"

@interface secondVC (){
    UIActionSheet *_actionSheetAlert;
    CGPoint _startCenterPoint;
}

- (IBAction)tapDoneBarBtn:(UIBarButtonItem *)sender;
- (IBAction)dragging:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *editorOutlineImageView;
- (IBAction)undo:(UIBarButtonItem *)sender;

@end

@implementation secondVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"secondVC didLoad!!");
    
    // scrollViewのデリゲート先になる
    _imageScrollView.delegate = self;
    // ズームの最小値/最大値を設定する
    _imageScrollView.minimumZoomScale = 0.5;
    _imageScrollView.maximumZoomScale = 4;
    
    // スクローラを表示する
    _imageScrollView.scrollEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = YES;
    _imageScrollView.showsVerticalScrollIndicator = YES;
    
    // ダブルタップジェスチャーを作る
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    _editImageView.userInteractionEnabled = YES;
    [_editImageView addGestureRecognizer:doubleTapGesture];
    
    [self.editImageView setImage:_selectedImage];
    _startCenterPoint = _imageScrollView.center;
    // navigationBarとtoolBarを表示する
    [_navigationBar setHidden:0];
    [_toolBar setHidden:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 写真をピンチイン/アウトで拡大できるようにする
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _editImageView;
}



// 写真がダブルタップされたならば拡大/縮小する
- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    // 最大倍率でなければ拡大する
    if (_imageScrollView.zoomScale < _imageScrollView.maximumZoomScale) {
        // 現在の2.25倍の倍率にする
        float newScale = _imageScrollView.zoomScale * 1.5;
        // 拡大する領域を決める
        CGRect zoomRect = [self zoomRectForScale:newScale];
        // タップした位置を拡大する
        [_imageScrollView zoomToRect:zoomRect animated:YES];
        
    } else{
        // 倍率１に戻す
        [_imageScrollView setZoomScale:1.0 animated:YES];
    }
}

// 指定の座標を中心にして拡大する領域を決める
- (CGRect)zoomRectForScale:(float)scale{
    CGRect zoomRect;
    // 倍率から拡大する縦横サイズを求める
    zoomRect.size.width = [_imageScrollView frame].size.width / scale;
    zoomRect.size.height = [_imageScrollView frame].size.height / scale;
    // 拡大時に中心がずれないように座標(左上)を設定する
    zoomRect.origin.x = self.view.center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = self.view.center.y - (zoomRect.size.height / 2.0);
    // 領域を返す
    return zoomRect;
}

- (IBAction)dragging:(UIPanGestureRecognizer *)sender {
    // ドラッグ移動したベクトル
    CGPoint translation = [sender translationInView:self.view];
    // editImageViewの座標をドラッグした量だけ加算する
    CGPoint homeLoc = _editImageView.center;
    homeLoc.x += translation.x;
    homeLoc.y += translation.y;
    _editImageView.center = homeLoc;
    // ドラッグ開始位置をリセットする
    [sender setTranslation:CGPointZero inView:self.view];
    
}

// Cancelをタップしたら最初のビューコントローラーに戻る
- (IBAction)tapCancelBarBtn:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}


// Doneタップ時のアクションコントローラーを作成
- (IBAction)tapDoneBarBtn:(UIBarButtonItem *)sender {

        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"Add this image?"
                                            message:@"Message"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Add this Image"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self actionAddImage];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               // Cancel タップ時の処理
                                                           }]];
        // iOS8の処理
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        }
        else{
            NSLog(@"iPadの処理");
            // popoverを開く
            UIBarButtonItem *btn = sender;

            actionController.popoverPresentationController.sourceView = self.view;
            actionController.popoverPresentationController.sourceRect = CGRectMake(100.0, 100.0, 20.0, 20.0);
            actionController.popoverPresentationController.barButtonItem = btn;
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];

        }


    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
        actionSheet.delegate = self;
        actionSheet.title = @"Add this Image?";
        [actionSheet addButtonWithTitle:@"OK"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        //        actionSheet.destructiveButtonIndex = 0;
        actionSheet.cancelButtonIndex = 1;
//            [actionSheet showInView:self.view];
        
        // デバイスがiphoneであるかそうでないかで分岐
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSLog(@"iPhoneの処理");
            // アクションシートを表示
            [actionSheet showInView:self.view];
        }
        else{
            NSLog(@"iPadの処理");
            // アクションシートをpopoverで表示
            UIBarButtonItem *btn = sender;
            [actionSheet showFromBarButtonItem:btn animated:YES];
        }
    }
}

// 画面のスナップショット画像を作成
- (UIImage *)snapFullDisplay
{
    // スナップショットを保存するのでナビゲーションバーとツールバーを非表示にする
    [_navigationBar setHidden:1];
    [_toolBar setHidden:1];
    [_editorOutlineImageView setHidden:1];

    //現在のeditImageViewの画像を取得する
    //描画領域の設定
    CGSize cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(cropSize);
    //グラフィックコンテキストの取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 切り取った内容をUIImageとして保存
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

// action3ボタンが押された時の処理
- (void)action3
{
    
}

// 画像をファイル保存/ファイル名をimageNamesに保存
- (void)actionAddImage{
    // Add this Image タップ時の処理
    
    // 画像スナップをファイルとして保存
    UIImage *image = [self snapFullDisplay];
    NSData *tmpImage = UIImagePNGRepresentation(image);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    {
        // コレクションビューのデータソースとして保存
        NSArray *array = [defaults objectForKey:@"KEY_imageNames"];
        NSMutableArray *imageNames = [array mutableCopy];
        // 追加するセルを選択状態にするために配列のindexを保存
        int selectedIndex = (int)[imageNames count];
        NSLog(@"selectedIndexWrite:%d",selectedIndex);
        [defaults setInteger:selectedIndex forKey:@"KEY_addedIndexNum"];
        
        // ファイル名を作成しDocumentフォルダにそのファイル名として保存
        NSInteger imageCount = [defaults integerForKey:@"KEY_imageCount"];
        imageCount ++;
        NSString *path = [NSString stringWithFormat:@"%@/image%@.png",[NSHomeDirectory() stringByAppendingString:@"/Documents"],[NSString stringWithFormat:@"%d",(int)imageCount]];
        NSString *pathShort = [NSString stringWithFormat:@"/image%@.png",[NSString stringWithFormat:@"%d",(int)imageCount]];// ファイル名の末尾数字を+1
        [tmpImage writeToFile:path atomically:YES]; // ファイルとして保存
        [defaults setInteger:imageCount forKey:@"KEY_imageCount"];
        
        [imageNames addObject:pathShort]; // データソースKEY_imageNamesに追加

        array = [imageNames copy]; // NSUserDefaultsに保存するためにNSMutableArray→NSArrayにcopy
        // KEY_imageNamesを更新
        [defaults setObject:array forKey:@"KEY_imageNames"];
        // KEY_selectedImageNameを更新
        [defaults setObject:pathShort forKey:@"KEY_selectedImageName"];
    }
    
    [defaults synchronize];
    
    // 最初の画面に戻る
    [self performSegueWithIdentifier:@"backFromSecondVC" sender:self];

}
// iOS 7でアクションシートのボタンが押された時の処理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _actionSheetAlert) {
        switch (buttonIndex) {
            case 0:
                // firstViewControllerに戻った時にpickerを閉じるためにUnwindSegueで戻る
                [self performSegueWithIdentifier:@"backFromSecondVC" sender:self];
                
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                [self actionAddImage];
                break;
            case 1:
                [self action3];
                break;
            default:
                break;
        }
    }

}

// このビューを開いた時の状態に画像を調節
- (IBAction)undo:(UIBarButtonItem *)sender {
    // 倍率１、センターに戻す
    [_imageScrollView setZoomScale:1.0 animated:YES];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                          [_editImageView setCenter:_startCenterPoint];
                     } completion:nil];
   
}
@end
