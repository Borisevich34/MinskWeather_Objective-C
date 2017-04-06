//
//  PBDataNetwork.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBDataNetwork.h"

@implementation PBDataNetwork
@synthesize current;
@synthesize minTemps;
@synthesize maxTemps;

- (int)getMin {
    id result = ([minTemps valueForKeyPath:@"@min.self"]);
    return [result isKindOfClass:[NSNumber class]] ? ((NSNumber *)result).intValue : current;
}

- (int)getMax {
    id result = ([maxTemps valueForKeyPath:@"@max.self"]);
    return [result isKindOfClass:[NSNumber class]] ? ((NSNumber *)result).intValue : current;
}

@end
