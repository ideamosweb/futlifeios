//
//  NSUserDefaults+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSUserDefaults+Utils.h"

@implementation NSUserDefaults (Utils)

static NSString * const kEncryptionKeyKeyChainKey = @"encryptionKey";

+ (NSString *)fl_stringForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (id)fl_objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)fl_setObject:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)fl_dataObjectForKey:(NSString *)key
{
    NSData *dataObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
}

+ (void)fl_setDataObject:(id)value forKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)fl_decryptedStringForKey:(NSString *)key
{
    NSString *encryptionKey = [UICKeyChainStore stringForKey:kEncryptionKeyKeyChainKey];
    NSData *encryptedString = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [FLMiscUtils decryptData:encryptedString withKey:encryptionKey];
}

+ (void)fl_encryptAndSetString:(NSString *)string forKey:(NSString *)key
{
    NSString *encryptionKey = [UICKeyChainStore stringForKey:kEncryptionKeyKeyChainKey];
    if (!encryptionKey)
    {
        encryptionKey = [FLMiscUtils generateGUID];
        [UICKeyChainStore setString:encryptionKey forKey:kEncryptionKeyKeyChainKey];
    }
    NSData *encryptedString = [FLMiscUtils encryptString:string withKey:encryptionKey];
    [[NSUserDefaults standardUserDefaults] setObject:encryptedString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
