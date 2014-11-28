//
//  AppDelegate.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/08/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // updateTransactionを受け取るための登録
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // updateTransactionを受け取るための登録
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // updateTransactionsの解除
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark- updatedTransactions
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
            {
                // NSLog(@"購入処理中");
                // TODO: インジケータなど回して頑張ってる感を出す。

            }
                break;
            case SKPaymentTransactionStatePurchased:
            {
                // NSLog(@"購入成功");
                // 購入完了したことを通知する
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:transaction];
                // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_Purchased"];

                // TODO: 購入の持続的な記録
            }
                
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
            {
                // NSLog(@"購入失敗: %@, %@", transaction.transactionIdentifier, transaction.error);
                // ユーザが購入処理をキャンセルした場合もここにくる
                // TODO: 失敗のアラート表示等
                [queue finishTransaction:transaction];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"Failed" object:transactions];

                // アクションコントローラーのLocalizedStringを定義
//                NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
//                NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];
//                Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
//                if (class) {// iOS8の処理
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
//                                                                                             message:[transaction.error localizedDescription]
//                                                                                      preferredStyle:UIAlertControllerStyleAlert];
//                    [alertController addAction:[UIAlertAction actionWithTitle:action1
//                                                                        style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction *action) {
//                                                                          
//                                                                      }]];
//                    
//                    
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    
//                    
//                }else{ // iOS7の処理
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
//                                                                    message:[transaction.error localizedDescription]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                }
            }
                break;
            case SKPaymentTransactionStateRestored:
            {
                // リストア処理
                // 機能復元完了を通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreAppComplete" object:transaction];
                // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_Purchased"];
                NSLog(@"以前に購入した機能を復元");
                [queue finishTransaction:transaction];

            }

                break;
            default:
                [queue finishTransaction:transaction];
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseCompleted" object:transactions];
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // 全てのリストア処理が完了
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreCompleted" object:queue];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreFailed" object:error];
}
//
//- (void)upgradeRemoveAllAD{
////    self.AdsRemoved = YES;
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_AdsRemoved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)upgradeRemoveLimitNumberOfImages{
////    self.LimitNumberOfImagesRemoved = YES;
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KEY_LimitNumberOfImagesRemoved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

@end
