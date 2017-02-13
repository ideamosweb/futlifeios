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
static NSString *const kApiRegisterPreferencesPath = @"m/v1/preferences%@";
static NSString *const kApiRegisterAvatarPath = @"m/v1/user/avatar%@";
static NSString *const kApiGamesPath = @"m/v1/games/get";
static NSString *const kApiConsolesPath = @"m/v1/consoles/get";
static NSString *const kApiLoginPath = @"m/v1/login";
static NSString *const kApiGetAllPath = @"m/v1/players/%@%@";

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

- (FLApiError *)processResponseWithError:(NSError *)error
{
    // Issue resolved by:
    // https://github.com/AFNetworking/AFNetworking/issues/2410#issuecomment-95578495
    NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    NSLog(@"Response error: %@", errorResponse);
    NSData *data = [errorResponse dataUsingEncoding:NSUTF8StringEncoding];
    id errorDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSError *errorMtl;
    FLApiModel *response = [MTLJSONAdapter modelOfClass:[FLApiModel class] fromJSONDictionary:(NSDictionary *)errorDict error:&errorMtl];
    
    return [error fl_apiErrorWithHttpStatusCode:error.code response:response];
}

// - POST -
// Register request
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kApiRegisterPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

// - POST -
// Register preferences request
- (NSURLSessionDataTask *)registerPreferencesRequestWithModel:(FLRegisterPreferencesRequestModel *)requestModel success:(void (^)(FLRegisterPreferencesResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];    
    NSString *token = [FLLocalDataManager sharedInstance].sessionToken;
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    
    return [self POST:[NSString stringWithFormat:kApiRegisterPreferencesPath, queryParam] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLRegisterPreferencesResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterPreferencesResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

// - POST -
// Avatar request
- (NSURLSessionUploadTask *)avatarRequestWithImageUrl:(NSURL *)imageUrl imageData:(NSData *)imageData success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    NSURL *baseUrl = [NSURL URLWithString:FLApiBaseUrl()];
    NSString *token = [FLLocalDataManager sharedInstance].sessionToken;
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", baseUrl, [NSString stringWithFormat:kApiRegisterAvatarPath, queryParam]];
    NSDictionary *parameters = @{@"user_id" : [FLLocalDataManager sharedInstance].user.userId, @"avatar" : imageData};
    __weak __typeof(self)weakSelf = self;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            FLApiError *apiError = [strongSelf processResponseWithError:error];
            failure(apiError);
        } else {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            NSError *error;
            FLRegisterResponseModel *response = [MTLJSONAdapter modelOfClass:[FLRegisterResponseModel class] fromJSONDictionary:responseDictionary error:&error];
            success(response);
        }
    }];
    
    [uploadTask resume];
    
    return uploadTask;
}

// - GET -
// Consoles request
- (NSURLSessionDataTask *)consolesRequestWithSuccess:(void (^)(FLConsoleResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    return [self GET:kApiConsolesPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLConsoleResponseModel *response = [MTLJSONAdapter modelOfClass:[FLConsoleResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

// - GET -
// Games request
- (NSURLSessionDataTask *)gamesRequestWithSuccess:(void (^)(FLGameResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    return [self GET:kApiGamesPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLGameResponseModel *response = [MTLJSONAdapter modelOfClass:[FLGameResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

// - POST -
// Login request
- (NSURLSessionDataTask *)loginRequestWithModel:(FLLoginRequestModel *)requestModel success:(void (^)(FLLoginResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:kApiLoginPath parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLLoginResponseModel *response = [MTLJSONAdapter modelOfClass:[FLLoginResponseModel class] fromJSONDictionary:responseDictionary error:&error];
        
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

// - GET -
// TimeLine get all users
- (NSURLSessionDataTask *)getAllWithSuccess:(void (^)(FLUsersResponse *responseModel))success failure:(void (^)(FLApiError *error))failure
{
    __weak __typeof(self)weakSelf = self;
    
    // Set token as param to url
    NSString *token = [FLLocalDataManager sharedInstance].sessionToken;
    NSString *userId = [NSString stringWithFormat:@"%@", [FLLocalDataManager sharedInstance].user.userId];
    NSString *queryParam = [NSString stringWithFormat:kApiTokenQuery, token];
    /* Uncomment for set HTTP Header */
    // [self.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    return [self GET:[NSString stringWithFormat:kApiGetAllPath, userId, queryParam] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        FLUsersResponse *response = [MTLJSONAdapter modelOfClass:[FLUsersResponse class] fromJSONDictionary:responseDictionary error:&error];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLApiError *apiError = [strongSelf processResponseWithError:error];
        failure(apiError);
    }];
}

@end
