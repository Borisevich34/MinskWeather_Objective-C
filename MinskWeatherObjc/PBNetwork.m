//
//  PBNetwork.m
//  MinskWeatherObjc
//
//  Created by Pavel Borisevich on 28.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

#import "PBNetwork.h"
#import "PBDataNetwork.h"

@implementation PBNetwork

@synthesize data;
@synthesize delegate;

+ (PBNetwork *)shared {
    static PBNetwork *sharedNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[self alloc] init];
    });
    return sharedNetwork;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        data = [[PBDataNetwork alloc] init];
    }
    return self;
}
- (void)loadHistory {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 5;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString: @"http://api.openweathermap.org/data/2.5/weather?q=Minsk&APPID=b4474caa975a1f5b5c4f8362b59a31b8&units=metric"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        if (error) {
            [delegate historyLoadedWithSucces:NO];
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                [delegate historyLoadedWithSucces:NO];
            } else {
                NSError *jsonError = nil;
                id jsonDictionary = [NSJSONSerialization
                                     JSONObjectWithData:jsonData
                                     options:0
                                     error:&jsonError];
                if ([jsonDictionary isKindOfClass:[NSDictionary class]] &&
                    [self parseCurrentJsonDictionary:(NSDictionary *)jsonDictionary]) {
                    [self loadRangeHistory];
                } else {
                    [delegate historyLoadedWithSucces:NO];
                }
            }
        }
    }];
    [task resume];
}
- (void)loadRangeHistory {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 5;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString: @"http://api.openweathermap.org/data/2.5/forecast/daily?q=Minsk&mode=json&units=metric&cnt=16&appid=b4474caa975a1f5b5c4f8362b59a31b8"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        if (error) {
            [delegate historyLoadedWithSucces:NO];
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                [delegate historyLoadedWithSucces:NO];
            } else {
                NSError *jsonError = nil;
                id jsonDictionary = [NSJSONSerialization
                                     JSONObjectWithData:jsonData
                                     options:0
                                     error:&jsonError];
                if ([jsonDictionary isKindOfClass:[NSDictionary class]] &&
                    [self parseRangeJsonDictionary:(NSDictionary *)jsonDictionary]) {
                    [delegate historyLoadedWithSucces:YES];
                } else {
                    [delegate historyLoadedWithSucces:NO];
                }
            }
        }
    }];
    [task resume];
}

- (BOOL)parseCurrentJsonDictionary: (NSDictionary *)dictionary {
    id jsonMain = [dictionary objectForKey: @"main"];
    if ([jsonMain isKindOfClass: [NSDictionary class]]) {
        id jsonTemp = [jsonMain objectForKey: @"temp"];
        if ([jsonTemp isKindOfClass: [NSNumber class]]) {
            data.current = [(NSNumber *)jsonTemp intValue];
            return YES;
        }
    }
    return NO;
}

- (BOOL)parseRangeJsonDictionary: (NSDictionary *)dictionary {
    NSMutableArray *minTemps = [[NSMutableArray alloc] init];
    NSMutableArray *maxTemps = [[NSMutableArray alloc] init];
    @try {
        id jsonList = [dictionary objectForKey: @"list"];
        for (NSDictionary *element in (NSArray *)jsonList) {
            NSNumber *minTemp = [(NSDictionary *)[element objectForKey:@"temp"] objectForKey:@"min"];
            NSNumber *maxTemp = [(NSDictionary *)[element objectForKey:@"temp"] objectForKey:@"max"];
            
            [minTemps addObject:[NSNumber numberWithInt:[minTemp intValue]]];
            [maxTemps addObject:[NSNumber numberWithInt:[maxTemp intValue]]];
            
        }
        data.minTemps = minTemps;
        data.maxTemps = maxTemps;
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

@end
