//
//  BISettingViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "BISettingViewController.h"

@interface BISettingViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceAddOn;
@property (nonatomic, strong) NSArray *dataSourceAddOnImages;
@property (nonatomic, strong) NSArray *dataSourceAddOnDesc;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShare;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShareImages;
@property (nonatomic, strong) NSArray *dataSourceOtherApps;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsImages;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsDesc;

@end

@implementation BISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.tableView registerClass:[BIOtherAppsTableViewCell class] forCellReuseIdentifier:@"CellOtherApps"];
    // デリゲートメソッドをこのクラスで実装
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // section名のListを作成
    self.sectionList = @[@"Add On",@"Feedback / Share This App", @"Other Apps"];
    // table表示したいデータソースを設定
    self.dataSourceAddOn = @[@"Remove AD & Registrable Cap ",@"Restore"];
    self.dataSourceAddOnImages = [NSArray arrayWithObjects:@"RemoveAD60@2x.png",@"RemoveAD60@2x.png", nil];
    self.dataSourceAddOnDesc = @[@"Remove All AD & Registrable number of Images Increase 9 to 18",@"購入状態を復元します。"];
    
    
    self.dataSourceFeedbackAndShare = @[@"App Store review", @"Share This App"];
    self.dataSourceFeedbackAndShareImages = [NSArray arrayWithObjects: @"Compose60@2x.png",@"ShareIcon60@2x.png", nil];
    
    self.dataSourceOtherApps = @[@"RollToCrash"];
    self.dataSourceOtherAppsImages = [NSArray arrayWithObjects:@"ICONRollToCrashForLink60@2x.png", nil];
    self.dataSourceOtherAppsDesc = @[@"ドラムロール→クラッシュシンバルの音を鳴らせるアプリです。"];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    NSInteger sectionCount;
    sectionCount = [self.sectionList count];
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSInteger dataCount;
    switch (section) {
        case 0:
            dataCount = [self.dataSourceAddOn count];
            break;
        case 1:
            dataCount = [self.dataSourceFeedbackAndShare count];
            break;
        case 2:
            dataCount = [self.dataSourceOtherApps count];
            break;
        default:
            break;
    }
    return dataCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellHaveFourItems", @"CellFeedbackAndShare", @"CellHaveFourItems"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            
            BITableViewCellHaveFourItems *addOnCell = (BITableViewCellHaveFourItems *)cell;
            
            UIImageView *imageViewAddOn = (UIImageView *)[addOnCell viewWithTag:1];
            UILabel *labelAddOn = (UILabel *)[addOnCell viewWithTag:2];
            UILabel *labelDescTitle = (UILabel *)[addOnCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[addOnCell viewWithTag:4];
            [imageViewAddOn setImage:[UIImage imageNamed:self.dataSourceAddOnImages[indexPath.row]]];
            
            [labelAddOn setText:self.dataSourceAddOn[indexPath.row]];
            [labelAddOn setAdjustsFontSizeToFitWidth:YES];
            [labelAddOn setLineBreakMode:NSLineBreakByClipping];
            [labelAddOn setMinimumScaleFactor:4];
            
            [labelDescTitle setText:@"Desc:"];//説明
            
            [labelDescription setText:self.dataSourceAddOnDesc[indexPath.row]];
            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByClipping];
            [labelDescription setMinimumScaleFactor:4];

        }
             break;
        case 1:
        {
            
            BIFeedbakAndActionCell *feedbackAndShareCell = (BIFeedbakAndActionCell *)cell;
            
            UIImageView *imageViewFeedbackAction = (UIImageView *)[feedbackAndShareCell viewWithTag:1];
            UILabel *labelFeedbackAction = (UILabel *)[feedbackAndShareCell viewWithTag:2];
            [imageViewFeedbackAction setImage:[UIImage imageNamed:self.dataSourceFeedbackAndShareImages[indexPath.row]]];
            [labelFeedbackAction setText:self.dataSourceFeedbackAndShare[indexPath.row]];
        }
            break;
        case 2:
        {

            BITableViewCellHaveFourItems *otherAppsCell = (BITableViewCellHaveFourItems *)cell;

            UIImageView *imageViewAppIcon = (UIImageView *)[otherAppsCell viewWithTag:1];
            UILabel *labelAppName = (UILabel *)[otherAppsCell viewWithTag:2];
            UILabel *labelFee = (UILabel *)[otherAppsCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[otherAppsCell viewWithTag:4];
            
            [imageViewAppIcon setImage:[UIImage imageNamed:self.dataSourceOtherAppsImages[indexPath.row]]];
            [labelAppName setText:self.dataSourceOtherApps[indexPath.row]];
            [labelFee setText:@"Free:"];

            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByClipping];
            [labelDescription setMinimumScaleFactor:4];
            [labelDescription setText:self.dataSourceOtherAppsDesc[indexPath.row]];

            NSLog(@"nannde");
        }

            break;
        default:
            break;
    }
    
    return cell;
}

// セクション毎のセクション名を設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionList objectAtIndex:section];
}

// セクションごとのセルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    switch (indexPath.section) {
        case 0:
            rowHeight = [BITableViewCellHaveFourItems rowHeight];
            break;
        case 1:
            rowHeight = [BIFeedbakAndActionCell rowHeight];
            break;
        case 2:
            rowHeight = [BITableViewCellHaveFourItems rowHeight];
            break;
        default:
            break;
    }

    return rowHeight;
}

// tableCell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cellがタップされた際の処理
    switch (indexPath.section) {
        case 0: //Add On
            if (indexPath.row == 0) {
                if ([self checkInAppPurchaseEnable] == YES){ // アプリ内課金制限がない場合はYES、制限有りはNO
                    [self startInAppPurchase];
                } else {
                    // NOの場合のアラート表示
                    [self actionShowAppPurchaseLimitAlert];
                }
            }else if(indexPath.row == 1){
                // TODO:リストア処理
                [self startRestore];
            }
    
            break;
        case 1: // Feedback / Share this App
            if (indexPath.row == 0) { // App Store Review
                [self actionPostAppStoreReview];
            }else if (indexPath.row == 1) { // PostActivities
                [self actionPostActivity];
            }
            break;
        case 2: // Other Apps
            if (indexPath.row == 0) {
                [self actionJumpToRollToCrash];
            }
            break;
        default:
            break;
    }
    
}

// actions
- (void)actionPostActivity{
    NSString *textToShare = @"#KARADA MONOMANIZER NOW!";
    NSString *urlString = @"http://itunes.apple.com/app/id942520127"; // KARADAMONOMANIZERのappstoreURL
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:textToShare,url, nil];
    // 連携できるアプリを取得する
    UIActivity *activity = [[UIActivity alloc]init];
    NSArray *activities = @[activity];
    // アクティビティコントローラーを作る
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:activities];
    // Add to Reading Listをactivityから除外
    NSArray *excludedActivityTypes = @[UIActivityTypeAddToReadingList];
    activityVC.excludedActivityTypes = excludedActivityTypes;

    // アクティビティコントローラーを表示する
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (void)actionPostAppStoreReview{
    NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=942520127"; // karadamonomanizerのレビューページに飛ぶ
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionJumpToRollToCrash{
    NSString *urlString = @"itms-apps://itunes.apple.com/app/id912275000"; // rolltocrashのページに飛ぶ
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionRemoveAD{

}

#pragma mark アプリ内課金
// アプリ内課金制限有無を確認
- (BOOL)checkInAppPurchaseEnable
{
    if (![SKPaymentQueue canMakePayments]) {
        return NO; // 制限有りの場合、NO
    }
    return YES; // 制限無しの場合、YES
}

- (void)actionShowAppPurchaseLimitAlert {
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"InAppPurchaceIsLimited.", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {


        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        [actionController addAction:[UIAlertAction actionWithTitle:action1
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {

                                                               
                                                           }]];

        actionController.popoverPresentationController.sourceView = self.view;
            // アクションコントローラーを表示
            [self presentViewController:actionController animated:YES completion:nil];

        
        
    } else{
        // iOS7の処理
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }

}
// アプリ内制限有無チェック処理の結果がYESだったらこの処理を呼ぶ）
- (void)startInAppPurchase
{
    // com.companyname.application.productidは、「1-1. iTunes ConnectでManage In-App Purchasesの追加」で作成したProduct IDを設定します。
    NSSet *set = [NSSet setWithObjects:@"com.muyo.bodyImpersonator.remove_ad_up_registrable_number_of_images", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)startRestore{
    NSSet *set = [NSSet setWithObjects:@"com.muyo.bodyImpersonator.remove_ad_up_registrable_number_of_images", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

// 購入処理の開始
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"ItemIDIsInvalid.", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];

    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
        if (class) { // iOS8の処理
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:action1
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }]];


            [self presentViewController:alertController animated:YES completion:nil];
        
        }else{ // iOS7の処理
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    // 購入処理開始
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

//アイテム購入処理
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                // NSLog(@"購入処理中");
                // TODO: インジケータなど回して頑張ってる感を出す。
                break;
            case SKPaymentTransactionStatePurchased:
                // NSLog(@"購入成功");
                // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                [self upgradeRemoveAllAD];
                [self upgradeRemoveLimitNumberOfImages];
                // TODO: 購入の持続的な記録
                {
                }
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                // NSLog(@"購入失敗: %@, %@", transaction.transactionIdentifier, transaction.error);
                // ユーザが購入処理をキャンセルした場合もここにくる
                // TODO: 失敗のアラート表示等
                {
                    // アクションコントローラーのLocalizedStringを定義
                    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
                    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];
                    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
                    if (class) {// iOS8の処理
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                                 message:[transaction.error localizedDescription]
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:action1
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction *action) {
                                                                              
                                                                          }]];
                        

                        [self presentViewController:alertController animated:YES completion:nil];


                    }else{ // iOS7の処理
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                        message:[transaction.error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                break;
            case SKPaymentTransactionStateRestored:
                // リストア処理
                // TODO: アイテム購入した処理（アップグレード版の機能制限解除処理等）
                [self upgradeRemoveAllAD];
                [self upgradeRemoveLimitNumberOfImages];
                // NSLog(@"以前に購入した機能を復元");
                [queue finishTransaction:transaction];
                break;
            default:
                [queue finishTransaction:transaction];
                break;
        }
    }
}

// レシートの確認とアイテムの付与

//購入処理の終了
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // 全てのリストア処理が完了
    
}

- (void)upgradeRemoveAllAD{
    BOOL adsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:adsRemoved forKey:@"KEY_adsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)upgradeRemoveLimitNumberOfImages{
    BOOL limitNumberOfImagesRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:limitNumberOfImagesRemoved forKey:@"KEY_RemoveLimitNumberOfImagesRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
