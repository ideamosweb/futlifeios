//
//  NSString+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kStringEmpty = @"";

@interface NSString (Utils)

- (BOOL)fl_isEmpty;
- (BOOL)fl_isValidEmail;
- (BOOL)fl_validateUsingRegex:(NSString *)regex;
- (BOOL)fl_isNaturalNumber;
- (BOOL)fl_isNumber;
+ (NSString *)fl_replaceSlashesWithDashFromString:(NSString *)string;

- (NSNumber *)fl_numberValue;
- (NSNumber *)fl_numberValueWithDotAsDecimalSeparator;
- (float)fl_floatValue;

- (BOOL)fl_isStartsWithACapitalLetter;
- (NSString *)fl_trimWhitespace;

- (NSUInteger)fl_numberOfWords;

- (NSString *)fl_reverseString;
- (NSString *)fl_concat:(NSString *)string;
- (BOOL)fl_contains:(NSString *)string;
+ (NSString *)fl_truncateString:(NSString *)string toCharacterCount:(NSUInteger)count;

- (CGSize)fl_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

#pragma mark - URL Encoding and Decoding

- (NSString *)fl_urlEncode;
- (NSString *)fl_urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)fl_urlDecode;
- (NSString *)fl_urlDecodeUsingEncoding:(NSStringEncoding)encoding;

#pragma mark - Date Format

- (NSDate *)fl_dateFromFormat:(NSString *)formatter;

@end
