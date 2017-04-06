//
//  PBArcView.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBArcView.h"

@interface PBArcView ()
@property (nonatomic, assign) CGFloat arcWidth;
@property (nonatomic, assign) CGFloat ratio;
@end

@implementation PBArcView

- (void)drawRect:(CGRect)rect {
    CGFloat ratio = 0.07143;
    CGSize arcSize = self.bounds.size;
    CGFloat arcWidth = arcSize.width * ratio;
    UIColor *arcColor = [UIColor grayColor];
    [arcColor setStroke];
    
    CGPoint center = CGPointMake(arcSize.width/2, arcSize.height/2);
    CGFloat radius = arcSize.height;
    
    CGFloat startAngle = 3.0 * M_PI_4;
    CGFloat endAngle = M_PI_4;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius/2 - arcWidth/2
                                                    startAngle:startAngle endAngle:endAngle clockwise: YES];

    path.lineWidth = arcWidth;
    [path stroke];

    CGFloat leftX = center.x - (radius/2) * sin(M_PI_4);
    CGFloat leftY = center.y + (radius/2) * cos(M_PI_4);
    CGPoint leftCenter = CGPointMake(leftX, leftY);
    [arcColor setStroke];
    UIBezierPath *leftPath = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:0.0715 * arcSize.width/2
                                                    startAngle:M_PI_4 endAngle:7.0*M_PI_4 clockwise: false];
    leftPath.lineWidth = 0.0715 * arcSize.width;
    [leftPath stroke];

    CGFloat rightX = center.x + (radius/2) * sin(M_PI_4);
    CGPoint rightCenter = CGPointMake(rightX, leftY);
    [arcColor setStroke];
    UIBezierPath *rightPath = [UIBezierPath bezierPathWithArcCenter:rightCenter radius:0.0715 * arcSize.width/2
                                                        startAngle:3.0*M_PI_4 endAngle:5.0*M_PI_4 clockwise: true];
    rightPath.lineWidth = 0.0715 * arcSize.width;
    [rightPath stroke];
}


@end
