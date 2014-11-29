//
//  SpaceVerb.m
//  Space Cannon
//
//  Created by Aurelius Prochazka on 11/14/14.
//  Copyright (c) 2014 Hear For Yourself. All rights reserved.
//

#import "SpaceVerb.h"

@implementation SpaceVerb

- (instancetype)initWithSoftBoing:(AKStereoAudio *)softBoing
                           crunch:(AKAudio *)crunch
                             buzz:(AKStereoAudio *)buzz
                            laser:(AKStereoAudio *)laser
                            zwoop:(AKStereoAudio *)zwoop
                            siren:(AKStereoAudio *)siren
                           menace:(AKStereoAudio *)menace;
{
    self = [super init];
    if (self) {
        
        _feedbackLevel = [[AKInstrumentProperty alloc] initWithValue:0.8 minimum:0.0 maximum:0.95];
        [self addProperty:_feedbackLevel];

        AKSum *leftSum = [[AKSum alloc] initWithOperands:softBoing.leftOutput, crunch, buzz.leftOutput, laser.leftOutput, zwoop.leftOutput, siren.leftOutput, menace.leftOutput, nil];
        [self connect:leftSum];
        
        AKSum *rightSum = [[AKSum alloc] initWithOperands:softBoing.rightOutput, crunch, buzz.rightOutput, laser.rightOutput, zwoop.rightOutput, siren.rightOutput, menace.rightOutput, nil];
        [self connect:rightSum];
        
        AKStereoAudio *stereoSum = [[AKStereoAudio alloc] initWithLeftAudio:leftSum rightAudio:rightSum];
        
        AKReverb *reverb = [[AKReverb alloc] initWithStereoAudioSource:[stereoSum scaledBy:akp(0.33)]
                                                         feedbackLevel:_feedbackLevel
                                                        cutoffFrequency:akp(14000)];
        [self connect:reverb];
        
        AKMixedAudio *leftmix = [[AKMixedAudio alloc] initWithSignal1:leftSum signal2:reverb.leftOutput balance:akp(0.5)];
        [self connect:leftmix];
        AKMixedAudio *rightmix = [[AKMixedAudio alloc] initWithSignal1:rightSum signal2:reverb.rightOutput balance:akp(0.5)];
        [self connect:rightmix];
        
        AKAudioOutput *output = [[AKAudioOutput alloc] initWithLeftAudio:leftmix rightAudio:rightmix];
        [self connect:output];
        
        // RESET INPUTS ========================================================
        [self resetParameter:softBoing];
        [self resetParameter:crunch];
        [self resetParameter:buzz];
        [self resetParameter:laser];
        [self resetParameter:siren];
        [self resetParameter:menace];
        
    }
    return self;
}
@end
