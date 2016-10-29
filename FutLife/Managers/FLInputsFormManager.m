//
//  FLInputsFormManager.m
//  FutLife
//
//  Created by Rene Santis on 10/19/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLInputsFormManager.h"
#import "FLToolbar.h"

// Properties to be observed in UITextField and UITextView instances.
static NSString *const kFormManagerEnabledTexFieldKeyPath = @"enabled";
static NSString *const kFormManagerEditableTextViewKeyPath = @"editable";

@interface FLInputsFormManager ()

@end

@implementation FLInputsFormManager

- (id)init
{
    self = [super init];
    if (self) {
        // ...
    }
    return self;
    
}

- (FLToolbar *)inputFieldAccessoryToolBar:(UIControl *)inputField
{
    return (FLToolbar *)inputField.inputAccessoryView;
}

// Gets the first enabled input within the form.
- (UIControl *)firstEnabledInput
{
    for (NSUInteger i = 0; i < [self.inputFields count]; i++)
    {
        UIControl *inputField = [self.inputFields fl_objectAtIndex:i];
        if ((([inputField isKindOfClass:[UITextField class]] && inputField.enabled)) || ([inputField isKindOfClass:[UITextView class]] && ((UITextView *)inputField).editable))
        {
            return inputField;
        }
    }
    return nil;
}

// Gets the last enabled input within the form.
- (UIControl *)lastEnabledInput
{
    for (NSUInteger i = [self.inputFields count] - 1; i != -1; i--)
    {
        UIControl *inputField = [self.inputFields fl_objectAtIndex:i];
        if ((([inputField isKindOfClass:[UITextField class]] && inputField.enabled)) || ([inputField isKindOfClass:[UITextView class]] && ((UITextView *)inputField).editable))
        {
            return inputField;
        }
    }
    return nil;
}

// Validates a particular input field.
// Returns an empty non-nil array if there
// are no validation errors.
- (NSArray *)validateInputField:(UIView *)inputField
{
    if ([inputField conformsToProtocol:@protocol(FLValidatable)])
    {
        return [((id <FLValidatable>)inputField)validate];
    }
    
    return [[NSMutableArray alloc] init];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (UIControl *inputField in self.inputFields)
    {
        FLToolbar *inputAccessoryView = [self inputFieldAccessoryToolBar:inputField];
        inputAccessoryView.previousEnabled = (inputField != [self firstEnabledInput]);
        inputAccessoryView.nextEnabled = (inputField != [self lastEnabledInput]);
    }
    
    // Move to the next input field (if any), if the current input field
    // is getting disabled.
    if (object == self.currentInputField)
    {
        if (([self.currentInputField isKindOfClass:[UITextField class]] && !((UITextField *)self.currentInputField).enabled) || ([self.currentInputField isKindOfClass:[UITextView class]] && !((UITextView *)self.currentInputField).editable))
        {
            self.currentInputField = self.nextInputField;
            if ([object isFirstResponder])
            {
                [self.currentInputField becomeFirstResponder];
            }
        }
    }
}

- (void)dealloc
{
    // Remove all the observers.
    for (UIControl *inputField in self.inputFields)
    {
        if ([inputField isKindOfClass:[UITextField class]] || [inputField isKindOfClass:[UITextView class]])
        {
            if ([inputField isKindOfClass:[UITextField class]])
            {
                [inputField removeObserver:self forKeyPath:kFormManagerEnabledTexFieldKeyPath];
            }
            else if ([inputField isKindOfClass:[UITextView class]])
            {
                [inputField removeObserver:self forKeyPath:kFormManagerEditableTextViewKeyPath];
            }
        }
    }
}

#pragma mark - FLInputAccessoryToolBarDelegate methods

- (void)onInputAccessorySegmentedControlValueChanged:(UISegmentedControl *)sender
{
    self.currentInputField = ([sender selectedSegmentIndex] == 0) ? self.previousInputField : self.nextInputField;
    [self.currentInputField becomeFirstResponder];
}

- (void)onInputAccessoryDoneButtonTouched
{
    // Validate the current input field before the keyboard is hidden.
    // [self validateInputField:self.currentInputField];
    [self.currentInputField resignFirstResponder];
}

#pragma mark - Public Methods

- (void)setInputFields:(NSArray *)inputFields
{
    // Remove the observers from the old input fields.
    if (self.inputFields)
    {
        for (UIControl *inputField in self.inputFields)
        {
            if ([inputField isKindOfClass:[UITextField class]] || [inputField isKindOfClass:[UITextView class]])
            {
                if ([inputField isKindOfClass:[UITextField class]])
                {
                    [inputField removeObserver:self forKeyPath:kFormManagerEnabledTexFieldKeyPath];
                }
                else if ([inputField isKindOfClass:[UITextView class]])
                {
                    [inputField removeObserver:self forKeyPath:kFormManagerEditableTextViewKeyPath];
                }
            }
        }
    }
    
    // Refresh the input fields.
    _inputFields = inputFields;
    
    // Add the observers over the new input fields.
    for (UIControl *inputField in inputFields)
    {
        if ([inputField isKindOfClass:[UITextField class]] || [inputField isKindOfClass:[UITextView class]])
        {
            BOOL previousEnabled = (inputField != [self firstEnabledInput]);
            BOOL nextEnabled = (inputField != [self lastEnabledInput]);
            FLToolbar *inputAccessoryView = [[FLToolbar alloc] initWithDelegate:(id <FLToolBarDelegate, UIToolbarDelegate>)self previousEnabled:previousEnabled nextEnabled:nextEnabled];
            [(id)inputField setInputAccessoryView : inputAccessoryView];
            if ([inputField isKindOfClass:[UITextField class]])
            {
                [inputField addObserver:self forKeyPath:kFormManagerEnabledTexFieldKeyPath options:NSKeyValueObservingOptionNew context:NULL];
            }
            else if ([inputField isKindOfClass:[UITextView class]])
            {
                [inputField addObserver:self forKeyPath:kFormManagerEditableTextViewKeyPath options:NSKeyValueObservingOptionNew context:NULL];
            }
        }
    }
    
    [self.currentInputField reloadInputViews];
}

// Send the first and last field by completion block for set the scrollView contentSize
- (void)firstAndLastInputFieldsWithCompletion:(void (^)(UIControl *firstInput, UIControl *lastInput))completionBlock
{
    if ([self.inputFields count]) {
        UIControl *firstInputField = [self.inputFields firstObject];
        UIControl *lastInputField = [self.inputFields lastObject];
        
        if (completionBlock) {
            completionBlock(firstInputField, lastInputField);
        }
    }
}

// Gets the next input field, taking into account disabled input fields.
- (UIControl *)nextInputField
{
    NSUInteger currentIndex = [self.inputFields indexOfObject:self.currentInputField];
    for (NSUInteger i = (currentIndex + 1) % [self.inputFields count]; i != currentIndex; i = (i + 1) % [self.inputFields count])
    {
        UIControl *inputField = [self.inputFields fl_objectAtIndex:i];
        if ((([inputField isKindOfClass:[UITextField class]] && inputField.enabled)) || ([inputField isKindOfClass:[UITextView class]] && ((UITextView *)inputField).editable))
        {
            return inputField;
        }
    }
    return nil;
}

// Gets the previous input field, taking into account disabled input fields.
- (UIControl *)previousInputField
{
    NSUInteger currentIndex = [self.inputFields indexOfObject:self.currentInputField];
    for (NSUInteger i = (currentIndex - 1) % [self.inputFields count]; i != currentIndex; i = (i - 1) % [self.inputFields count])
    {
        UIControl *inputField = [self.inputFields fl_objectAtIndex:i];
        if ((([inputField isKindOfClass:[UITextField class]] && inputField.enabled)) || ([inputField isKindOfClass:[UITextView class]] && ((UITextView *)inputField).editable))
        {
            return inputField;
        }
    }
    return nil;
}

// Sets the current input field.
- (void)setCurrentInputField:(UIView *)currentInputField
{
    // Validate the previous input field before moving to a new one.
    //[self validateInputField:self.currentInputField];
    _currentInputField = currentInputField;
}

// Validate and return the error messages for Alert view
- (BOOL)showAlertErrorWithValidationMessages:(UIView *)inputField
{
    if ([inputField conformsToProtocol:@protocol(FLValidatable)])
    {
//        if ([((id < FLValidatable >)inputField) showAlertErrorMessage]) {
//            self.validationMessages = [self validateInputField:inputField];
//            if (self.validationMessages.count > 0) {
//                return YES;
//            }
//        }
    }
    
    return NO;
}

- (void)validateFormWithSuccess:(void (^)())successBlock failureBlock:(void (^)(FLError *error))failureBlock
{
    if ([[self validate] count] == 0) {
        if (successBlock) {
            successBlock();
        }
    } else {
        if (failureBlock) {
            NSString *errorMessage = [[self validate] fl_firstObject];
            FLError *errorInstance = [[FLError alloc] initWithErrorCode:0 errorMessage:errorMessage];
            failureBlock(errorInstance);
        }
    }
}

// Validate the whole form.
- (NSArray *)validate
{
    NSMutableArray *validationMessages = [[NSMutableArray alloc] init];
    [self.currentInputField resignFirstResponder];
    // Validate all the input fields.
    for (UIView *inputField in self.inputFields) {
        NSArray *inputFieldValidationMessages = [self validateInputField:inputField];
        ASSERT(inputFieldValidationMessages);
        [validationMessages addObjectsFromArray:inputFieldValidationMessages];
    }
    
    self.validationMessages = validationMessages;
    
    return validationMessages;
}

- (BOOL)isValid
{
    return ([[self validate] count] == 0);
}

@end
