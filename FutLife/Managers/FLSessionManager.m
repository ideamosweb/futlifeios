//
//  FLSessionManager.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLSessionManager.h"

@interface FLSessionManager ()

@end

@implementation FLSessionManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLSessionManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLSessionManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    // Creates a AFHTTPSessionManager object with base URL set in .plist
    NSURL *baseUrl = [NSURL URLWithString:FLApiBaseUrl()];
    self = [super initWithBaseURL:baseUrl];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Nothing to do (?)
    }
    
    return self;
}

- (id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        // Nothing to do (?)
    }
    
    return self;
}

@end
