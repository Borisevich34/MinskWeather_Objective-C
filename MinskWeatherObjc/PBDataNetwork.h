//
//  PBDataNetwork.h
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBDataNetwork : NSObject
@property (nonatomic, assign) int current;
@property (nonatomic, strong) NSMutableArray *minTemps;
@property (nonatomic, strong) NSMutableArray *maxTemps;

@property (nonatomic, assign, getter = getMin) int min;
@property (nonatomic, assign, getter = getMax) int max;
@end

