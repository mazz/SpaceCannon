//
//  SirenInstrument.m
//  Space Cannon
//
//  Created by Nicholas Arner on 11/18/14.
//  Copyright (c) 2014 Hear for Yourself. All rights reserved.
//


#import "SirenInstrument.h"

@implementation SirenInstrument


- (instancetype)init
{
    self = [super init];
    if (self) {
        _pan = [[AKInstrumentProperty alloc] initWithValue:1.0 minimum:0.0 maximum:1.0];
        [self addProperty:_pan];
        
        AKLinearADSRControlEnvelope *adsr = [[AKLinearADSRControlEnvelope alloc] initWithAttackDuration:akp(0.1)
                                                                                          decayDuration:akp(0.0)
                                                                                           sustainLevel:akp(1.0)
                                                                                        releaseDuration:akp(1.00)];
        [self connect:adsr];
        
        AKSineTable *sine;
        sine = [[AKSineTable alloc] init];
        [self addFTable:sine];
        
        AKFMOscillator *fmOscil = [[AKFMOscillator alloc]initWithFTable:sine
                                                          baseFrequency:akp(61)
                                                      carrierMultiplier:akp(1.74)
                                                   modulatingMultiplier:akp(0.17)
                                                        modulationIndex:akp(22.0)
                                                              amplitude:[adsr scaledBy:akp(0.3)]];
        
        [self connect:fmOscil];
        
        AKPanner *panner = [[AKPanner alloc] initWithAudioSource:fmOscil
                                                             pan:_pan];
        [self connect:panner];
        
        _auxilliaryOutput = [AKStereoAudio globalParameter];
        [self assignOutput:_auxilliaryOutput to:panner];
    }
    return self;
}
@end
