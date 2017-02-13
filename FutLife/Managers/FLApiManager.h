//
//  FLApiManager.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLSessionManager.h"
#import "FLApiError.h"
#import "FLApiModel.h"

#import "FLRegisterRequestModel.h"
#import "FLRegisterResponseModel.h"

#import "FLUserModel.h"
#import "FLGameModel.h"
#import "FLConsoleModel.h"

#import "FLLoginRequestModel.h"
#import "FLLoginResponseModel.h"

@interface FLApiManager : FLSessionManager

+ (instancetype)sharedInstance;

// Register request
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Register preferences request
- (NSURLSessionDataTask *)registerPreferencesRequestWithModel:(FLRegisterPreferencesRequestModel *)requestModel success:(void (^)(FLRegisterPreferencesResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Avatar request
- (NSURLSessionUploadTask *)avatarRequestWithImageUrl:(NSURL *)imageUrl imageData:(NSData *)imageData success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Get Consoles
- (NSURLSessionDataTask *)consolesRequestWithSuccess:(void (^)(FLConsoleResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Get Games
- (NSURLSessionDataTask *)gamesRequestWithSuccess:(void (^)(FLGameResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Login request
- (NSURLSessionDataTask *)loginRequestWithModel:(FLLoginRequestModel *)requestModel success:(void (^)(FLLoginResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// TimeLine get all users request
- (NSURLSessionDataTask *)getAllWithSuccess:(void (^)(FLUsersResponse *responseModel))success failure:(void (^)(FLApiError *error))failure;

@end
