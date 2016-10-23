//
//  FLTextField.h
//  FutLife
//
//  Created by Rene Santis on 10/22/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLValidatable.h"
@class FLInputFieldValidation;

@interface FLTextField : UITextField<FLValidatable>

// Gets whether the text field has a validation error or not.
@property (nonatomic, assign, getter = hasValidationError) BOOL validationError;
// Only characters form this character set will be typed
@property (nonatomic, strong) NSCharacterSet *validCharacterSet;
// Only maxTypeableLength characters will be typed
@property (nonatomic, assign) NSUInteger maxTypeableLengthValidation;
@property (nonatomic, assign) NSUInteger minTypeableLengthValidation;
@property (nonatomic, assign, getter = isTypeable) BOOL typeable;
// Fixed length validation
@property (nonatomic, assign) NSUInteger fixedLengthValidation;
// Validation message label.
@property (nonatomic, strong) UILabel *validationMessageLabel;
// Validation is mandatory
@property (nonatomic, assign, getter = isMandatoryValidation) BOOL mandatoryValidation;
// Creates an email textField
@property (assign, nonatomic, getter=isEmail) BOOL email;
// Creates an email no empty validation
@property (assign, nonatomic, getter=isEmailNoEmptyValidation) BOOL emailNoEmptyValidation;
// Validation regex
@property (copy, nonatomic) NSString *regexValidation;
// Creates an only numbers textfield
@property (assign, nonatomic, getter=isOnlyNumbers) BOOL onlyNumbers;

// This method should be called in shouldChangeCharactersInRange delegate method
- (BOOL)shouldChangeTextWithText:(NSString *)textEntered;

// Adds a validation for this input field.
- (void)addValidation:(FLInputFieldValidation *)validation;

- (void)removeAllValidations;

- (void)showErrorMessage:(NSString *)errorMessage;

// Validates the text field.
- (NSArray *)validate;

@end
