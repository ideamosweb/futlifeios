//
//  FLMiscUtils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLMiscUtils : NSObject

#pragma mark - Get UDID

+ (NSString *)getUUID ;

#pragma mark - Get GUID

+ (NSString *)generateGUID;

#pragma mark - Local Country name and country code

+ (NSDictionary *)getLocalCountryNameAndCode ;

#pragma mark - check for application is running first time or not

+ (BOOL)isFirstRun ;

#pragma mark - Get IP address

+ (NSString *)getIPAddress ;

+ (NSDictionary *)getIPAddresses ;

#pragma mark - GET FREE DISK SPACE

+ (uint64_t)getFreeDiskSpace ;

#pragma mark - Encrypt / Decrypt text

+ (NSData *)encryptString:(NSString *)plaintext withKey:(NSString *)key;
+ (NSString *)decryptData:(NSData *)cipherText withKey:(NSString *)key;

#pragma mark - platform
+ (NSString *)platform;

#pragma mark - Method Swizzle

+ (void)methodSwizzleWithClass:(Class)targetClass originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector;

#pragma mark - Utils views methods

+ (CGRect)screenViewFrame;
+ (void)addBasicShadow:(UIView *)view;
+ (void)addBorder:(UIView *)view;
+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color withRound:(CGFloat)roundSize;
+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color withRound:(CGFloat)roundSize withStroke:(CGFloat)stroke;

#pragma mark - Properties

+ (NSDictionary *)propertiesOfObject:(NSObject *)object;
+ (NSArray *)propertiesOfClass:(Class)class;

#pragma mark - Random number

+ (int)getRandomNumberBetween:(int)from to:(int)to;

#pragma mark - Hash for sha256
+ (NSString *)generateHash256:(NSString *)string;
+ (NSString *)sha256HashFor:(NSString*)input;

@end
