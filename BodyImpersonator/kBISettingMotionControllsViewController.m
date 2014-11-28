//
//  kBISettingMotionControllsViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/28.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBISettingMotionControllsViewController.h"

@interface kBISettingMotionControllsViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceMotionControlls;

@end

@implementation kBISettingMotionControllsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.sectionList = @[@"MotionControlls"];
    
    self.dataSourceMotionControlls = @[@"StartPlaying",@"FinishPlaying"];
    
    self.startPlayingByMotionOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_StartPlayingByMotionOn"];
    self.finishPlayingByMotionOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_FinishPlayingByMotionOn"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            dataCount = [self.dataSourceMotionControlls count];
            break;

        default:
            break;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellHaveSwitch", @"CellHaveRightDetail"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            kBITableViewCellHaveSwitch *soundEffectSettingsCell = (kBITableViewCellHaveSwitch *)cell;
            soundEffectSettingsCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *labelSettings = (UILabel *)[soundEffectSettingsCell viewWithTag:1];
            [labelSettings setText:self.dataSourceMotionControlls[indexPath.row]];
            [labelSettings setAdjustsFontSizeToFitWidth:YES];
            [labelSettings setLineBreakMode:NSLineBreakByClipping];
            [labelSettings setMinimumScaleFactor:4];
            
            UISwitch *sw = (UISwitch *)[soundEffectSettingsCell viewWithTag:2];
            switch (indexPath.row) {
                case 0: // @"StartPlaying"
                    [sw addTarget:self action:@selector(tapStartPlayingByMotionSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.startPlayingByMotionOn) {
                        sw.on =YES;
                    }else{
                        sw.on = NO;
                    }
                    break;
                case 1: //　@"FinishPlaying"
                    [sw addTarget:self action:@selector(tapFinishPlayingByMotionSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.finishPlayingByMotionOn) {
                        [sw setOn:YES];
                    }else{
                        [sw setOn:NO];
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    
    // Configure the cell...
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
            rowHeight = [kBITableViewCellHaveSwitch rowHeight];
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
        case 0: // MotionControlls
            switch (indexPath.row) {
                case 0: // StartPlaying
                    
                    break;
                case 1:// FinishPlaying
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - actions

-(void)tapStartPlayingByMotionSW:(UISwitch *)sender{
    UISwitch *sw = sender;
    if(sw.on){
        _startPlayingByMotionOn = YES;
    }else{
        _startPlayingByMotionOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_startPlayingByMotionOn forKey:@"KEY_StartPlayingByMotionOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tapFinishPlayingByMotionSW:(UISwitch *)sender{
    if(sender.on){
        _finishPlayingByMotionOn = YES;
    }else{
        _finishPlayingByMotionOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_finishPlayingByMotionOn forKey:@"KEY_FinishPlayingByMotionOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma - mark segue
// previewVCとplayVCから戻ってきたときの処理
- (IBAction)returnActionToSoundEffectSettingsForSegue:(UIStoryboardSegue *)segue{
    
    
    
}
@end
