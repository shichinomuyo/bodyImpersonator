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
@property (nonatomic, strong) NSArray *dataSourceSettings;
@property (nonatomic, strong) NSArray *dataSourceAddOn;
@property (nonatomic, strong) NSArray *dataSourceAddOnImages;
@property (nonatomic, strong) NSArray *dataSourceAddOnDesc;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShare;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShareImages;
@property (nonatomic, strong) NSArray *dataSourceOtherApps;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsImages;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsDesc;
@end

@implementation BISettingViewController{
    kBIIndicator *_kIndicator;
    SKProduct *_myProduct;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // GoogleAnalytics導入のため以下設定
    self.screenName = @"BI_SettingVC";

    // デリゲートメソッドをこのクラスで実装
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // section名のListを作成
    NSString *settings = [[NSString alloc] initWithFormat:NSLocalizedString(@"Settings", nil)];
    NSString *addOn = [[NSString alloc] initWithFormat:NSLocalizedString(@"AddOn", nil)];
    NSString *feedbackShareThisApp = [[NSString alloc] initWithFormat:NSLocalizedString(@"Feedback/ShareThisApp", nil)];
    NSString *otherApps = [[NSString alloc] initWithFormat:NSLocalizedString(@"OtherApps", nil)];
    self.sectionList = @[settings, addOn, feedbackShareThisApp, otherApps];
    // sectionごとにデータソースを作成
    NSString *soundEffect = [[NSString alloc] initWithFormat:NSLocalizedString(@"Sound&Effect", nil)];
    NSString *motionControlls = [[NSString alloc] initWithFormat:NSLocalizedString(@"MotionControlls", nil)];
    self.dataSourceSettings = @[soundEffect , motionControlls]; // section0
    
    NSString *removeADandCap = [[NSString alloc] initWithFormat:NSLocalizedString(@"RemoveAD&RegistrableCap", nil)];
    NSString *restore = [[NSString alloc] initWithFormat:NSLocalizedString(@"Restore", nil)];
    NSString *addOnDesc = [[NSString alloc] initWithFormat:NSLocalizedString(@"Remove All AD & Registrable number of Images Increase 9 to 18", nil)];
    NSString *restoreAddOn = [[NSString alloc] initWithFormat:NSLocalizedString(@"RestoreAddOn", nil)];
    self.dataSourceAddOn = @[removeADandCap, restore]; // section1
    self.dataSourceAddOnImages = [NSArray arrayWithObjects:@"TableCellIconRemoveAD",@"TableCellIconRestore", nil]; //section1
    self.dataSourceAddOnDesc = @[addOnDesc,restoreAddOn];//section1
    
    NSString *appStoreReview = [[NSString alloc] initWithFormat:NSLocalizedString(@"App Store review", nil)];
    NSString *shareThisApp = [[NSString alloc] initWithFormat:NSLocalizedString(@"Share This App", nil)];
    self.dataSourceFeedbackAndShare = @[appStoreReview, shareThisApp];//section2
    self.dataSourceFeedbackAndShareImages = [NSArray arrayWithObjects: @"TableCellIconCompose",@"TableCellIconShareThisApp", nil];//section2
    
    NSString *rollToCrashDesc = [[NSString alloc] initWithFormat:NSLocalizedString(@"Play drumroll -> crashCymbal!", nil)]; //ドラムロール→クラッシュシンバルの音を鳴らせるアプリです。
    self.dataSourceOtherApps = @[@"RollToCrash"];
    self.dataSourceOtherAppsImages = [NSArray arrayWithObjects:@"TableCellIconRollToCrash", nil];
    self.dataSourceOtherAppsDesc = @[rollToCrashDesc];
    
    _kIndicator = [kBIIndicator alloc];
    
}

-(void)viewWillAppear:(BOOL)animated{
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    [self.tableView reloadData];
    //購入済みかチェック
    _purchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_Purchased"];
    //    _purchased = YES; // デバッグ用
    NSLog(@"purchased:%d",_purchased);
    // AppDelegateからの購入通知を登録する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(purchased:)
               name:@"Purchased"
             object:nil];
    [nc addObserver:self
           selector:@selector(failed:)
               name:@"Failed"
             object:nil];
    [nc addObserver:self
           selector:@selector(purchaseCompleted:)
               name:@"PurchaseCompleted"
             object:nil];
    [nc addObserver:self
           selector:@selector(restoreCompleted:)
               name:@"RestoreCompleted"
             object:nil];
    [nc addObserver:self
           selector:@selector(restoreFailed:)
               name:@"RestoreFailed"
             object:nil];
    [nc addObserver:self
           selector:@selector(restoreAppComplete:)
               name:@"RestoreAppComplete"
             object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self
                  name:@"Purchased"
                object:nil];
    [nc removeObserver:self
                  name:@"Failed"
                object:nil];
    [nc removeObserver:self
                  name:@"PurchaseCompleted"
                object:nil];
    [nc removeObserver:self
                  name:@"RestoreCompleted"
                object:nil];
    [nc removeObserver:self
                  name:@"RestoreFailed"
                object:nil];
    [nc removeObserver:self
                  name:@"RestoreAppComplete"
                object:nil];
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
            dataCount = [self.dataSourceSettings count];
            break;
        case 1:
            dataCount = [self.dataSourceAddOn count];
            break;
        case 2:
            dataCount = [self.dataSourceFeedbackAndShare count];
            break;
        case 3:
            dataCount = [self.dataSourceOtherApps count];
            break;
        default:
            break;
    }
    return dataCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellHaveOneLabel", @"CellHaveFourItems", @"CellFeedbackAndShare", @"CellHaveFourItems"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: // タップするとsettingViewを表示するセル
        {
            UITableViewCell *settingsCell = (UITableViewCell *)cell;
            UILabel *labelSettings = (UILabel *)[settingsCell viewWithTag:1];

            [labelSettings setText:self.dataSourceSettings[indexPath.row]];
            [labelSettings setAdjustsFontSizeToFitWidth:YES];
            [labelSettings setLineBreakMode:NSLineBreakByClipping];
            [labelSettings setMinimumScaleFactor:4];
        }
            break;
        case 1: // addOn購入とリストア
        {
            
            BITableViewCellHaveFourItems *addOnCell = (BITableViewCellHaveFourItems *)cell;
            
            UIImageView *imageViewAddOn = (UIImageView *)[addOnCell viewWithTag:1];
            UILabel *labelAddOn = (UILabel *)[addOnCell viewWithTag:2];
            UILabel *labelDescTitle = (UILabel *)[addOnCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[addOnCell viewWithTag:4];
            UILabel *labelPurchased = (UILabel *)[addOnCell viewWithTag:5];
            [labelPurchased setHidden:1];
            [imageViewAddOn setImage:[UIImage imageNamed:self.dataSourceAddOnImages[indexPath.row]]];
            
            [labelAddOn setText:self.dataSourceAddOn[indexPath.row]];
            [labelAddOn setAdjustsFontSizeToFitWidth:YES];
            [labelAddOn setLineBreakMode:NSLineBreakByClipping];
            [labelAddOn setMinimumScaleFactor:4];
            
            NSString *desc = [[NSString alloc] initWithFormat:NSLocalizedString(@"Desc:", nil)];
            [labelDescTitle setText:desc];//説明
            
            [labelDescription setText:self.dataSourceAddOnDesc[indexPath.row]];
            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByClipping];
            [labelDescription setMinimumScaleFactor:4];
            
            if (indexPath.row == 0) {// 購入セルををタップできるようにする。/できないようにする。
                if (_purchased) {
                    [addOnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [addOnCell setBackgroundColor:RGB(230, 235, 240)];

                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){ // iPhoneだとセル一杯に文字が詰まるので元の説明文を消す
                        [labelPurchased setCenter:CGPointMake(addOnCell.center.x, addOnCell.center.y)];
                        [labelDescTitle setHidden:1];
                        [labelDescription setHidden:1];
                    }

                    [labelPurchased setHidden:0];
                }
            } else if (indexPath.row == 1){ // リストアセルをタップできるようにする。/できないようにする。
                if (_purchased) {
                    [addOnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [addOnCell setBackgroundColor:RGB(230, 235, 240)];
                } else{

                }
            }

        }
             break;
        case 2: // feedBack&share
        {
            
            BIFeedbakAndActionCell *feedbackAndShareCell = (BIFeedbakAndActionCell *)cell;
            
            UIImageView *imageViewFeedbackAction = (UIImageView *)[feedbackAndShareCell viewWithTag:1];
            UILabel *labelFeedbackAction = (UILabel *)[feedbackAndShareCell viewWithTag:2];
            [imageViewFeedbackAction setImage:[UIImage imageNamed:self.dataSourceFeedbackAndShareImages[indexPath.row]]];
            [labelFeedbackAction setText:self.dataSourceFeedbackAndShare[indexPath.row]];
        }
            break;
        case 3: // otherApps
        {

            BITableViewCellHaveFourItems *otherAppsCell = (BITableViewCellHaveFourItems *)cell;

            UIImageView *imageViewAppIcon = (UIImageView *)[otherAppsCell viewWithTag:1];
            UILabel *labelAppName = (UILabel *)[otherAppsCell viewWithTag:2];
            UILabel *labelFee = (UILabel *)[otherAppsCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[otherAppsCell viewWithTag:4];
            UILabel *labelPurchased = (UILabel *)[otherAppsCell viewWithTag:5];
            [labelPurchased removeFromSuperview];
            
            [imageViewAppIcon setImage:[UIImage imageNamed:self.dataSourceOtherAppsImages[indexPath.row]]];
            [labelAppName setText:self.dataSourceOtherApps[indexPath.row]];
            NSString *free = [[NSString alloc] initWithFormat:NSLocalizedString(@"Free:", nil)];
            [labelFee setText:free];

            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByClipping];
            [labelDescription setMinimumScaleFactor:4];
            [labelDescription setText:self.dataSourceOtherAppsDesc[indexPath.row]];

        }
            break;
        default:
            break;
    }
    return cell;
}

// addonSectionのセルを購入済み時にタップ不可にする
-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) { // セクション1:AddOnCellのセクション
        case 1:
            if (_purchased) { // 購入済みのとき
                   return nil;
            }
        break;
            
        default:
            break;
    }

    return indexPath;
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
            rowHeight = [kBITableViewCellHaveSwitch rowHeight];
            break;
        case 1:
            rowHeight = [BITableViewCellHaveFourItems rowHeight];
            break;
        case 2:
            rowHeight = [BIFeedbakAndActionCell rowHeight];
            break;
        case 3:
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
   [self.tableView reloadData];
    // cellがタップされた際の処理
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) { //SoundEffectSettingsVC
                   kBISoundEffectSettingsViewController *sesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SoundEffectSettingsVC"];
                [self.navigationController pushViewController:sesVC animated:YES];
            } else if (indexPath.row == 1) { // MotionControlls
                kBISettingMotionControllsViewController *smcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MotionControllSettingsVC"];
                [self.navigationController pushViewController:smcVC animated:YES];
            }
            break;
        case 1: //Add On
            if (indexPath.row == 0) { // addOnPurchaseVCへ遷移
                if (!_purchased) {
                    kBIAddOnPurchaseViewController *aopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOnPurchaseVC"];
                    [self.navigationController pushViewController:aopVC animated:YES];
                }

            }else if(indexPath.row == 1){ // リストア処理
                    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
                    // インジケータースタート
                    [_kIndicator indicatorStart];
            }
    
            break;
        case 2: // Feedback / Share this App
            if (indexPath.row == 0) { // App Store Review
                [self actionPostAppStoreReview];
            }else if (indexPath.row == 1) { // PostActivities
                [self actionPostActivity:indexPath];
            }
            break;
        case 3: // Other Apps
            if (indexPath.row == 0) {
                [self actionJumpToRollToCrash];
            }
            break;
        default:
            break;
    }
    
}


- (void)actionPostAppStoreReview{
    NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=942520127"; // karadamonomanizerのレビューページに飛ぶ
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

// actions
- (void)actionPostActivity:(NSIndexPath *)indexPath{
    NSString *localeTextToShare = [[NSString alloc] initWithFormat:NSLocalizedString(@"#INSTANT MASK NOW!", nil)];
    NSString *textToShare = localeTextToShare;
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
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    activityVC.popoverPresentationController.sourceView = cell.contentView;
    activityVC.popoverPresentationController.sourceRect = cell.bounds;

    
    // アクティビティコントローラーを表示する
    [self presentViewController:activityVC animated:YES completion:nil];
    
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


- (void)startRestore{
//    NSSet *set = [NSSet setWithObjects:@"com.muyo.bodyImpersonator.remove_ad_up_registrable_number_of_images", nil];
//    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
//    productsRequest.delegate = self;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}


// アプリ内課金プロダクト情報の取得開始
- (void)startProductRequest
{

    // com.companyname.application.productidは、「1-1. iTunes ConnectでManage In-App Purchasesの追加」で作成したProduct IDを設定します。
    NSSet *set = [NSSet setWithObjects:@"com.muyo.bodyImpersonator.remove_ad_up_registrable_number_of_images", nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
    
    [_kIndicator indicatorStart];
}
// プロダクト情報取得完了 // viewControllerにもコピペ
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"ItemIDIsInvalid.", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];
    [_kIndicator indicatorStop];
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

    // プロダクトの取得
    for (SKProduct *product in response.products) {
        _myProduct = product;
        SKPayment *payment = [SKPayment paymentWithProduct:_myProduct]; // 購入処理開始
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


#pragma - mark segue
// 戻ってきたときの処理
- (IBAction)settingsVCReturnActionForSegue:(UIStoryboardSegue *)segue{
    
}

#pragma - mark AppDelegate reciever action
-(void)purchased:(NSNotification *)notification{
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
}
-(void)failed:(NSNotification *)notification{
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
    
}
-(void)purchaseCompleted:(NSNotification *)notification{
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
}
-(void)restoreAppComplete:(NSNotification *)notification{// 復元機能が終わったところで通知

    // Indicatorを非表示にする
    [_kIndicator indicatorStop];

    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"RestoreCompleted", nil)];

    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               [self viewWillAppear:1];
                                                               
                                                           }]];
        // アクションコントローラーを表示
        [self presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        // アクションシートを表示
        [alert show];
    }
}

-(void)restoreCompleted:(NSNotification *)notification{ //機能復元だけじゃなくてリストア処理がひと通り終わったときの通知を受ける
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
    NSLog(@"restoreCompleted");
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"RestoreCompleted", nil)];
    Class class = NSClassFromString(@"UIAlertController"); // iOS8/7の切り分けフラグに使用
    if (class) {
        // iOS8の処理
        // アクションコントローラー生成
        UIAlertController *actionController =
        [UIAlertController alertControllerWithTitle:title
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [actionController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               [self viewWillAppear:1];
                                                               
                                                           }]];
        // アクションコントローラーを表示
        [self presentViewController:actionController animated:YES completion:nil];
    } else{
        // iOS7の処理
        
        // UIActionSheetを生成
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        // アクションシートを表示
        [alert show];
    }
}

-(void)restoreFailed:(NSNotification *)notification{
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
    NSLog(@"restorefailed");
}
@end
