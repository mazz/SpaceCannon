//
//  Conductor.m
//  Space Cannon
//
//  Created by Aurelius Prochazka on 11/8/14.
//  Copyright (c) 2014 Hear For Yourself. All rights reserved.
//

#import "Conductor.h"

#import "AKFoundation.h"

#import "SoftBoingInstrument.h"
#import "CrunchInstrument.h"
#import "BuzzInstrument.h"
#import "LaserInstrument.h"
#import "ZwoopInstrument.h"
#import "SirenInstrument.h"
#import "SpaceVerb.h"

@implementation Conductor
{
    SoftBoingInstrument *softBoingInstrument;
    CrunchInstrument *crunchInstrument;
    BuzzInstrument *buzzInstrument;
    LaserInstrument *laserInstrument;
    ZwoopInstrument *zwoopInstrument;
    SirenInstrument *sirenInstrument;
    SpaceVerb *spaceVerb;
    
    CGSize playFieldSize;
}

- (instancetype)initWithPlayfieldSize:(CGSize)size
{
    self = [super init];
    if (self) {
        playFieldSize = size;
        
        AKOrchestra *orchestra = [[AKOrchestra alloc] init];
        softBoingInstrument = [[SoftBoingInstrument alloc] init];
        [orchestra addInstrument:softBoingInstrument];
        
        crunchInstrument = [[CrunchInstrument alloc] init];
        [orchestra addInstrument:crunchInstrument];
        
        buzzInstrument = [[BuzzInstrument alloc] init];
        [orchestra addInstrument:buzzInstrument];
        
        laserInstrument = [[LaserInstrument alloc] init];
        [orchestra addInstrument:laserInstrument];
        
        zwoopInstrument = [[ZwoopInstrument alloc] init];
        [orchestra addInstrument:zwoopInstrument];
        
        sirenInstrument = [[SirenInstrument alloc]init];
        [orchestra addInstrument:sirenInstrument];
        
        
        spaceVerb = [[SpaceVerb alloc] initWithSoftBoing:softBoingInstrument.auxilliaryOutput
                                                  crunch:crunchInstrument.auxilliaryOutput
                                                    buzz:buzzInstrument.auxilliaryOutput
                                                   laser:laserInstrument.auxilliaryOutput
                                                   zwoop:zwoopInstrument.auxilliaryOutput
                                                   siren:sirenInstrument.auxilliaryOutput];
        [orchestra addInstrument:spaceVerb];
        
        [[AKManager sharedAKManager] runOrchestra:orchestra];
        
        [spaceVerb play];
    }
    
    return self;
}

- (void)resetAll
{
    [sirenInstrument stop];
}

// -----------------------------------------------------------------------------
#  pragma mark - Halo Lifespan Events
// -----------------------------------------------------------------------------

- (void)haloSpawnedAtPosition:(CGPoint)position isMultiplier:(bool)isMultiplier
{
    NSLog(@"Halo Spawned, no sound yet");

}

- (void)haloHitEdgeAtPosition:(CGPoint)position
{
    float pan = 0.0;
    if (position.x > playFieldSize.width/2.0) pan = 1.0;
    
    float y = position.y / playFieldSize.height;
    
    float amplitude = 1.2- 0.9 * y;
    float frequency = 1200 - position.y; // AOP HOKEY
    
    Buzz  *newBuzz = [[Buzz alloc] initWithFrequency:frequency
                                           amplitude:amplitude
                                                 pan:pan];
    [buzzInstrument playNote:newBuzz];
}

- (void)haloHitBallAtPosition:(CGPoint)position
{
    float pan = position.x/playFieldSize.width;
    float y = position.y / playFieldSize.height;
    
    [crunchInstrument playForDuration:1.4];
    Crunch *crunch = [[Crunch alloc] initWithCount:53
                                           damping:0.43+0.2*y
                                               pan:pan];
    [crunchInstrument playNote:crunch];
}

- (void)haloHitShieldAtPosition:(CGPoint)position
{
    // AOP Placeholder
    [self haloHitBallAtPosition:position];
}

- (void)haloHitLifeBar
{
    Crunch *deepCrunch = [[Crunch alloc] initAsDeepCrunch];
    deepCrunch.duration.value = 2.0;
    [crunchInstrument playNote:deepCrunch];
}

// -----------------------------------------------------------------------------
#  pragma mark - Shield Power Up Events
// -----------------------------------------------------------------------------

- (void)spawnedShieldPowerUpAtPosition:(CGPoint)position {
    [sirenInstrument play];
}

- (void)updateShieldPowerUpPosition:(CGPoint)position
{
    float pan = position.x/playFieldSize.width;
    sirenInstrument.pan.value = pan;
}

- (void)replacedShieldAtPosition:(CGPoint)position {
    [sirenInstrument stop];
    float pan = position.x/playFieldSize.width;
    Zwoop *zwoop = [[Zwoop alloc] initWithPan:pan];
    [zwoopInstrument playNote:zwoop];
}

- (void)shieldPowerUpLost
{
    [sirenInstrument stop];
}

// -----------------------------------------------------------------------------
#  pragma mark - Player Events
// -----------------------------------------------------------------------------

- (void)playerShotBallWithRotationVector:(CGVector)rotationVector remaningAmmo:(int)remainingAmmo pointValue:(int)pointValue
{
    NSLog(@"Player shot at X %f Y% and has %d ammo left" , rotationVector.dx, rotationVector.dy, remainingAmmo);
    LaserNote *laser = [[LaserNote alloc] initWithSpeed:1.0 + (8.0 / (remainingAmmo+1)) pan:(1.0+rotationVector.dx)/2.0];
    [laserInstrument playNote:laser];
}

- (void)attemptedShotWithoutAmmo {
    LaserNote *laser = [[LaserNote alloc] initWithSpeed:10.0 pan:0.5];
    [laserInstrument playNote:laser];
}

- (void)ballBouncedAtPosition:(CGPoint)position
{
    float pan = 0.0;
    if (position.x > playFieldSize.width/2.0) pan = 1.0;
    
    SoftBoing *note = [[SoftBoing alloc] initWithPan:pan];
    [softBoingInstrument playNote:note];
}

- (void)multiplierModeStartedWithPointValue:(int)points {
    NSLog(@"Maybe another siren type sound");
    
    //if shot when multiplier mode is on, change parameter of the shot
}
- (void)multiplierModeEnded {
    NSLog(@"End the multiplier sound");
}



@end
