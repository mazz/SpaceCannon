//
//  CrunchInstrument.m
//  Space Cannon
//
//  Created by Aurelius Prochazka and Nick Arner on 11/14/14.
//  Copyright (c) 2014 AudioKit. All rights reserved.
//

#import "CrunchInstrument.h"

@implementation CrunchInstrument
- (instancetype)init
{
    self = [super init];
    if (self) {
        Crunch *note = [[Crunch alloc] init];
        [self addNoteProperty:note.intensity];
        [self addNoteProperty:note.damping];
        [self addNoteProperty:note.pan];
        
        AKCrunch *crunch = [AKCrunch crunch];
        crunch.intensity = note.intensity;
        crunch.dampingFactor = note.damping;
        [self connect:crunch];
        
        AKLowPassButterworthFilter *lowPassFilter;
        lowPassFilter = [[AKLowPassButterworthFilter alloc] initWithInput:crunch cutoffFrequency:akp(1200)];
        [self connect:lowPassFilter];
        
        _auxilliaryOutput = [AKAudio globalParameter];
        [self assignOutput:_auxilliaryOutput to:lowPassFilter];
    }
    return self;
}

@end


@implementation Crunch

- (instancetype)init {
    self = [super init];
    if (self) {
        _intensity = [[AKNoteProperty alloc] initWithValue:180 minimum:180 maximum:240];
        [self addProperty:_intensity];
        
        _damping = [[AKNoteProperty alloc] initWithValue:0.4 minimum:0.05 maximum:0.4];
        [self addProperty:_damping];
        
        _pan = [[AKNoteProperty alloc] initWithValue:0.5 minimum:0 maximum:1];
        [self addProperty:_pan];
        
    }
    return self;
}


- (instancetype)initWithIntensity:(float)intensity damping:(float)damping pan:(float)pan
{
    self = [self init];
    if (self) {
        _pan.value = pan;
        _intensity.value = intensity;
        _damping.value = damping;
        self.duration.value = 1.0;
    }
    return self;
}


- (instancetype)initAsDeepCrunch
{
    return [self initWithIntensity:240
                           damping:0.05
                               pan:0.5];
}

@end
