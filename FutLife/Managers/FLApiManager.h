//
//  FLApiManager.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLSessionManager.h"
#import "FLRegisterRequestModel.h"
#import "FLRegisterResponseModel.h"

@interface FLApiManager : FLSessionManager

+ (instancetype)sharedInstance;

// Register request
- (NSURLSessionDataTask *)registerRequestWithModel:(FLRegisterRequestModel *)requestModel success:(void (^)(FLRegisterResponseModel *responseModel))success failure:(void (^)(NSError *error))failure;

@end
