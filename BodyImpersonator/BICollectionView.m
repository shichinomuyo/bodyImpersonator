//
//  BICollectionView.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/10/29.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "BICollectionView.h"

@implementation BICollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (NSInteger)numberOfSectionsInCollectionView:(BICollectionView *) collectionView{
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger)section{
//    // arrayにデータが入ってる配列数を返す
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *array = [defaults objectForKey:@"KEY_arrayImageNames"];
//    int count = (int)[array count];
//    
//    // userdefaultsの中身確認(デバッグ用)
//    //    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    //    NSDictionary *dic = [defaults persistentDomainForName:appDomain];
//    //    NSLog(@"defualts:%@", dic);
//    if (count < 9) {
//        return count+1;
//    } else {
//        return count;
//    }
//    NSLog(@"numberOfItemsInSection%d",count);
//}
//
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"-----------------------------------------");
//    
//    NSString *selectedImageName = @"/image146.png";
//    
//    // セルを作成する
//    BICollectionViewCell *cell;
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    //    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1]; // cell.imageViewで置き換え済み
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *array = [defaults objectForKey:@"KEY_arrayImageNames"];
//    NSLog(@"indexPath.row:%d",(int)indexPath.row);
//    
//    if ([array safeObjectAtIndex:(int)(indexPath.row)] == nil) {
//        NSLog(@"nilだ");
//        UIImage *image = [UIImage imageNamed:@"AddImage188x188.png"];
//        [cell.imageView setImage:image];
//        // frameをつける
//        CGSize frameSize = CGSizeMake(112, 120);
//        CGFloat adjustX = (frameSize.width - cell.frame.size.width)/2;
//        CGFloat adjustY = (frameSize.height - cell.frame.size.height)/2;
//        cell.backgroundColor = [UIColor whiteColor];
//        // cell.imageViewFrame = [[UIImageView alloc]initWithFrame:CGRectMake(-adjustX, -adjustY, frameSize.width, frameSize.height)];
//        UIImage *imageFrame = [UIImage imageNamed:@"CollectionViewCellFrame188x188.png"];
//        [cell.imageViewFrame setImage:imageFrame];
//        NSLog(@"黒いFrameつけるお");
//        
//    } else{
//        
//        // NSDataからUIImageを作成
//        NSLog(@"nilじゃない");
//        NSString *imageName = [array objectAtIndex:(int)(indexPath.row)];
//        NSString *filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingString:@"/Documents"],imageName];
//        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//        NSLog(@"filePath:%@",filePath);
//        if ([imageName isEqualToString:selectedImageName]) {
//            
//            cell.backgroundColor = [UIColor blackColor];
//            
//            
//            // frameをつける
//            CGSize frameSize = CGSizeMake(112, 120);
//            CGFloat adjustX = (frameSize.width - cell.frame.size.width)/2;
//            CGFloat adjustY = (frameSize.height - cell.frame.size.height)/2;
//            cell.imageViewFrame = [[UIImageView alloc]initWithFrame:CGRectMake(-adjustX	, -adjustY, frameSize.width, frameSize.height)];
//            UIImage *imageFrame = [UIImage imageNamed:@"YelloFrameTransparentBack188x188.png"];
//            [cell.imageViewFrame setImage:imageFrame];
//            //   [collectionView addSubview:cell.imageViewFrame];
//            NSLog(@"選択中Frameつけるお");
//            NSLog(@"imageviewSizeSelected:(%.2f,%.2f)",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
//            NSLog(@"imageviewFrameRect:(%.2f,%.2f,%.2f,%.2f)",cell.imageViewFrame.frame.origin.x, cell.imageViewFrame.frame.origin.y, cell.imageViewFrame.frame.size.width,cell.imageViewFrame.frame.size.height);
//        }
//        
//        [cell.imageView setImage:image];
//        // gesturerecognizerを作成
//        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCell:)];
//        [longPressGesture setDelegate:self];
//        // 長押しが認識される時間を設定
//        longPressGesture.minimumPressDuration = 1.0;
//        // 長押し中に動いても許容されるピクセル数を設定
//        longPressGesture.allowableMovement = 10.0;
//        cell.userInteractionEnabled = YES;
//        [cell addGestureRecognizer:longPressGesture];
//        
//        
//        
//    }
//    return cell;
//}
//

@end
