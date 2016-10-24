//
//  FLApiManager.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLApiManager.h"

static NSString *const kRegisterPath = @"m/v1/register";

@implementation FLApiManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLApiManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLApiManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

// - POST -
// Register request
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kRegisterPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
