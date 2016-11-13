//
//  FLApiManager.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLSessionManager.h"
#import "FLApiError.h"

#import "FLRegisterRequestModel.h"
#import "FLRegisterResponseModel.h"

#import "FLGameModel.h"
#import "FLConsoleModel.h"

@interface FLApiManager : FLSessionManager

+ (instancetype)sharedInstance;

// Register request
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Get Consoles
- (NSURLSessionDataTask *)consolesRequestWithSuccess:(void (^)(FLConsoleResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

// Get Games
- (NSURLSessionDataTask *)gamesRequestWithSuccess:(void (^)(FLGameResponseModel *responseModel))success failure:(void (^)(FLApiError *error))failure;

@end
