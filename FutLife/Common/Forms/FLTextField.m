//
//  FLTextField.m
//  FutLife
//
//  Created by Rene Santis on 10/22/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLTextField.h"
#import "FLInputFieldValidation.h"
#import "FLMiscUtils.h"

@interface FLTextField ()

@property (strong, nonatomic) NSMutableArray *fieldValidations;

@property (nonatomic, copy) NSString *textBeforValidation;

@end

@implementation FLTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupTextField];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupTextField];
    }
    return self;
}

- (void)setupTextField
{
    self.fieldValidations = [[NSMutableArray alloc] init];
    self.maxTypeableLengthValidation = NSUIntegerMax;
    self.typeable = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    /* TODO */
    // Set placeholder font.
    // http://stackoverflow.com/a/18994346
    // [self setValue:[UIFont mt_robotoFontOfSize:self.font.pointSize] forKeyPath:@"_placeholderLabel.font"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [FLMiscUtils addBorderColor:self withColor:[UIColor lightGrayColor] withRound:5.0f withStroke:1.0f];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    /* TODO */
    // Set placeholder font.
    // http://stackoverflow.com/a/18994346
    // [self setValue:[UIFont mt_robotoFontOfSize:self.font.pointSize] forKeyPath:@"_placeholderLabel.font"];
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    if (notification.object == self) {
        // Nothing to do
    }
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    if (self.isEditing)
    {
        // If the text field got focus, we want to remove the
        // validation error, as the user might try to fix it.
        self.validationError = NO;
    }
}

// Creates a Min Typeable validation
- (void)setMinTypeableLengthValidation:(NSUInteger)minTypeableLengthValidation
{
    if (minTypeableLengthValidation) {
        FLInputFieldValidation *minTypeableValidation = [FLInputFieldValidation validationMinLength:minTypeableLengthValidation withErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:minTypeableValidation];
    }
}

// Creates a Min Typeable validation
- (void)setMaxTypeableLengthValidation:(NSUInteger)maxTypeableLengthValidation
{
    if (maxTypeableLengthValidation) {
        FLInputFieldValidation *maxTypeableValidation = [FLInputFieldValidation validationMaxLength:maxTypeableLengthValidation withErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:maxTypeableValidation];
    }
}

// Creates a Fixed validation
- (void)setFixedLengthValidation:(NSUInteger)fixedLength
{
    if (fixedLength) {
        FLInputFieldValidation *fixedLengthValidation = [FLInputFieldValidation validationFixedLength:fixedLength withErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:fixedLengthValidation];
    }
}

- (void)setMandatoryValidation:(BOOL)mandatoryValidation
{
    if (mandatoryValidation) {
        FLInputFieldValidation *mandatoryInputValidation = [FLInputFieldValidation validationRequiredWithErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:mandatoryInputValidation];
    }
}

// Creates an email textField
- (void)setEmail:(BOOL)email
{
    self.keyboardType = UIKeyboardTypeEmailAddress;
    if (email) {
        FLInputFieldValidation *emailFieldValidation = [FLInputFieldValidation validationEmailWithErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:emailFieldValidation];
    }
}

// Creates an email no empty textField
- (void)setEmailNoEmptyValidation:(BOOL)emailNoEmptyValidation
{
    self.keyboardType = UIKeyboardTypeEmailAddress;
    if (emailNoEmptyValidation) {
        FLInputFieldValidation *emailFieldValidation = [FLInputFieldValidation validationEmailNoEmptyWithErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:emailFieldValidation];
    }
}

// Creates regex validation
- (void)setRegexValidation:(NSString *)regexValidation
{
    if (regexValidation) {
        FLInputFieldValidation *regexInputValidation = [FLInputFieldValidation validationUsingRegex:regexValidation withErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:regexInputValidation];
    }
}

// Creates an only number textField
- (void)setOnlyNumbers:(BOOL)onlyNumbers
{
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (onlyNumbers) {
        FLInputFieldValidation *onlyNumbersValidation = [FLInputFieldValidation validationOnlyNumbersWithErrorMessageBlock:^NSString *{
            /* TODO */
            return @"";
        }];
        
        [self.fieldValidations addObject:onlyNumbersValidation];
    }
}

- (void)setText:(NSString *)text
{
    self.textBeforValidation = text;
    [super setText:text];
    
}

- (void)addValidation:(FLInputFieldValidation *)validation
{
    ASSERT(validation);
    [self.fieldValidations addObject:validation];
}

- (void)removeAllValidations
{
    [self.fieldValidations removeAllObjects];
}

- (void)showErrorMessage:(NSString *)errorMessage
{
    /* TODO */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.validationError = NO;
    // If there was a text erased because of a validation error.. let's put it back
    if (self.textBeforValidation && ![self.textBeforValidation fl_isEmpty]) {
        self.text = self.textBeforValidation;
        self.textBeforValidation = nil;
    }
    
    return YES;
}

- (NSString *)text
{
    return self.hasValidationError ? self.textBeforValidation : [super text];
    
}

// This method should be called in shouldChangeCharactersInRange delegate method
- (BOOL)shouldChangeTextWithText:(NSString *)textEntered
{
    if (self.validCharacterSet)
    {
        for (int i = 0; i < [textEntered length]; i++)
        {
            unichar c = [textEntered characterAtIndex:i];
            if (![self.validCharacterSet characterIsMember:c])
            {
                return NO;
            }
        }
    }
    return self.typeable ? self.text.length < self.maxTypeableLengthValidation || ([textEntered length] == 0) : NO;
}

#pragma mark - FLValidatable protocol methods
- (NSArray *)validate
{
    NSMutableArray *validationMessages = [[NSMutableArray alloc] init];
    
    for (FLInputFieldValidation *validation in self.fieldValidations) {
        if (validation.validationBlock && !validation.validationBlock(self))
        {
            ASSERT(validation.messageBlock);
            [validationMessages addObject:validation.messageBlock()];
        }
    }
    
    if ([validationMessages count] > 0) {
        self.validationError = YES;
        
        if (!self.textBeforValidation)
        {
            self.textBeforValidation = [super text];
        }
        if (self.isMandatoryValidation) {
            self.text = kStringEmpty;
        }
        
        self.validationMessageLabel.text = [validationMessages fl_firstObject];
    } else {
        self.validationError = NO;
    }
    
    return validationMessages;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
