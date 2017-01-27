//
//  FLLoginManager.m
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLoginManager.h"
#import "FLLocalDataManager.h"

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
        [FLLocalDataManager sharedInstance].user = responseModel.data;
        [FLLocalDataManager sharedInstance].logged = true;
        [FLLocalDataManager sharedInstance].sessionToken = responseModel.token;
        successBlock();
    } failure:^(FLApiError *error) {
        failure(error);
    }];    
}

- (void)logOut
{
    // Clean all local persistant flags
    [FLLocalDataManager sharedInstance].registeredUser = false;
    [FLLocalDataManager sharedInstance].chosenGame = false;
    [FLLocalDataManager sharedInstance].chosenConsole = false;
    [FLLocalDataManager sharedInstance].completedRegister = false;
    [FLLocalDataManager sharedInstance].logged = false;
    [FLLocalDataManager sharedInstance].sessionToken = false;
    
    [FLTemporalSessionManager sharedInstance].logOut = true;
    
    [[FLAppDelegate sharedInstance] openStartUp];
}

@end
