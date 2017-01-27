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
static NSString *const kChosenConsole = @"ChosenConsole";
static NSString *const kChosenGame = @"ChosenGame";
static NSString *const kCompletedRegister = @"CompletedRegister";
static NSString *const kLogged = @"Logged";
static NSString *const kConsoles = @"Consoles";
static NSString *const kGames = @"Games";
static NSString *const kSessionToken = @"SessionToken";

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

- (void)setChosenConsole:(BOOL)chosenConsole
{
    [NSUserDefaults fl_setObject:[NSNumber numberWithBool:chosenConsole] forKey:kChosenConsole];
}

- (BOOL)chosenConsole
{
    return [[NSUserDefaults fl_objectForKey:kChosenConsole] boolValue];
}

- (void)setChosenGame:(BOOL)chosenGame
{
    [NSUserDefaults fl_setObject:[NSNumber numberWithBool:chosenGame] forKey:kChosenGame];
}

- (BOOL)chosenGame
{
    return [[NSUserDefaults fl_objectForKey:kChosenGame] boolValue];
}

- (void)setCompletedRegister:(BOOL)completedRegister
{
    [NSUserDefaults fl_setObject:[NSNumber numberWithBool:completedRegister] forKey:kCompletedRegister];
}

- (BOOL)completedRegister
{
    return [[NSUserDefaults fl_objectForKey:kCompletedRegister] boolValue];
}

- (void)setLogged:(BOOL)logged
{
    [NSUserDefaults fl_setObject:[NSNumber numberWithBool:logged] forKey:kLogged];
}

- (BOOL)logged
{
    return [[NSUserDefaults fl_objectForKey:kLogged] boolValue];
}

- (NSArray *)consoles
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kConsoles];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

- (void)setConsoles:(NSArray *)consoles
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:consoles];
    [NSUserDefaults fl_setObject:encodedObject forKey:kConsoles];
}

- (NSArray *)games
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kGames];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

- (void)setGames:(NSArray *)games
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:games];
    [NSUserDefaults fl_setObject:encodedObject forKey:kGames];
}

- (NSString *)sessionToken
{
    NSString *token = [NSUserDefaults fl_decryptedStringForKey:kSessionToken];
    return [token fl_isEmpty] ? nil : token;
}

- (void)setSessionToken:(NSString *)sessionToken
{
    [NSUserDefaults fl_encryptAndSetString:sessionToken forKey:kSessionToken];
}

@end
