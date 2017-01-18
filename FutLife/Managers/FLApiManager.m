//
//  FLApiManager.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLApiManager.h"

static NSString *const kApiRegisterPath = @"m/v1/register";
static NSString *const kApiRegisterComplementPath = @"m/v1/user/avatar";
static NSString *const kApiGamesPath = @"m/v1/games/get";
static NSString *const kApiConsolesPath = @"m/v1/consoles/get";
static NSString *const kApiLoginPath = @"m/v1/login";

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
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kApiRegisterPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

// - POST -
// Register complement request
- (NSURLSessionDataTask *)registerComplementRequestWithModel:(FLComplementRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSData *imageData = requestModel.avatar;
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kApiRegisterComplementPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];   // add image to formData
//        
//        [formData appendPartWithFormData:[@"sdsd" dataUsingEncoding:NSUTF8StringEncoding] name:@"key1"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

// - GET -
// Consoles request
- (NSURLSessionDataTask *)consolesRequestWithSuccess:(void (^)(FLConsoleResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    return [self GET:kApiConsolesPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLConsoleResponseModel *response = [MTLJSONAdapter modelOfClass:[FLConsoleResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

// - GET -
// Games request
- (NSURLSessionDataTask *)gamesRequestWithSuccess:(void (^)(FLGameResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    return [self GET:kApiGamesPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLGameResponseModel *response = [MTLJSONAdapter modelOfClass:[FLGameResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

// - POST -
// Login request
- (NSURLSessionDataTask *)loginRequestWithModel:(FLLoginRequestModel *)requestModel success:(void (^)(FLLoginResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kApiLoginPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLLoginResponseModel *response = [MTLJSONAdapter modelOfClass:[FLLoginResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

@end
