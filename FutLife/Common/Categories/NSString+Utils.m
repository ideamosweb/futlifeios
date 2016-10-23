//
//  NSString+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL)fl_isEmpty
{
    return ([[self stringByReplacingOccurrencesOfString:@" " withString:kStringEmpty] length] == 0);
}

- (BOOL)fl_isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self fl_validateUsingRegex:emailRegex];
}

- (BOOL)fl_validateUsingRegex:(NSString *)regex
{
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexTest evaluateWithObject:self];
}

- (BOOL)fl_isNaturalNumber
{
    return [self fl_validateUsingRegex:@"\\d+"];
}

- (BOOL)fl_isNumber
{
    return [self fl_numberValue] != nil;
}

+ (NSString *)fl_replaceSlashesWithDashFromString:(NSString *)string
{
    NSString *newString = [string stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    return newString;
}

- (NSNumber *)fl_numberValue
{
    static dispatch_once_t once;
    static NSNumberFormatter *fmt;
    dispatch_once(&once, ^{
        fmt = [[NSNumberFormatter alloc] init];
        [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
    NSNumber *number = [fmt numberFromString:self];
    return number;
}

- (NSNumber *)fl_numberValueWithDotAsDecimalSeparator
{
    static dispatch_once_t once;
    static NSNumberFormatter *fmt;
    dispatch_once(&once, ^{
        fmt = [[NSNumberFormatter alloc] init];
        [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
        [fmt setDecimalSeparator:@"."];
    });
    
    NSNumber *number = [fmt numberFromString:self];
    return number;
}

- (float)fl_floatValue
{
    return [[self fl_numberValue] floatValue];
}

- (BOOL)fl_isStartsWithACapitalLetter {
    
    unichar firstCharacter = [self characterAtIndex:0];
    return [[NSCharacterSet uppercaseLetterCharacterSet]
            characterIsMember:firstCharacter];
    
}

#pragma mark -

- (NSString *)fl_trimWhitespace {
    
    //    NSMutableString *str = [self mutableCopy];
    //    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    //    return str;
    
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)fl_numberOfWords {
    __block NSUInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByWords|NSStringEnumerationSubstringNotRequired
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              count++;
                          }];
    return count;
}

- (NSString *)fl_reverseString {
    
    //    int len = [self length];
    //
    //    NSMutableString *reversedStr = [NSMutableString stringWithCapacity:len];
    //    while (len--) {
    //        [reversedStr appendFormat:@"%C", [self characterAtIndex:len]];
    //    }
    
    // New way
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,[self length])
                             options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [reversedString appendString:substring];
                          }];
    
    
    return reversedString;
}

- (NSString *)fl_concat:(NSString *)string {
    
    if (!string) {
        return self;
    }
    
    return [NSString stringWithFormat:@"%@%@",self, string];
}

- (BOOL)fl_contains:(NSString *)string {
    
    if (string) {
        NSRange range = [self rangeOfString:string];
        return (range.location != NSNotFound);
        
    }else {
        return NO;
    }
    
}


+ (NSString *)fl_truncateString:(NSString *) string toCharacterCount:(NSUInteger) count {
    
    NSRange range = { 0, MIN(string.length, count) };
    range = [string rangeOfComposedCharacterSequencesForRange: range];
    NSString *trunc = [string substringWithRange: range];
    
    if (trunc.length < string.length) {
        trunc = [trunc stringByAppendingString: @"..."];
    }
    
    return trunc;
    
} // truncateString

#pragma mark - URL Encoding and Decoding
- (NSString *)fl_urlEncode {
    return [self fl_urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)fl_urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    
    NSString *value = @"<url>";
    value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    return value;
}

- (NSString *)fl_urlDecode {
    return [self fl_urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)fl_urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (__bridge CFStringRef)self, CFSTR(""));
}

#pragma mark - Date Format

- (NSDate *)fl_dateFromFormat: (NSString *)formatter {
    
    //    debug(@"dateString %@",dateString);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:formatter];
    
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    return dateFromString;
}

@end
