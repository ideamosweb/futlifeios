//
//  FLInputsFormManager.h
//  FutLife
//
//  Created by Rene Santis on 10/19/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLValidatable.h"
@class FLInputFieldValidation;

@interface FLInputsFormManager : NSObject<FLValidatable>

// Save all the input fields.
@property (nonatomic, strong) NSArray *inputFields;
// The current input field.
@property (nonatomic, weak) UIView *currentInputField;
// The next input field.
@property (nonatomic, weak, readonly) UIControl *nextInputField;
// The previous input field.
@property (nonatomic, weak, readonly) UIControl *previousInputField;
// Validation messages array
@property (nonatomic, strong) NSArray *validationMessages;

// Send the first and last field by completion block for set the scrollView contentSize
- (void)firstAndLastInputFieldsWithCompletion:(void (^)(UIControl *firstInput, UIControl *lastInput))completionBlock;

// Validates the whole form.
- (NSArray *)validate;

// Validates a input field for show an alert error message
- (BOOL)showAlertErrorWithValidationMessages:(UIView *)inputField;

// Returns YES if all validations are met.
- (BOOL)isValid;

@end
