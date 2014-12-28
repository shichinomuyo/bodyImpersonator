//
//  kBISelectMusicViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBISelectMusicViewController.h"

@interface kBISelectMusicViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceMusicType;
@property (nonatomic, strong) NSArray *dataSourceImageOfMusicType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnCancel:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;

@end

@implementation kBISelectMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigationBarのタイトル
    NSString *navTitle= [[NSString alloc] initWithFormat:NSLocalizedString(@"Select Music", nil)];
    [self.navigationTitle setTitle:navTitle];
    // GoogleAnalytics導入のため以下設定
    self.screenName = @"BI_SelectMusicVC";
    
    //デフォルトのナビゲーションコントロールを非表示にする
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // デリゲートメソッドをこのクラスで実装
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // section名のListを作成
    NSString *selectMusic = [[NSString alloc] initWithFormat:NSLocalizedString(@"Select Music", nil)];
    self.sectionList = @[selectMusic];
    NSString *fromLib = [[NSString alloc] initWithFormat:NSLocalizedString(@"SelectFromMusicLibrary", nil)];
    NSString *presetMusic = [[NSString alloc] initWithFormat:NSLocalizedString(@"SelectPresetMusic", nil)];
    NSString *presetDrumRoll= [[NSString alloc] initWithFormat:NSLocalizedString(@"SelectPresetDrumroll", nil)];
    self.dataSourceMusicType = @[fromLib, presetMusic, presetDrumRoll];
    
    self.dataSourceImageOfMusicType = [NSArray arrayWithObjects: @"ICON_Album26x26",@"ICON_MUSIC_44x44",@"ICON_Drum", nil];
    
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
            dataCount = [self.dataSourceMusicType count];
            break;
        default:
            break;
    }
    return dataCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellFeedbackAndShare"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: // タップするとsettingViewを表示するセル
        {
            
            BIFeedbakAndActionCell *feedbackAndShareCell = (BIFeedbakAndActionCell *)cell;
            
            UIImageView *imageViewFeedbackAction = (UIImageView *)[feedbackAndShareCell viewWithTag:1];
            UILabel *labelFeedbackAction = (UILabel *)[feedbackAndShareCell viewWithTag:2];
            [imageViewFeedbackAction setImage:[UIImage imageNamed:self.dataSourceImageOfMusicType[indexPath.row]]];
            [labelFeedbackAction setText:self.dataSourceMusicType[indexPath.row]];
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
            rowHeight = [BIFeedbakAndActionCell rowHeight];
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
            if (indexPath.row == 0) { // Select from music library
                kBIMediaPickerController *mediaPicker = [[kBIMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];// 音楽だけ表示
                //            mediaPicker.delegate = self; // デリゲートになる
                mediaPicker.tappedIndexPath = self.tappedIndexPath; // ハンドラーに情報を保存するため、どのセルが選択されてきたかを渡す
                [self presentViewController:mediaPicker animated:YES completion:nil];

            }else if (indexPath.row == 1) { // Select Preset Music
                [self selectRockSound];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if (indexPath.row == 2){ // Select Preset Drumroll
                [self selectRollSound];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        default:
            break;
    }
    
}

-(void)selectRockSound{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSMutableArray *hundlers = [array mutableCopy];
    kBIMusicHundlerByImageName *hundler = [kBIMusicHundlerByImageName alloc];
    hundler.rollSoundOn = NO;
    hundler.originalMusicOn = YES;
    hundler.iPodLibMusicOn = NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hundler];
    [hundlers replaceObjectAtIndex:self.tappedIndexPath.row withObject:data];
    array = [hundlers copy];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"KEY_MusicHundlersByImageName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRollSound{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSMutableArray *hundlers = [array mutableCopy];
    kBIMusicHundlerByImageName *hundler = [kBIMusicHundlerByImageName alloc];
    hundler.rollSoundOn = YES;
    hundler.originalMusicOn = NO;
    hundler.iPodLibMusicOn = NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hundler];
    [hundlers replaceObjectAtIndex:self.tappedIndexPath.row withObject:data];
    array = [hundlers copy];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"KEY_MusicHundlersByImageName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
