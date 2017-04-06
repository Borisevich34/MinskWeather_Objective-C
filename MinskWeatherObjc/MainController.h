//
//  ViewController.h
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBNetwork.h"


typedef struct {
    CGFloat left;
    CGFloat right;
} PBDuration;

@class PBArcView;
@class PBGradientView;
@class PBAnimationState;
@class PBArrowView;

@interface MainController : UIViewController <PBNetworkDelegate> {
    
}

@property (weak, nonatomic) IBOutlet PBArcView *arcView;
@property (weak, nonatomic) IBOutlet PBArrowView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UIView *ghostView;
@property (weak, nonatomic) IBOutlet PBGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UILabel *rangeTemp;


@end
