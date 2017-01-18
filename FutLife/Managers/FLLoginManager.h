//
//  FLLoginManager.h
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLLoginRequestModel.h"
#import "FLLoginResponseModel.h"

@interface FLLoginManager : NSObject

+ (instancetype)sharedInstance;

- (void)loginWithRequest:(FLLoginRequestModel *)request successBlock:(void (^)())successBlock failure:(void (^)(FLApiError *error))failure;
- (void)logOut;

@end
