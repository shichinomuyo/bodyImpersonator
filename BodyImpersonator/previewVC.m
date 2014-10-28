//
//  previewVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/07.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "previewVC.h"

@interface previewVC (){
}


@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;
- (IBAction)removeImage:(UIBarButtonItem *)sender;

@end

@implementation previewVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
//            self.contentSizeForViewInPopover = CGSizeMake(220, 340);
    }
    else{
        NSLog(@"iPadの処理");
    }
}

- (void)viewWillAppear:(BOOL)animated{

    // デバイスがiphoneであるかそうでないかで分岐
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        // Modalなので縮小しない
        [self viewSizeMake:1.0];
    }
    else{
        NSLog(@"iPadの処理");
        // popoverなので縮小する
        [self viewSizeMake:0.5];
        self.nav.title = @"1/2 Scale";
    }

    
}

- (void)viewSizeMake:(CGFloat)scale{
    // スクリーンサイズを取得
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = CGSizeMake(screenRect.size.width, screenRect.size.height);
    // popoverするサイズを決定
    CGSize popoverSize = CGSizeMake(screenRect.size.width*scale, screenRect.size.height*scale); // size of view in popover
    // popoverするサイズを設定
    self.preferredContentSize = popoverSize;
    self.modalInPopover = YES;
    
    // NSUserDefaultsから画像を取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSDataとして情報を取得
    NSData *imageData = [defaults objectForKey:@"KEY_selectedImage"];
    // NSDataからUIImageを作成
    UIImage *selectedImage = [UIImage imageWithData:imageData];
    
    // imageviewのpreviewImageViewに画像を設定
    [self.previewImageView setImage:[self popoverWithImage:selectedImage screenSize:screenSize popoverScale:scale]];
    
    // previewImageViewの位置とサイズを親ビューに合わせる
    [self.previewImageView setFrame:CGRectMake(0, 0,popoverSize.width, popoverSize.height)];
    
    //    NSLog(@"popoverSize (%.1f,%.1f)", popoverSize.width,popoverSize.height);
    //    NSLog(@"self.view.frame (%.1f,%.1f,%.1f,%.1f)", self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    //    NSLog(@"previewImageView.frame (%.1f,%.1f,%.1f,%.1f)", self.previewImageView.frame.origin.x,self.previewImageView.frame.origin.y,self.previewImageView.frame.size.width,self.previewImageView.frame.size.height);
    
}

// 縦横長い方に合わせて縮小する
-(UIImage *)popoverWithImage:(UIImage *)image screenSize:(CGSize)size popoverScale:(CGFloat)scale{
    // ビューとイメージの比率を計算する
    CGFloat widthRatio  = size.width  / image.size.width;
    CGFloat heightRatio = size.height / image.size.height;
    // (widthRatio < heightRatio)が真なら ratio = widthRatio/ 偽ならratio = heightRatio
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;

    NSLog(@"widthRatio:%.2f",widthRatio);
    NSLog(@"heightRatio:%.2f",heightRatio);
    NSLog(@"ratio:%.2f",ratio);
    CGRect rect;
    if (ratio > 1.0) {
        rect = CGRectMake(0, 0,
                                 image.size.width  / ratio,
                                 image.size.height / ratio);
    } else{
        rect = CGRectMake(0,0,image.size.width * scale, image.size.height * scale);
    }


    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"rect.size (%.2f,%.2f)", rect.size.width,rect.size.height);
    return shrinkedImage;
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

- (IBAction)removeImage:(UIBarButtonItem *)sender {

    [self actionRemoveItem:self.receiveIndexPath];
    // 最初の画面に戻る
    [self performSegueWithIdentifier:@"unwindToFirstView" sender:self];


}

- (void)actionRemoveItem:(NSIndexPath *)indexPath{
    NSLog(@"indexPath_:%d",(int)indexPath);
    // データソースから項目を削除する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"KEY_arrayImageNames"];
    NSMutableArray *mArray = [array mutableCopy];
    NSLog(@"indexPath.row:%d",(int)indexPath.row);
    NSString *imageName = [mArray objectAtIndex:(int)(indexPath.row)];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:filePath error:&error];
    [mArray removeObjectAtIndex:indexPath.row];
    array = [mArray copy];
    [defaults setObject:array forKey:@"KEY_arrayImageNames"];
    [defaults synchronize];
    NSLog(@"RemoveThisPathItem:%@",filePath);
    
    
//    [self.collectionView performBatchUpdates:^{
//        // コレクションビューから項目を削除する
//        [self.collectionView deleteItemsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
//    } completion:nil];
}

- (void)removeAllDocumentsFiles{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSData *arrayData = [defaults objectForKey:@"arrayImages"];
    //    NSMutableArray *tmpArray = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
    //    [tmpArray removeAllObjects];
    //    arrayData = [NSKeyedArchiver archivedDataWithRootObject:tmpArray];
    //    [defaults setObject:arrayData forKey:@"arrayImages"];
    
    // usserdefaultsからarrayImagesとimageCountを削除
    //    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSError *error;
    //    [fileManager removeItemAtPath:path error:&error];
    [defaults removeObjectForKey:@"KEY_arrayImageNames"];
    [defaults removeObjectForKey:@"KEY_imageCount"];
    [defaults removeObjectForKey:@"imageCount"];
    [defaults synchronize];
}
@end
