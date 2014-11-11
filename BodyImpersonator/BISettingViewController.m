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
    self.sectionList = @[@"Add On", @"Other Apps"];
    // table表示したいデータソースを設定
    self.dataSourceAddOn = @[@"Remove AD"];
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSInteger dataCount;
    switch (section) {
        case 0:
            dataCount = [self.dataSourceAddOn count];
            break;
        case 1:
            dataCount = [self.dataSourceOtherApps count];
            break;
        default:
            break;
    }
    return dataCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"Cell",@"CellOtherApps"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //    [self.tableView registerClass:[BIOtherAppsTableViewCell class] をしてるので以下は不要
//    if (cell == nil) {
//        switch (indexPath.row) {
//            case 0:
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                break;
//            case 1:
//                cell = [[BIOtherAppsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                NSLog(@"dekimasen1");
//                break;
////            case 2:
////                cell = [[CustomCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////                break;
////            case 3:
////                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////                break;
//            default:
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                break;
//        }
//    }

    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.dataSourceAddOn[indexPath.row];
            NSLog(@"kanryo");
            break;
        case 1:
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
            rowHeight = 44.0;
            break;
        case 1:
            rowHeight = [BIOtherAppsTableViewCell rowHeight];
            break;
        default:
            break;
    }

    return rowHeight;
}
@end
