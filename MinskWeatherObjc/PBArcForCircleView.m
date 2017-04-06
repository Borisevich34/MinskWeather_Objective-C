//
//  PBArcForCircleView.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBArcForCircleView.h"

@implementation PBArcForCircleView

- (void)drawRect:(CGRect)rect {
    
    CGSize arcForCircleSize = self.bounds.size;
    CGFloat arcWidth = arcForCircleSize.height / 20.0;
    [[UIColor lightGrayColor] setStroke];

    CGPoint center = CGPointMake(arcForCircleSize.width/2, arcForCircleSize.height/2);
    CGFloat radius = arcForCircleSize.height / 2;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2 * M_PI + 0.5;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius-arcWidth/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    path.lineWidth = arcWidth;
    [path stroke];
}


@end
