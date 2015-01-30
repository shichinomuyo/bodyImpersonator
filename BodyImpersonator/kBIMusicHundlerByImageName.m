//
//  kBIMusicHundlerByImageName.m
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/12/25.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "kBIMusicHundlerByImageName.h"

@implementation kBIMusicHundlerByImageName
// アーカイブするときに呼ばれるメソッド
-(void)encodeWithCoder:(NSCoder *)encoder{
    NSNumber *numRollSoundOn = [[NSNumber alloc] initWithBool:_rollSoundOn];
    NSNumber *numSnareSoundOn = [[NSNumber alloc] initWithBool:_snareSoundOn];
    NSNumber *numTimpaniSoundOn = [[NSNumber alloc] initWithBool:_timpaniSoundOn];
    NSNumber *numOriginalMusicOn = [[NSNumber alloc] initWithBool:_originalMusicOn];
    NSNumber *numiPodMusicOn = [[NSNumber alloc] initWithBool:_iPodLibMusicOn];
    
    [encoder encodeObject:_imageName forKey:@"ImageName"];
    [encoder encodeObject:numRollSoundOn forKey:@"RollSoundOn"];
    [encoder encodeObject:numSnareSoundOn forKey:@"SnareSoundOn"];
    [encoder encodeObject:numTimpaniSoundOn forKey:@"TimpaniSoundOn"];
    [encoder encodeObject:numOriginalMusicOn forKey:@"OriginalMusicOn"];
    [encoder encodeObject:numiPodMusicOn forKey:@"iPodLibMusicOn"];
    [encoder encodeObject:_mediaItemURL forKey:@"MediaItemURL"];
    [encoder encodeObject:_mediaItemCollection forKey:@"MediaItemCollection"];
    [encoder encodeObject:_artist forKey:@"Artist"];
    [encoder encodeObject:_trackTitle forKey:@"TrackTitle"];

}

// アーカイブから復元するときに呼ばれるメソッド
-(id)initWithCoder:(NSCoder *)decoder{
    
    self = [super init];
    if (self) {
        _imageName = [decoder decodeObjectForKey:@"ImageName"];
        NSNumber *numRollSoundOn = [decoder decodeObjectForKey:@"RollSoundOn"];
        NSNumber *numSnareSoundOn = [decoder decodeObjectForKey:@"SnareSoundOn"];
        NSNumber *numTimpaniSoundOn = [decoder decodeObjectForKey:@"TimpaniSoundOn"];
        NSNumber *numOriginalMusicOn = [decoder decodeObjectForKey:@"OriginalMusicOn"];
        NSNumber *numiPodMusicOn = [decoder decodeObjectForKey:@"iPodLibMusicOn"];
        _rollSoundOn = [numRollSoundOn boolValue];
        _snareSoundOn = [numSnareSoundOn boolValue];
        _timpaniSoundOn = [numTimpaniSoundOn boolValue];
        _originalMusicOn = [numOriginalMusicOn boolValue];
        _iPodLibMusicOn = [numiPodMusicOn boolValue];
        _mediaItemURL = [decoder decodeObjectForKey:@"MediaItemURL"];
        _mediaItemCollection = [decoder decodeObjectForKey:@"MediaItemCollection"];
        _artist = [decoder decodeObjectForKey:@"Artist"];
        _trackTitle = [decoder decodeObjectForKey:@"TrackTitle"];
    }

    return self;
}

@end
