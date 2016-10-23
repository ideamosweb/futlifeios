//
//  FLSessionManager.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface FLSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

@end
