//
//  FLInputFieldValidation.m
//  FutLife
//
//  Created by Rene Santis on 10/20/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLInputFieldValidation.h"
#import "FLTextField.h"

@implementation FLInputFieldValidation

+ (instancetype)validationRequiredWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        if (!controlText || [controlText fl_isEmpty])
        {
            return NO;
        }
        return YES;
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationMinLength:(NSUInteger)min withErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        if ([controlText length] < min)
        {
            return NO;
        }
        return YES;
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationMaxLength:(NSUInteger)max withErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        if ([controlText length] > max)
        {
            return NO;
        }
        return YES;
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationFixedLength:(NSUInteger)length withErrorMessageBlock:(NSString * (^)())messageBlock
{
    
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        
        return ([controlText length] == length);
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

//+ (instancetype)validationPhoneNumberWithErrorMessageBlock:(NSString * (^)())messageBlock
//{
//    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
//    newValidation.validationBlock = ^BOOL (UIView *control) {
//        NSString *controlText = [self textForControl:control];
//        
//        return ([controlText mt_isValidPhoneNumber]);
//    };
//    newValidation.messageBlock = messageBlock;
//    
//    return newValidation;
//}

//+ (instancetype)validationContactWithErrorMessageBlock:(NSString * (^)())messageBlock
//{
//    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
//    newValidation.validationBlock = ^BOOL (UIView *control) {
//        NSString *controlText = [self textForControl:control];
//        
//        BOOL selectedContact = NO;
//        if ([control isKindOfClass:[MTAutocompleteTextField class]])
//        {
//            MTAutocompleteTextField *autocompleteTextfield = (MTAutocompleteTextField *)control;
//            selectedContact = (autocompleteTextfield.selectedDataSourceObject != nil);
//        }
//        
//        return [controlText mt_isValidPhoneNumber] || selectedContact;
//    };
//    newValidation.messageBlock = messageBlock;
//    
//    return newValidation;
//}

+ (instancetype)validationSameTextAsOtherControl:(UIControl *)otherControl withErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        NSString *otherControlText = [self textForControl:otherControl];
        
        return [controlText isEqualToString:otherControlText];
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationEmailWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        return ([controlText fl_isValidEmail] || [controlText fl_isEmpty]);
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationEmailNoEmptyWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        if (![controlText fl_isEmpty]) {
            if ([controlText fl_isValidEmail]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return YES;
        }
        
        //return ([controlText mt_isValidEmail] && ![controlText mt_isEmpty]);
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationUsingRegex:(NSString *)regex withErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        return [controlText fl_validateUsingRegex:regex];
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationOnlyDigitsWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        return [controlText fl_isNaturalNumber];
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationOnlyNumbersWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        
        return [controlText fl_isNumber];
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (instancetype)validationOnlyNumbersAndGreaterThanZeroWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        NSNumber *value = [[NSNumber alloc] initWithLongLong:controlText.longLongValue];
        
        return value && ([value floatValue] > 0.0f);
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

+ (NSString *)textForControl:(UIView *)control
{
    NSString *controlText = nil;
    if ([control isKindOfClass:[FLTextField class]])
    {
        controlText = ((FLTextField *)control).text;
    }
    else if ([control isKindOfClass:[UITextField class]])
    {
        controlText = ((UITextField *)control).text;
    }
    else if ([control isKindOfClass:[UITextView class]])
    {
        controlText = ((UITextView *)control).text;
    }
    
    return controlText;
}

//+ (instancetype)validationConsecutiveNumbersWithErrorMessageBlock:(NSString * (^)())messageBlock
//{    
//    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
//    newValidation.validationBlock = ^BOOL (UIView *control) {
//        NSString *controlText = [self textForControl:control];
//        BOOL isvalid = [MTMiscUtils validateNewPin:controlText lengthMin:controlText.length];
//        
//        return isvalid;
//    };
//    newValidation.messageBlock = messageBlock;
//    
//    return newValidation;
//}

+ (instancetype)validationFromServiceWithErrorMessageBlock:(NSString * (^)())messageBlock
{
    FLInputFieldValidation *newValidation = [[FLInputFieldValidation alloc] init];
    newValidation.validationBlock = ^BOOL (UIView *control) {
        NSString *controlText = [self textForControl:control];
        if (!controlText || [controlText fl_isEmpty])
        {
            return NO;
        }
        return YES;
    };
    newValidation.messageBlock = messageBlock;
    
    return newValidation;
}

@end
