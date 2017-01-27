//
//  FLTemporalSessionManager.m
//  FutLife
//
//  Created by Rene Santis on 1/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLTemporalSessionManager.h"

@implementation FLTemporalSessionManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLTemporalSessionManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLTemporalSessionManager alloc] init];
    });
    return sharedInstance;
}

@end
