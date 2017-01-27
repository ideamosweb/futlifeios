//
//  FLApiManager.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLApiManager.h"

static NSString *const kApiTokenQuery = @"?token=%@";

static NSString *const kApiRegisterPath = @"m/v1/register";
static NSString *const kApiRegisterPreferencesPath = @"m/v1/user/preferences%@";
static NSString *const kApiRegisterAvatarPath = @"m/v1/user/avatar%@";
static NSString *const kApiGamesPath = @"m/v1/games/get";
static NSString *const kApiConsolesPath = @"m/v1/consoles/get";
static NSString *const kApiLoginPath = @"m/v1/login";
static NSString *const kApiGetAllPath = @"m/v1/user/get/all%@";

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
// Register preferences request
- (NSURLSessionDataTask *)registerPreferencesRequestWithModel:(FLRegisterPreferencesRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    NSString *token = [FLLocalDataManager sharedInstance].sessionToken;
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    
    return [self POST:[NSString stringWithFormat:kApiRegisterPreferencesPath, queryParam] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

// - POST -
// Avatar request
- (NSURLSessionDataTask *)avatarRequestWithData:(NSData *)data success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSData *imageData = data;
    NSString *token = [FLTemporalSessionManager sharedInstance].sessionToken;
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    //NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:[NSString stringWithFormat:kApiRegisterAvatarPath, queryParam] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];   // add image to formData
            
            [formData appendPartWithFormData:[@"sdsd" dataUsingEncoding:NSUTF8StringEncoding] name:@"avatar"];
        }
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

// - GET -
// TimeLine get all users
- (NSURLSessionDataTask *)getAllWithSuccess:(void (^)(FLUsersResponse *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    // Set token as param to url
    NSString *token = [FLLocalDataManager sharedInstance].sessionToken;
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    return [self GET:[NSString stringWithFormat:kApiGetAllPath, queryParam] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLUsersResponse *response = [MTLJSONAdapter modelOfClass:[FLUsersResponse class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error fl_apiErrorWithHttpStatusCode:error.code]);
    }];
}

@end
