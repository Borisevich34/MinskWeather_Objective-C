//
//  PBAnimationState.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBAnimationState.h"

@implementation PBAnimationState
@synthesize state;

- (instancetype)initWithState: (PBAnimationStructState) stateInit
{
    self = [super init];
    if (self) {
        state = stateInit;
    }
    return self;
}

- (void)next {
    switch (state) {
        case UpToRight:
            state = RightToUp;
            break;
        case RightToUp:
            state = UpToLeft;
            break;
        case UpToLeft:
            state = LeftToUp;
            break;
        case LeftToUp:
            state = UpToRight;
            break;
    }
}

- (BOOL)isAngleInState: (CGFloat) angle {
    switch (state) {
        case UpToRight:
            return angle > 0;
        case RightToUp:
            return angle > 0;
        case UpToLeft:
            return angle <= 0;
        case LeftToUp:
            return angle <= 0;
    }
}

- (BOOL)isNeedRightDuration {
    switch (state) {
        case UpToRight:
            return false;
        case RightToUp:
            return true;
        case UpToLeft:
            return true;
        case LeftToUp:
            return false;
    }
}

- (PBStateParameters)getParameters {
    
    switch (state) {
        case UpToRight:
            return (PBStateParameters){.delay = 0, .options = UIViewAnimationOptionCurveEaseOut, .angle = M_PI/1.65};
        case RightToUp:
            return (PBStateParameters){.delay = 0.5, .options = UIViewAnimationOptionCurveEaseIn, .angle = 0};
        case UpToLeft:
            return (PBStateParameters){.delay = 0, .options = UIViewAnimationOptionCurveEaseOut, .angle = -M_PI/1.65};
        case LeftToUp:
            return (PBStateParameters){.delay = 0.5, .options = UIViewAnimationOptionCurveEaseIn, .angle = 0};
    }
}
@end
