//
//  PBGradientView.h
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ratio 0.125

@interface PBGradientView : UIView {
    
    NSMutableArray *gradColors;
    NSMutableArray *minBorderOfRanges;
    NSMutableArray *maxBorderOfRanges;
    NSMutableArray *valuesOfRanges;
    int gradientLength;
    CGFloat angleOfValue;
    CGFloat gradientWidth;
}

@property (nonatomic) IBInspectable UIColor *gradColor_1;
@property (nonatomic) IBInspectable UIColor *gradColor_2;
@property (nonatomic) IBInspectable UIColor *gradColor_3;
@property (nonatomic) IBInspectable UIColor *gradColor_4;
@property (nonatomic) IBInspectable UIColor *gradColor_5;

- (void)calculateRanges;

@end
