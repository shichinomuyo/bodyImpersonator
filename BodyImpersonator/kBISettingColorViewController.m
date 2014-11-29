//
//  kBISettingColorViewController.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBISettingColorViewController.h"

@interface kBISettingColorViewController ()
- (IBAction)btnCancel:(UIBarButtonItem *)sender;
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceBackgroundColors;
@end

@implementation kBISettingColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Do any additional setup after loading the view.
    // sectionList
    self.sectionList = @[@"BackgroundColor"];
    // section0
    NSString *black = [[NSString alloc] initWithFormat:NSLocalizedString(@"Black", nil)];
    NSString *white = [[NSString alloc] initWithFormat:NSLocalizedString(@"White", nil)];
    self.dataSourceBackgroundColors = @[black, white];
}

-(void)viewWillAppear:(BOOL)animated{
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
          NSLog(@"SCCV");
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    NSInteger dataCount;
    switch (section) {
        case 0:
            dataCount = [self.dataSourceBackgroundColors count];
            break;
        default:
            break;
    }

    return dataCount;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
    NSArray *identifiers = @[@"Cell"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    switch (indexPath.section) {
        case 0:
        {
            NSString *selectedColorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_PlayVCBGColor"];
            UITableViewCell *colorNameCell = (UITableViewCell *)cell;
            UILabel *labelColorName = (UILabel *)[colorNameCell viewWithTag:1];
            
            [labelColorName setText:self.dataSourceBackgroundColors[indexPath.row]];
            [labelColorName setAdjustsFontSizeToFitWidth:YES];
            [labelColorName setLineBreakMode:NSLineBreakByClipping];
            [labelColorName setMinimumScaleFactor:4];
            
            if ([labelColorName.text isEqualToString:selectedColorName]) {
                colorNameCell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else{
                colorNameCell.accessoryType = UITableViewCellAccessoryNone;
            }
          
            
        }
            break;
        case 1:
        {

        }
            break;
        default:
            break;
    }
    
    
    // Configure the cell...
    
    return cell;
}


// セクション毎のセクション名を設定
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.sectionList objectAtIndex:section];
//}

// セクションごとのセルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    switch (indexPath.section) {
        case 0:
            rowHeight = [kBISettingColorViewController rowHeight];
            break;
        case 1:

            break;
            
        default:
            break;
    }
    
    return rowHeight;
}

// tableCell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *color;
    // cellがタップされた際の処理
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) { // Black
                color = @"Black";

            }else if(indexPath.row == 1){ // White
                color = @"White";
            }
            [[NSUserDefaults standardUserDefaults] setObject:color forKey:@"KEY_PlayVCBGColor"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (CGFloat)rowHeight{
    return 44.0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
