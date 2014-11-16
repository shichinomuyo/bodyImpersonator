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
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShare;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShareImages;
@property (nonatomic, strong) NSArray *dataSourceOtherApps;

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
    self.dataSourceAddOn = @[@"Remove AD"];
    self.dataSourceAddOnImages = [NSArray arrayWithObjects:@"RemoveAD60@2x.png", nil];
    self.dataSourceFeedbackAndShare = @[@"App Store review", @"Share This App"];
    self.dataSourceFeedbackAndShareImages = [NSArray arrayWithObjects: @"Compose60@2x.png",@"ShareIcon60@2x.png", nil];
    self.dataSourceOtherApps = @[@"RollToCrash"];
    
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
    NSArray *identifiers = @[@"CellFeedbackAndShare", @"CellFeedbackAndShare", @"CellOtherApps"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            
            BIFeedbakAndActionCell *addOnCell = (BIFeedbakAndActionCell *)cell;
            
            UIImageView *imageViewAddOn = (UIImageView *)[addOnCell viewWithTag:1];
            UILabel *labelAddOn = (UILabel *)[addOnCell viewWithTag:2];
            [imageViewAddOn setImage:[UIImage imageNamed:self.dataSourceAddOnImages[indexPath.row]]];
            [labelAddOn setText:self.dataSourceAddOn[indexPath.row]];
           

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

            BIOtherAppsTableViewCell *otherAppsCell = (BIOtherAppsTableViewCell *)cell;

            UIImageView *imageViewAppIcon = (UIImageView *)[otherAppsCell viewWithTag:1];
            UILabel *labelAppName = (UILabel *)[otherAppsCell viewWithTag:2];
            UILabel *labelFee = (UILabel *)[otherAppsCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[otherAppsCell viewWithTag:4];
            
            [imageViewAppIcon setImage:[UIImage imageNamed:@"ICONRollToCrashForLink60@2x.png"]];
            [labelAppName setText:self.dataSourceOtherApps[indexPath.row]];
            [labelFee setText:@"Free:"];

            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByClipping];
            [labelDescription setMinimumScaleFactor:4];
            [labelDescription setText:@"ドラムロール→クラッシュシンバルの音を鳴らせるアプリです。"];

            NSLog(@"nannde");
        }

            break;
        default:
            break;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionList objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    switch (indexPath.section) {
        case 0:
            rowHeight = [BIOtherAppsTableViewCell rowHeight];
            break;
        case 1:
            rowHeight = [BIFeedbakAndActionCell rowHeight];
            break;
        case 2:
            rowHeight = [BIOtherAppsTableViewCell rowHeight];
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
        case 0:
            
            break;
        case 1:
            if (indexPath.row == 0) { // App Store Review
                [self actionPostAppStoreReview];
            }else if (indexPath.row == 1) { // PostActivities
                [self actionPostActivity];
            }
            break;
        case 2:
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
    NSString *urlString = @"http://itunes.apple.com/app/id912275000"; // KARADAMONOMANIZERのidを追加する
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
    NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=912275000";
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionJumpToRollToCrash{
    NSString *urlString = @"itms-apps://itunes.apple.com/app/id912275000";
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)actionRemoveAD{

}
@end
