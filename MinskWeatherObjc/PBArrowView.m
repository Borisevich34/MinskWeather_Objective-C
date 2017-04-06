//
//  PBArrowView.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBArrowView.h"

@implementation PBArrowView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGSize arrowSize = self.bounds.size;
    CGContextAddEllipseInRect(context, CGRectMake(arrowSize.width/2 - 15, 0, 30, 30));
    CGContextMoveToPoint(context, arrowSize.width/2, 38.3);
    CGContextAddLineToPoint(context, arrowSize.width/2 - 13.3, 22.3);
    CGContextAddLineToPoint(context, arrowSize.width/2 + 13.3, 22.3);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextFillPath(context);
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(arrowSize.width/2 - 6, 9, 12, 12));
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextFillPath(context);
}

@end

