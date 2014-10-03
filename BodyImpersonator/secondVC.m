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
}
- (IBAction)tapCancelBarBtn:(UIBarButtonItem *)sender;
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
    _imageScrollView.minimumZoomScale = 0.5;
    _imageScrollView.maximumZoomScale = 8;
    
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
    NSData *imageData = [defaults objectForKey:@"KEY_tmpImage"];
    // NSDataからUIImageを作成
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    [self.editImageView setImage:tmpImage];
    
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


- (IBAction)tapCancelBarBtn:(UIBarButtonItem *)sender {
    NSLog(@"cancel tapped");
    [self dismissViewControllerAnimated:YES completion:nil];

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
                                         preferredStyle:UIAlertControllerStyleAlert];
            [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   // Show editro タップ時の処理
                                                                  [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];
                                                                   
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
                                         preferredStyle:UIAlertControllerStyleAlert];
            [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   // Show editro タップ時の処理
                                                                  [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];
                                                                   
                                                               }]];
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];
        } else{
            // iOS7の処理
            
            // UIActionSheetを生成
            _actionSheetAlert = [[UIActionSheet alloc]init];
            _actionSheetAlert.delegate = self;
            _actionSheetAlert.title = @"Save succeed";
            [_actionSheetAlert addButtonWithTitle:@"OK"];
            // アクションシートを表示
            [_actionSheetAlert showInView:self.view];
            
        }

    }
}



- (IBAction)tapDoneBarBtn:(UIBarButtonItem *)sender {

        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:@"Save this image?"
                                            message:@"Message"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Save to Cameraroll"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               // Show editro タップ時の処理
                                                               [self action1];
                                                               
                                                           }]];
        [actionController addAction:[UIAlertAction actionWithTitle:@"Save to this App only"
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
        actionSheet.title = @"Save this Image?";
        [actionSheet addButtonWithTitle:@"Save to Cameraroll"];
        [actionSheet addButtonWithTitle:@"Save to this App only"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        //        actionSheet.destructiveButtonIndex = 0;
        actionSheet.cancelButtonIndex = 2;
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

// action1ボタンが押された時の処理
- (void)action1
{
    // Save to Cameraroll タップ時の処理
    // スナップショットを保存するのでナビゲーションバーとツールバーを非表示にする
    [_navigationBar setHidden:1];
    [_toolBar setHidden:1];
    //現在のeditImageViewの画像を取得する
    //描画領域の設定
    CGSize cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(cropSize);
    //グラフィックコンテキストの取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // viewから切り取る
    [(CALayer*)self.view.layer renderInContext:context];
    
    // 現在ビューに表示されている内容をUIImageとして保存
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 上記imageをNSUserDefaultsに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *editedImage = UIImagePNGRepresentation(image);
    [defaults setObject:editedImage forKey:@"KEY_selectedImage"];
    [defaults synchronize];
    // 上記imageをカメラロールにも保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    
    UIGraphicsEndImageContext();
    
    // カメラロール保存成功失敗アラートのUIAlertControllerのOKボタンで最初の画面に戻る
}

// action2ボタンが押された時の処理
- (void)action2
{
    // Save to this App only タップ時の処理
    // スナップショットを保存するのでナビゲーションバーとツールバーを非表示にする
    [_navigationBar setHidden:1];
    [_toolBar setHidden:1];
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
    
    // 現在のビューに表示されている画像をNSUserDefaultsに保存
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *editedImage = UIImagePNGRepresentation(image);
    [defaults setObject:editedImage forKey:@"KEY_selectedImage"];
    [defaults synchronize];
    
    UIGraphicsEndImageContext();
    [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];
}

// action3ボタンが押された時の処理
- (void)action3
{
    
}
// iOS 7でアクションシートのボタンが押された時の処理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _actionSheetAlert) {
        switch (buttonIndex) {
            case 0:
                // firstViewControllerに戻った時にpickerを閉じるためにUnwindSegueで戻る
                [self performSegueWithIdentifier:@"myUnwindSegue" sender:self];
                
                break;
            default:
                break;
        }
    }else{
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

}





@end
