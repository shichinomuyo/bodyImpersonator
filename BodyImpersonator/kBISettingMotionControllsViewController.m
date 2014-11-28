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
@property (nonatomic, strong) NSArray *dataSourceBibrationSettings;

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
    
    self.sectionList = @[@"MotionControlls",@"BibrationSettings"];
    // section1
    self.dataSourceMotionControlls = @[@"StartPlaying",@"FinishPlaying"];
    
    self.startPlayingByShakeOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_StartPlayingByShakeOn"];
    self.finishPlayingByShakeOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_FinishPlayingByShakeOn"];
    
    // section2
    self.dataSourceBibrationSettings = @[@"StartPlayingWithBibeOn",@"FinishPlayingWithBibeOn"];
    
    self.startPlayingWithBibeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_StartPlayingWithBibeOn"];
    self.finishPlayingWithBibeOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_FinishPlayingWithBibeOn"];
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

// セクション毎のセクション名を設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title =[self.sectionList objectAtIndex:section];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ // iPadはBibe機能が無いのでセクションを作らない
        NSLog(@"iPadの処理");
        if (section == 1) { // Biberation
            title = nil;
        }
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSInteger dataCount;
    switch (section) {
        case 0:
            dataCount = [self.dataSourceMotionControlls count];
            break;
        case 1:
            // デバイスがiphoneであるかそうでないかで分岐
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                NSLog(@"iPhoneの処理");
                     dataCount = [self.dataSourceBibrationSettings count];
            }
            else{ // iPadはBibe機能が無いのでセルを作らない
                NSLog(@"iPadの処理");
                dataCount = 0;
            }

       
            break;
        default:
            break;
    }
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *identifiers = @[@"CellHaveSwitch", @"CellHaveSwitch"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: // motionControlls
        {
            kBITableViewCellHaveSwitch *motionControlls = (kBITableViewCellHaveSwitch *)cell;
            motionControlls.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *labelSettings = (UILabel *)[motionControlls viewWithTag:1];
            [labelSettings setText:self.dataSourceMotionControlls[indexPath.row]];
            [labelSettings setAdjustsFontSizeToFitWidth:YES];
            [labelSettings setLineBreakMode:NSLineBreakByClipping];
            [labelSettings setMinimumScaleFactor:4];
            
            UISwitch *sw = (UISwitch *)[motionControlls viewWithTag:2];
            switch (indexPath.row) {
                case 0: // @"StartPlaying"
                    [sw addTarget:self action:@selector(tapStartPlayingByMotionSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.startPlayingByShakeOn) {
                        sw.on =YES;
                    }else{
                        sw.on = NO;
                    }
                    break;
                case 1: //　@"FinishPlaying"
                    [sw addTarget:self action:@selector(tapFinishPlayingByMotionSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.finishPlayingByShakeOn) {
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
        case 1: // bibrationSettings
        {
            kBITableViewCellHaveSwitch *bibrationSettings = (kBITableViewCellHaveSwitch *)cell;
            bibrationSettings.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *labelSettings = (UILabel *)[bibrationSettings viewWithTag:1];
            [labelSettings setText:self.dataSourceBibrationSettings[indexPath.row]];
            [labelSettings setAdjustsFontSizeToFitWidth:YES];
            [labelSettings setLineBreakMode:NSLineBreakByClipping];
            [labelSettings setMinimumScaleFactor:4];
            
            UISwitch *sw = (UISwitch *)[bibrationSettings viewWithTag:2];
            switch (indexPath.row) {
                case 0: // @"StartPlaying"
                    [sw addTarget:self action:@selector(tapStartPlayingWithBibeSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.startPlayingWithBibeOn) {
                        sw.on =YES;
                    }else{
                        sw.on = NO;
                    }
                    break;
                case 1: //　@"FinishPlaying"
                    [sw addTarget:self action:@selector(tapFinishPlayingWithBibeSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.finishPlayingWithBibeOn) {
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

// セクションごとのセルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    switch (indexPath.section) {
        case 0:
            rowHeight = [kBITableViewCellHaveSwitch rowHeight];
            break;
        case 1:
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
        _startPlayingByShakeOn = YES;
    }else{
        _startPlayingByShakeOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_startPlayingByShakeOn forKey:@"KEY_StartPlayingByShakeOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tapFinishPlayingByMotionSW:(UISwitch *)sender{
    if(sender.on){
        _finishPlayingByShakeOn = YES;
    }else{
        _finishPlayingByShakeOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_finishPlayingByShakeOn forKey:@"KEY_FinishPlayingByShakeOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)tapStartPlayingWithBibeSW:(UISwitch *)sender{
    UISwitch *sw = sender;
    if(sw.on){
        _startPlayingWithBibeOn = YES;
    }else{
        _startPlayingWithBibeOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_startPlayingWithBibeOn forKey:@"KEY_StartPlayingWithBibeOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tapFinishPlayingWithBibeSW:(UISwitch *)sender{
    if(sender.on){
        _finishPlayingWithBibeOn = YES;
    }else{
        _finishPlayingWithBibeOn = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:_finishPlayingWithBibeOn forKey:@"KEY_FinishPlayingWithBibeOn"];
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