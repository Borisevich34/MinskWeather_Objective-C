//
//  ViewController.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "MainController.h"
#import "PBGradientView.h"
#import "PBAnimationState.h"
#import "PBArrowView.h"
#import "PBArcView.h"

@interface MainController ()
@property (strong, nonatomic) PBAnimationState *state;
@property (assign, nonatomic) BOOL isAnimate;
@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) PBDuration duration;
@property (strong, nonatomic) UIAlertController *alertController;
- (void)startAnimating;
- (void)calculateAnimation;
@end

@implementation MainController

@synthesize gradientView;
@synthesize state;
@synthesize isAnimate;
@synthesize angle;
@synthesize duration;
@synthesize alertController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAnimate = YES;
    duration = (PBDuration){.left = 0.0, .right = 0.0};
    state = [[PBAnimationState alloc] initWithState: UpToRight];
    angle = 0.0;
    
    alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Try again please" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[PBNetwork shared] loadHistory];
    }];
    [alertController addAction:alertAction];
    
    [self startAnimating];
    
    [PBNetwork shared].delegate = self;
    [[PBNetwork shared] loadHistory];
}

- (void)startAnimating {
    PBStateParameters parameters = [state getParameters];
    __weak MainController *weakSelf = self;
    [UIView animateWithDuration:2 delay:parameters.delay options:parameters.options animations:^{
        weakSelf.arrowView.layer.transform = CATransform3DMakeRotation(parameters.angle, 0, 0, 1);
    } completion:^(BOOL finished) {
        [weakSelf.state next];
        if (weakSelf.isAnimate) {
            [weakSelf startAnimating];
        } else if ([weakSelf.state isAngleInState:weakSelf.angle]) {
            [weakSelf.gradientView calculateRanges];
            PBStateParameters newParameters = [state getParameters];
            CGFloat pinDuration = weakSelf.state.isNeedRightDuration ? weakSelf.duration.right : weakSelf.duration.left;
            UIViewAnimationOptions options = newParameters.options == UIViewAnimationOptionCurveEaseIn ? UIViewAnimationOptionCurveEaseInOut : newParameters.options;
            [UIView animateWithDuration:pinDuration delay:newParameters.delay options:options animations:^{
                weakSelf.arrowView.layer.transform = CATransform3DMakeRotation(weakSelf.angle, 0, 0, 1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.gradientView.alpha = 0;
                    weakSelf.arcView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.gradientView setNeedsDisplay];
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.gradientView.alpha = 1;
                        weakSelf.arcView.alpha = 0.1;
                    }];
                }];
                weakSelf.currentTemp.text = [NSString stringWithFormat:@"%d ºC", PBNetwork.shared.data.current];
                weakSelf.rangeTemp.text = [NSString stringWithFormat:@"%d ºC  to  %d ºC", PBNetwork.shared.data.getMin, PBNetwork.shared.data.getMax];
                [UIView animateWithDuration:1 animations:^{
                    weakSelf.ghostView.alpha = 1;
                    weakSelf.currentTemp.alpha = 1;
                } completion:^(BOOL finished) {
                    [weakSelf.updateButton setEnabled:YES];
                }];
            }];
        }
        else {
            [weakSelf startAnimating];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateAnimation {

    int max = PBNetwork.shared.data.getMax;
    int min = PBNetwork.shared.data.getMin;
    int current = PBNetwork.shared.data.current;

    if (max - current >= current - min) {
        angle = ((CGFloat)(2.0 * current - max - min) / ((CGFloat)max - min)) *  (CGFloat)(M_PI/1.65);
        CGFloat rightDuration = ((CGFloat)(max + min - 2 * current) / ((CGFloat)max - min)) * 2;
        duration = (PBDuration){.left = 2.5 - rightDuration, .right = rightDuration};
    }
    else {
        angle = ((CGFloat)(2.0 * current - max - min) / ((CGFloat)max - min)) *  (CGFloat)(M_PI/1.65);
        CGFloat leftDuration = ((CGFloat)(2 * current - max - min) / ((CGFloat)max - min)) * 2;
        duration = (PBDuration){.left = leftDuration, .right = 2.5 - leftDuration};
    }
}


- (IBAction)updatePressed:(id)sender {
    [_updateButton setEnabled:NO];
    [UIView animateWithDuration:1 animations:^{
        _ghostView.alpha = 0;
        _currentTemp.alpha = 0;
    } completion:^(BOOL finished) {
        if (angle != 0) {
            CGFloat pinDuration;
            if (angle > 0) {
                state = [[PBAnimationState alloc] initWithState:RightToUp];
                pinDuration = duration.left;
            }
            else {
                state = [[PBAnimationState alloc] initWithState:LeftToUp];
                pinDuration = duration.right;
            }
            __weak MainController *weakSelf = self;
            [UIView animateWithDuration:pinDuration delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakSelf.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            } completion:^(BOOL finished) {
                weakSelf.isAnimate = YES;
                [weakSelf startAnimating];
                [PBNetwork.shared loadHistory];
            }];
        }
        else {
            self.isAnimate = YES;
            [self startAnimating];
            [PBNetwork.shared loadHistory];
        }
    }];
}

#pragma mark - PBNetworkDelegate

- (void)historyLoadedWithSucces:(BOOL)isSuccess {
    if (isSuccess) {
        [self calculateAnimation];
        isAnimate = NO;
    }
    else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
