//
//  kBISoundEffectSettingsViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBISoundEffectSettingsViewController.h"

@interface kBISoundEffectSettingsViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceSoundEffectSettings;
@property (nonatomic, strong) NSArray *dataSourceColorSettings;

@end

@implementation kBISoundEffectSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // sectionList
    NSString *soundEffectt = [[NSString alloc] initWithFormat:NSLocalizedString(@"Sound&Effect", nil)];
    NSString *backgroundColorWhilePlaying = [[NSString alloc] initWithFormat:NSLocalizedString(@"BackgroundColorWhilePlaying", nil)];
    self.sectionList = @[soundEffectt, backgroundColorWhilePlaying];
    // section0
    NSString *rollSound = [[NSString alloc] initWithFormat:NSLocalizedString(@"RollSound", nil)];
    NSString *crashSound = [[NSString alloc] initWithFormat:NSLocalizedString(@"CrashSound", nil)];
    NSString *flashEffect = [[NSString alloc] initWithFormat:NSLocalizedString(@"FlashEffect", nil)];
    self.dataSourceSoundEffectSettings = @[rollSound, crashSound, flashEffect];
    // section1
    NSString *backgroundColor = [[NSString alloc] initWithFormat:NSLocalizedString(@"BackgroundColor", nil)];
    self.dataSourceColorSettings = @[backgroundColor];
    
    self.rollSoundOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_RollSoundOn"];
    self.crashSoundOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_CrashSoundOn"];
    self.flashOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"KEY_FlashEffectOn"];
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
            dataCount = [self.dataSourceSoundEffectSettings count];
            break;
        case 1:
            dataCount = [self.dataSourceColorSettings count];
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
            [labelSettings setText:self.dataSourceSoundEffectSettings[indexPath.row]];
            [labelSettings setAdjustsFontSizeToFitWidth:YES];
            [labelSettings setLineBreakMode:NSLineBreakByClipping];
            [labelSettings setMinimumScaleFactor:4];
            
            UISwitch *sw = (UISwitch *)[soundEffectSettingsCell viewWithTag:2];
            switch (indexPath.row) {
                case 0: // @"RollSound"
                    [sw addTarget:self action:@selector(tapRollSoundSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.rollSoundOn) {
                        sw.on =YES;
                    }else{
                        sw.on = NO;
                    }
                    break;
                case 1: //　@"CrashSound"
                    [sw addTarget:self action:@selector(tapCrashSoundSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.crashSoundOn) {
                        [sw setOn:YES];
                    }else{
                        [sw setOn:NO];
                    }
                    break;
                    case 2: // @"FlashEffect"
                    [sw addTarget:self action:@selector(tapFlashEffectSW:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.flashOn) {
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
        case 1:
        {
            UITableViewCell *settingsCell = (UITableViewCell *)cell;
            UILabel *labelTitle = (UILabel *)[settingsCell viewWithTag:1];
            UILabel *labelRightDetal = (UILabel *)[settingsCell viewWithTag:2];
            
            [labelTitle setText:self.dataSourceColorSettings[indexPath.row]];
            [labelTitle setAdjustsFontSizeToFitWidth:YES];
            [labelTitle setLineBreakMode:NSLineBreakByClipping];
            [labelTitle setMinimumScaleFactor:4];
            NSString *selectedBackgroundColor = [[NSString alloc] initWithFormat:NSLocalizedString([[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_PlayVCBGColor"], nil)];

            [labelRightDetal setText:selectedBackgroundColor];

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
        case 1:
            rowHeight = [kBITableViewCellHavePicker rowHeight];
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
        case 0: // Sound&Effect
            switch (indexPath.row) {
                case 0: // rollsound

                    break;
                case 1:// crashsound
                    break;
                case 2:// frasheffect
                    break;
                default:
                    break;
            }
            break;
        case 1: //Background Color
            if (indexPath.row == 0) {
                kBISettingColorViewController *settingColorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingColorVC"];
                [self.navigationController pushViewController:settingColorVC animated:YES];
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - actions

-(void)tapRollSoundSW:(UISwitch *)sender{
    UISwitch *sw = sender;
    BOOL rollSoundEnable;
    if(sw.on){
        rollSoundEnable = YES;
        [[NSUserDefaults standardUserDefaults] setBool:rollSoundEnable forKey:@"KEY_RollSoundOn"];
    }else{
        rollSoundEnable = NO;
        [[NSUserDefaults standardUserDefaults] setBool:rollSoundEnable forKey:@"KEY_RollSoundOn"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tapCrashSoundSW:(UISwitch *)sender{
    BOOL crashSoundEnable;
    if(sender.on){
        crashSoundEnable = YES;
        [[NSUserDefaults standardUserDefaults] setBool:crashSoundEnable forKey:@"KEY_CrashSoundOn"];
    }else{
        crashSoundEnable = NO;
        [[NSUserDefaults standardUserDefaults] setBool:crashSoundEnable forKey:@"KEY_CrashSoundOn"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)tapFlashEffectSW:(UISwitch *)sender{
    BOOL flashEffectEnable;
    if(sender.on){
        flashEffectEnable = YES;
        [[NSUserDefaults standardUserDefaults] setBool:flashEffectEnable forKey:@"KEY_FlashEffectOn"];
    }else{
        flashEffectEnable = NO;
        [[NSUserDefaults standardUserDefaults] setBool:flashEffectEnable forKey:@"KEY_FlashEffectOn"];
    }
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
