//
//  PBAnimationState.h
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    UpToRight,
    RightToUp,
    UpToLeft,
    LeftToUp
} PBAnimationStructState;

typedef struct {
    double delay;
    UIViewAnimationOptions options;
    CGFloat angle;
} PBStateParameters;

@interface PBAnimationState : NSObject
@property (nonatomic, assign) PBAnimationStructState state;

- (instancetype)initWithState: (PBAnimationStructState) stateInit;

- (void)next;
- (BOOL)isAngleInState: (CGFloat) angle;
- (BOOL)isNeedRightDuration;
- (PBStateParameters)getParameters;

@end
