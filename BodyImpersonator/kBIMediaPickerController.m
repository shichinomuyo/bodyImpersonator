//
//  kBIMediaPickerVC.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/24.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBIMediaPickerController.h"

@interface kBIMediaPickerController ()

@end

@implementation kBIMediaPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self; // デリゲートになる
    [self setAllowsPickingMultipleItems:NO];
    [self setShowsCloudItems:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *artist = [item valueForProperty:MPMediaItemPropertyAlbumArtist];
    NSString *trackTitle = [item valueForProperty:MPMediaItemPropertyTitle];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_MusicHundlersByImageName"];
    NSMutableArray *hundlers = [array mutableCopy];
    kBIMusicHundlerByImageName *hundler = [kBIMusicHundlerByImageName alloc];
    hundler.rollSoundOn = NO;
    hundler.snareSoundOn = NO;
    hundler.timpaniSoundOn = NO;
    hundler.originalMusicOn = NO;
    hundler.iPodLibMusicOn = YES;
    hundler.mediaItemURL = url;
    hundler.mediaItemCollection = mediaItemCollection;
    hundler.artist = artist;
    hundler.trackTitle = trackTitle;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hundler];
    [hundlers replaceObjectAtIndex:self.tappedIndexPath.row withObject:data];
    array = [hundlers mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"KEY_MusicHundlersByImageName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"hundler.mediaItemURL:%@",hundler.mediaItemURL);
 
       [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
