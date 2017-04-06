//
//  PBGradientView.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBGradientView.h"
#import "PBNetwork.h"

@implementation PBGradientView

@synthesize gradColor_1;
@synthesize gradColor_2;
@synthesize gradColor_3;
@synthesize gradColor_4;
@synthesize gradColor_5;

-(void)awakeFromNib {
    [super awakeFromNib];
    
    gradientLength = 5;
    angleOfValue = 3.0 * M_PI / 10.0;
    
    minBorderOfRanges = [[NSMutableArray alloc] initWithArray: @[@0, @1, @2, @3, @4]];
    maxBorderOfRanges = [[NSMutableArray alloc] initWithArray: @[@1, @2, @3, @4, @5]];
    valuesOfRanges = [[NSMutableArray alloc] initWithArray: @[@1, @1, @1, @1, @1]];
    
    gradColors = [[NSMutableArray alloc] initWithObjects:gradColor_1, gradColor_2, gradColor_3, gradColor_4, gradColor_5, nil];
    gradientWidth = ratio * self.bounds.size.width;
}

- (void)drawRect:(CGRect)rect {
    
    CGSize gradientSize = self.bounds.size;
    CGPoint center = CGPointMake(gradientSize.width/2.0, gradientSize.height/2.0);
    CGFloat radius = gradientSize.height;
    CGFloat startAngle = 3.0 * M_PI_4;
    
    CGFloat leftX = center.x - (radius/2.0 - gradientWidth/2.0) * sin(M_PI_4) - 0.5;
    CGFloat leftY = center.y + (radius/2.0 - gradientWidth/2.0) * cos(M_PI_4) - 0.5;
    
    CGPoint leftCenter = CGPointMake(leftX, leftY);
    [[gradColors objectAtIndex:0] setStroke];
    
    UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:gradientWidth/4.0
                                                        startAngle:startAngle endAngle:7.0 * M_PI_4 clockwise:NO];
    leftPath.lineWidth = gradientWidth/2.0;
    [leftPath stroke];
    
    for (int i = 0; i < 5; i++) {
        [[gradColors objectAtIndex:i] setStroke];
        CGFloat endAngle = startAngle + angleOfValue * [(NSNumber *)[valuesOfRanges objectAtIndex:i] doubleValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2.0 - gradientWidth/2.0
                                                        startAngle:startAngle endAngle:endAngle clockwise:YES];
        path.lineWidth = gradientWidth;
        [path stroke];
        
        startAngle += angleOfValue * [(NSNumber *)[valuesOfRanges objectAtIndex:i] doubleValue];
    }

    CGFloat rightX = center.x + (radius/2.0 - gradientWidth/2.0) * sin(M_PI_4) + 0.5;
    CGPoint rightCenter = CGPointMake(rightX, leftY);
    [[gradColors objectAtIndex:4] setStroke];
    
    UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:rightCenter radius:gradientWidth/4.0
                                                        startAngle:startAngle endAngle:5.0 * M_PI_4 clockwise:YES];
    rightPath.lineWidth = gradientWidth/2.0;
    [rightPath stroke];
}

- (void)calculateRanges {
    
    CGFloat min = [[PBNetwork shared].data getMin];
    CGFloat max = [[PBNetwork shared].data getMax];
    
    CGFloat interval = (max - min)/5.0;
    
    for (int i = 0; i < minBorderOfRanges.count; i++) {
        [minBorderOfRanges setObject:[NSNumber numberWithDouble:min] atIndexedSubscript:i];
        [maxBorderOfRanges setObject:[NSNumber numberWithDouble:min + interval] atIndexedSubscript:i];
        min += interval;
    }

    NSMutableArray *minTemps = [PBNetwork shared].data.minTemps;
    NSMutableArray *maxTemps = [PBNetwork shared].data.maxTemps;
    
    int sumTemps = 0;
    for (int i = 0; i < minTemps.count; i++) {
        sumTemps += [[maxTemps objectAtIndex:i] intValue] - [[minTemps objectAtIndex:i] intValue] + 1;
    }
    
    
    int minValueOfRange = sumTemps/20 > 0 ? sumTemps/20 : 1;
    NSMutableArray *newValuesOfRanges = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:minValueOfRange],
                                         [NSNumber numberWithInt:minValueOfRange], [NSNumber numberWithInt:minValueOfRange],
                                         [NSNumber numberWithInt:minValueOfRange], [NSNumber numberWithInt:minValueOfRange], nil];
    int newGradientlength = sumTemps + 5 * minValueOfRange;
    
    for (int i = 0; i < minTemps.count; i++) {
        
        int minTemp = [(NSNumber *)[minTemps objectAtIndex:i] intValue];
        int maxTemp = [(NSNumber *)[maxTemps objectAtIndex:i] intValue];
        
        for (int j = 0; j < 5; j++) {
            
            CGFloat minBorder = [(NSNumber *)[minBorderOfRanges objectAtIndex:j] doubleValue];
            CGFloat maxBorder = [(NSNumber *)[maxBorderOfRanges objectAtIndex:j] doubleValue];
        
            int newValueOfRange = [(NSNumber *)[newValuesOfRanges objectAtIndex:j] intValue];
            
            if ( maxTemp >= minBorder && minTemp < maxBorder) {
                if (minTemp <= minBorder) {
                    if (maxTemp < maxBorder) {
                        [newValuesOfRanges setObject:[NSNumber numberWithInt:newValueOfRange +
                                                      maxTemp - ((int)ceil(minBorder)) + 1] atIndexedSubscript:j];
                        break;
                    } else {
                        [newValuesOfRanges setObject:[NSNumber numberWithInteger:newValueOfRange +
                                                      ((int)ceil(maxBorder)) - ((int)ceil(minBorder))] atIndexedSubscript:j];
                    }
                } else if (maxTemp < maxBorder) {
                    [newValuesOfRanges setObject:[NSNumber numberWithInt:newValueOfRange +
                                                  maxTemp - minTemp + 1] atIndexedSubscript:j];
                    break;
                } else {
                    [newValuesOfRanges setObject:[NSNumber numberWithInt:newValueOfRange +
                                                  ((int)ceil(maxBorder)) - minTemp] atIndexedSubscript:j];
                }
            }
        }
    }
    
    NSNumber* values = [newValuesOfRanges valueForKeyPath: @"@sum.self"];
    int newValueOfRange = [(NSNumber *)[newValuesOfRanges objectAtIndex:4] intValue];
    [newValuesOfRanges setObject:[NSNumber numberWithInt:newValueOfRange + newGradientlength - [values intValue]] atIndexedSubscript:4];
    
    gradientLength = newGradientlength;
    valuesOfRanges = newValuesOfRanges;
    
    angleOfValue = 3.0 * M_PI_2 / (CGFloat)newGradientlength;
}

@end
