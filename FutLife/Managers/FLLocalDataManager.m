//
//  FLLocalDataManager.m
//  FutLife
//
//  Created by Rene Santis on 10/27/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLocalDataManager.h"

static NSString *const kRegisteredUser = @"RegisteredUser";
static NSString *const kUser = @"User";
static NSString *const kUserAvatar = @"Avatar";

@implementation FLLocalDataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLLocalDataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLLocalDataManager alloc] initLocalDataManager];
    });
    return sharedInstance;
}

- (id)init
{
    @throw [NSException fl_singletonExceptionWithClass:[self class]];
}

- (id)initLocalDataManager
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)setRegisteredUser:(BOOL)registeredUser
{
    [NSUserDefaults fl_setObject:[NSNumber numberWithBool:registeredUser] forKey:kRegisteredUser];
}

- (BOOL)registeredUser
{
    return [[NSUserDefaults fl_objectForKey:kRegisteredUser] boolValue];
}

- (void)setUser:(FLUserModel *)user
{
    [NSUserDefaults fl_setDataObject:user forKey:kUser];
}

- (FLUserModel *)user
{
    return [NSUserDefaults fl_dataObjectForKey:kUser];
}

- (void)setAvatar:(UIImage *)avatar
{
    [NSUserDefaults fl_setDataObject:avatar forKey:kUserAvatar];
}

- (UIImage *)avatar
{
    return [NSUserDefaults fl_dataObjectForKey:kUserAvatar];
}

@end
