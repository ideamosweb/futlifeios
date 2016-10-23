//
//  FLMiscUtils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLMiscUtils.h"
#include <sys/sysctl.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation FLMiscUtils

+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

#pragma mark - Public Methods

#pragma mark - Get UDID

+ (NSString *)getUUID {
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    if(theUUID) CFRelease(theUUID);
    return (__bridge NSString*)string;
}

#pragma mark - Get GUID
+ (NSString *)generateGUID
{
    NSMutableString *guid = [[NSMutableString alloc] initWithCapacity:kGUIDLength];
    for (NSUInteger i = 0; i < kGUIDLength; i++)
    {
        NSInteger maxNumber = [kGUIDAlphabet length];
        NSUInteger randNum = arc4random() % maxNumber;
        [guid appendFormat:@"%c", [kGUIDAlphabet characterAtIndex:randNum]];
    }
    
    return guid;
}

#pragma mark - Local Country name and country code

+ (NSDictionary *)getLocalCountryNameAndCode {
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
    NSString *countryName = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
    
    //NOTE: On iOS 8.1 simulator countryName returns nil
    if (!countryName) {
        countryName = @"United States";
        countryCode = @"US";
    }
    
    return @{@"name":countryName,@"code":countryCode};
}

#pragma mark - check for application is running first time or not
+ (BOOL)isFirstRun {
    
#define USER_DEFAULTS_FIRST_RUN @"isFirstRun"
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:USER_DEFAULTS_FIRST_RUN]) {
        return NO;
    }
    
    [defaults setObject:[NSDate date] forKey:USER_DEFAULTS_FIRST_RUN];
    [defaults synchronize];
    
    return YES;
}

#pragma mark - Get IP address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    
    return address;
    
}

+ (NSDictionary *)getIPAddresses {
    
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
    
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - GET FREE DISK SPACE
+ (uint64_t)getFreeDiskSpace {
    
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

#pragma mark - Encrypt / Decrypt text
+ (NSData *)encryptString:(NSString *)plainText withKey:(NSString *)key
{
    return [[plainText dataUsingEncoding:NSUTF8StringEncoding] mt_AES256EncryptWithKey:key];
}

+ (NSString *)decryptData:(NSData *)cipherText withKey:(NSString *)key
{
    return [[NSString alloc] initWithData:[cipherText mt_AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
}

#pragma mark - platform
+ (NSString *)platform
{
    return [self getSysInfoByName:"hw.machine"];
}

#pragma mark - Method Swizzle
+ (void)methodSwizzleWithClass:(Class)targetClass originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector
{
    Method origMethod = class_getInstanceMethod(targetClass, originalSelector);
    Method newMethod = class_getInstanceMethod(targetClass, newSelector);
    if (class_addMethod(targetClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(targetClass, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

#pragma mark - Utils views methods
+ (CGRect)screenViewFrame
{
    CGRect viewFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    
    return viewFrame;
}

+ (NSDictionary *)propertiesOfObject:(NSObject *)object
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        const char *cname = property_getName(properties[i]);
        NSString *name = [NSString stringWithCString:cname encoding:NSStringEncodingConversionAllowLossy];
        NSString *value = [[object valueForKey:name] description] ?: @"(nil)";
        [dictionary setObject:value forKey:name];
    }
    return dictionary;
}

+ (void)addBasicShadow:(UIView *) view
{
    view.layer.shadowOffset = CGSizeMake(5, 5);
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 0.3;
    view.clipsToBounds=YES;
}

+ (void)addBorder:(UIView *) view
{
    [view.layer setCornerRadius:5.0f];
    view.clipsToBounds=YES;
}

+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color withRound:(CGFloat)roundSize
{
    return [self addBorderColor:view withColor:color withRound:roundSize withStroke:3.0f];
}

+ (void)addBorderColor:(UIView *)view withColor:(UIColor *)color withRound:(CGFloat)roundSize withStroke:(CGFloat)stroke
{
    [view.layer setCornerRadius:roundSize];
    [view.layer setBorderColor:color.CGColor];
    [view.layer setBorderWidth:stroke];
    view.clipsToBounds=YES;
}

#pragma mark - Properties
+ (NSArray *)propertiesOfClass:(Class)class
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        const char *cname = property_getName(properties[i]);
        NSString *name = [NSString stringWithCString:cname encoding:NSStringEncodingConversionAllowLossy];
        [propertiesArray addObject:name];
    }
    return propertiesArray;
}

#pragma mark - Random number
+ (int)getRandomNumberBetween:(int)from to:(int)to
{
    return (int)from + arc4random() % (to-from+1);
}

+ (NSString *)generateHash256:(NSString *)string
{
    const char *s=[@"123456" cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

#pragma mark - Hash for sha256
+ (NSString *)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}



@end
