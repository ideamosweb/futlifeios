//
//  FLLoginManager.m
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLoginManager.h"

@implementation FLLoginManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLLoginManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLLoginManager alloc] initLoginManager];
    });
    return sharedInstance;
}

- (id)init
{
    @throw [NSException fl_singletonExceptionWithClass:[self class]];
}

- (id)initLoginManager
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loginWithRequest:(FLLoginRequestModel *)request successBlock:(void (^)())successBlock failure:(void (^)(FLApiError *error))failure
{
    [[FLApiManager sharedInstance] loginRequestWithModel:request success:^(FLLoginResponseModel *responseModel) {
        successBlock();
    } failure:^(FLApiError *error) {
        failure(error);
    }];    
}

- (void)logOut
{
    
}

@end
