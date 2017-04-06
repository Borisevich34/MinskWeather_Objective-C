//
//  PBNetwork.h
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBDataNetwork.h"

@protocol PBNetworkDelegate;

@interface PBNetwork : NSObject

+ (PBNetwork *)shared;
- (void)loadHistory;

@property (nonatomic, strong) PBDataNetwork *data;
@property (nonatomic, weak) id<PBNetworkDelegate> delegate;
@end

@protocol PBNetworkDelegate
- (void)historyLoadedWithSucces: (BOOL)isSuccess;
@end
