//
//  secondVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/09/09.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "secondVC.h"
#import "ViewController.h"

@interface secondVC ()
- (IBAction)tapCancelBarBtn:(UIBarButtonItem *)sender;
- (IBAction)saveBtn:(UIBarButtonItem *)sender;
- (IBAction)tapDoneBarBtn:(UIBarButtonItem *)sender;
- (IBAction)dragging:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

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
    _imageScrollView.minimumZoomScale = 0.8;
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
    
    // NSUserDefaultsから画像を取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSDataとして情報を取得
    NSData *imageData = [defaults objectForKey:@"KEY_selectedImage"];
    // NSDataからUIImageを作成
    UIImage *selectedImage = [UIImage imageWithData:imageData];
    [self.editImageView setImage:selectedImage];
    
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

// 拡大写真をピンチイン/アウトできるようにする
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _editImageView;
}



// 写真がダブルタップされたならば拡大/縮小する
- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    // 最大倍率でなければ拡大する
    if (_imageScrollView.zoomScale < _imageScrollView.maximumZoomScale) {
        // 現在の1.25倍の倍率にする
        float newScale = _imageScrollView.zoomScale * 1.25;
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


- (IBAction)tapCancelBarBtn:(UIBarButtonItem *)sender {
    NSLog(@"cancel tapped");
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveBtn:(UIBarButtonItem *)sender {
    // スナップショットを保存するのでナビゲーションバーとツールバーを非表示にする
    [_navigationBar setHidden:1];
    [_toolBar setHidden:1];
    //現在のeditImageViewの画像を取得する
    //描画領域の設定
    CGSize cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(cropSize);
    //グラフィックコンテキストの取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // コンテキストの位置を切り取り開始位置に合わせる
    //    CGPoint point = _editImageView.frame.origin;
    //    CGAffineTransform affineMoveLeftTop
    //    = CGAffineTransformMakeTranslation(
    //                                       -(int)point.x ,
    //                                       -(int)point.y );
    //    CGContextConcatCTM(context , affineMoveLeftTop );
    
    // viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 切り取った内容をUIImageとして保存
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 現在のビューに表示されている画像をNSUserDefaultsに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *editedImage = UIImagePNGRepresentation(image);
    [defaults setObject:editedImage forKey:@"KEY_editedImage"];
    [defaults synchronize];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    
    UIGraphicsEndImageContext();
    
    // UIAlertControllerのOKボタンで閉じる　

}
// カメラロール保存完了を知らせる
- (void) savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo
{
    
    if(_error){//エラーのとき
        
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (class) {
            // iOS8の処理
            
            // アクションコントローラー生成
            UIAlertController *actionController =
            [UIAlertController alertControllerWithTitle:@"Error"
                                                message:@"Save failed"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   // Show editro タップ時の処理
                                                   
                                                                   
                                                               }]];
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            
            // UIActionSheetを生成
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            actionSheet.title = @"Error - Save failed";
            [actionSheet addButtonWithTitle:@"OK"];
            // アクションシートを表示
            [actionSheet showInView:self.view];
            
        }
        
    }else{//保存できたとき
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (class) {
            // iOS8の処理
            
            // アクションコントローラー生成
            UIAlertController *actionController =
            [UIAlertController alertControllerWithTitle:@"Save succeed"
                                                message:@"Message"
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   // Show editro タップ時の処理

                                                                   
                                                               }]];
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            
            // UIActionSheetを生成
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            actionSheet.title = @"Save succeed";
            [actionSheet addButtonWithTitle:@"OK"];
            // アクションシートを表示
            [actionSheet showInView:self.view];
            
        }

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" // @"Succeed"
//                                                        message:@"カメラロールに保存しました。" // @"Save succeeded"
//                                                       delegate:nil
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"OK", nil
//                              ];
//        [alert show];
        
        
        return;
    }
}
// アクションシートでOKボタンが押された時の処理
- (void)actionOK{
    // sVcを消す
    //    [self dismissViewControllerAnimated:YES completion:nil]; // unwindSegueでExitと接続してるのでこの行は不要

}

// iOS 7でアクションシートのボタンが押された時の処理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // firstViewControllerに戻った時にpickerを閉じるためにUnwindSegueで戻る
             [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];

            break;
        default:
            break;
    }
}


- (IBAction)tapDoneBarBtn:(UIBarButtonItem *)sender {
    // スナップショットを保存するのでナビゲーションバーとツールバーを非表示にする
    [_navigationBar setHidden:1];
    [_toolBar setHidden:1];
    //現在のeditImageViewの画像を取得する
    //描画領域の設定
    CGSize cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(cropSize);
    //グラフィックコンテキストの取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // コンテキストの位置を切り取り開始位置に合わせる
//    CGPoint point = _editImageView.frame.origin;
//    CGAffineTransform affineMoveLeftTop
//    = CGAffineTransformMakeTranslation(
//                                       -(int)point.x ,
//                                       -(int)point.y );
//    CGContextConcatCTM(context , affineMoveLeftTop );
    
    // viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 切り取った内容をUIImageとして保存
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 現在のビューに表示されている画像をNSUserDefaultsに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *editedImage = UIImagePNGRepresentation(image);
    [defaults setObject:editedImage forKey:@"KEY_editedImage"];
    [defaults synchronize];
    
    UIGraphicsEndImageContext();
    [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];
//    [self dismissViewControllerAnimated:YES completion:nil]; // unwindSegueでExitと接続してるのでこの行は不要
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
@end
