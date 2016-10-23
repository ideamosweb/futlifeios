//
//  FLInputFieldValidation.h
//  FutLife
//
//  Created by Rene Santis on 10/20/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, FLInpuntFieldEnumValidation)
{
    FLValidationRequired = 1,
    FLValidationMinLength = 2,
    FLValidationMaxLength = 3,
    FLValidationFixedLength = 4,
    FLValidationSameTextAsOtherControl = 5,
    FLValidationEmail = 6,
    FLValidationUsingRegex = 7,
    FLValidationOnlyDigits = 8,
    FLValidationOnlyNumbers = 9,
    FLValidationPhoneNumber = 10,
    FLValidationContact = 11,
    FLValidationOnlyNumbersAndGreaterThanZero = 12
};

@interface FLInputFieldValidation : NSObject

// The message associated with the validation.
@property (nonatomic, copy) NSString * (^messageBlock)();

// The validation block. It should return YES if the validation
// passes, otherwise NO.
@property (nonatomic, copy) BOOL (^validationBlock)(UIView *control);

// Creates a "required" validation with a message.
+ (instancetype)validationRequiredWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "minimum length" validation with a message.
+ (instancetype)validationMinLength:(NSUInteger)min withErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "maximum length" validation with a message.
+ (instancetype)validationMaxLength:(NSUInteger)max withErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "fixed length" validation with a message.
+ (instancetype)validationFixedLength:(NSUInteger)length withErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "same text as other control" validation with a message.
+ (instancetype)validationSameTextAsOtherControl:(UIControl *)otherControl withErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "valid email" validation with a message.
+ (instancetype)validationEmailWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "valid email" no empty validation with a message.
+ (instancetype)validationEmailNoEmptyWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a validation using a specific regex and a message;
+ (instancetype)validationUsingRegex:(NSString *)regex withErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates "numbers only" validation with a message;
+ (instancetype)validationOnlyDigitsWithErrorMessageBlock:(NSString * (^)())messageBlock;
+ (instancetype)validationOnlyNumbersWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "phone number" validation. Checks national and international format
// + (instancetype)validationPhoneNumberWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Validates if a contact of a valid number was entered
// + (instancetype)validationContactWithErrorMessageBlock:(NSString * (^)())messageBlock;
+ (instancetype)validationOnlyNumbersAndGreaterThanZeroWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "not consecutive numbers" validation with a message
// + (instancetype)validationConsecutiveNumbersWithErrorMessageBlock:(NSString * (^)())messageBlock;
// Creates a "is a valid field from service response" validation with a message
+ (instancetype)validationFromServiceWithErrorMessageBlock:(NSString * (^)())messageBlock;

@end
