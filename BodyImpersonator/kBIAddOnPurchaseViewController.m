//
//  kBIAddOnPurchaseViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBIAddOnPurchaseViewController.h"

@interface kBIAddOnPurchaseViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceAddOnPurchase;


@end

@implementation kBIAddOnPurchaseViewController{
    
    kBIIndicator *_kIndicator;
    SKProduct *_myProduct;
    NSString *_localedPrice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //    [self.tableView registerClass:[BIOtherAppsTableViewCell class] forCellReuseIdentifier:@"CellOtherApps"];
    _myProduct = nil;
    _localedPrice = @"¥";
    // デリゲートメソッドをこのクラスで実装
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // section名のListを作成
    self.sectionList = @[@"AddOn"];
    // table表示したいデータソースを設定
    self.dataSourceAddOnPurchase = @[@"RemoveAD/RegistrableCap"];

   
    
    _kIndicator = [kBIIndicator alloc];
    
    [self startProductRequest];
    
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

-(void)viewDidAppear:(BOOL)animated{

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
            dataCount = [self.dataSourceAddOnPurchase count];
            break;
        default:
            break;
    }
    return dataCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellHaveBtn"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: // addOn購入とリストア
        {
            UITableViewCell *addOnCell = (UITableViewCell *)cell;
            UILabel *addOnTitle = (UILabel *)[addOnCell viewWithTag:1];
            UIButton *purchaseBtn = (UIButton *)[addOnCell viewWithTag:2];

            [addOnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [addOnTitle setText:self.dataSourceAddOnPurchase[indexPath.row]];
            [addOnTitle setAdjustsFontSizeToFitWidth:YES];
            [addOnTitle setLineBreakMode:NSLineBreakByClipping];
            [addOnTitle setMinimumScaleFactor:4];
            
            [purchaseBtn setTitle:_localedPrice forState:UIControlStateNormal];
            NSLog(@"localedPrice%@",_localedPrice);
            [purchaseBtn.layer setBorderColor:[[UIColor blueColor] CGColor]];
            [purchaseBtn.layer setBorderWidth:1.0f];
            
            
            switch (indexPath.row) {
                case 0: // @"PurchaseBtn"
                    [purchaseBtn addTarget:self action:@selector(purchaseBtn:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                default:
                    break;
            }
        }
            break;
              default:
            break;
    }
    
    
    return cell;
}

-(void)purchaseBtn:(UIButton *)sender{

        if (!_purchased) { // 購入してないときだけpaymentqueue生成
                            NSLog(@"tapされてるか");
            if ([self checkInAppPurchaseEnable] == YES){ // アプリ内課金制限がない場合はYES、制限有りはNO
                NSLog(@"tapできてる");
//                [self startProductRequest]; //プロダクトの取得
    
                SKPayment *payment = [SKPayment paymentWithProduct:_myProduct]; // 購入処理開始
                [[SKPaymentQueue defaultQueue] addPayment:payment];
                   [_kIndicator indicatorStart];
                
            } else {
                // NOの場合のアラート表示
                [self actionShowAppPurchaseLimitAlert];
            }
        }
}
// addonSectionのセルをタップ不可にする
-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) { // セクション0:AddOnCellのセクション
        case 0:

                return nil;

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
            rowHeight = 44;
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
            if (indexPath.row == 0) {
                

                
            }
        break;
        default:
        break;
    }
    
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
// プロダクト情報取得完了
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
    [_kIndicator indicatorStop];
    // アクションコントローラーのLocalizedStringを定義
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"Error", nil)];
    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"ItemIDIsInvalid.", nil)];
    NSString *action1 = [[NSString alloc] initWithFormat:NSLocalizedString(@"OK", nil)];
    
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        [_kIndicator indicatorStop];
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
    
    // プロダクトの購入
    for (SKProduct *product in response.products) {
        _myProduct = product;

    }

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:_myProduct.priceLocale];
    _localedPrice = [numberFormatter stringFromNumber:_myProduct.price];

    [_tableView reloadData]; // これしないと価格表示されない
    
}


#pragma - mark segue
// previewVCとplayVCから戻ってきたときの処理
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
      [self performSegueWithIdentifier:@"BackFromPurcasedVC" sender:self];
    
}
-(void)restoreAppComplete:(NSNotification *)notification{// 復元機能が終わったところで通知
    
    // Indicatorを非表示にする
    [_kIndicator indicatorStop];
    
    
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"RestoreCompleted.", nil)];
    //    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"Tap+IconToAddImageFromAlbumOrCam", nil)];
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
    NSString *title = [[NSString alloc] initWithFormat:NSLocalizedString(@"RestoreCompleted.", nil)];
    //    NSString *message = [[NSString alloc] initWithFormat:NSLocalizedString(@"Tap+IconToAddImageFromAlbumOrCam", nil)];
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
