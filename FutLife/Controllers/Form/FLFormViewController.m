//
//  FLFormViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLFormViewController.h"

@interface FLFormViewController ()

@end

@implementation FLFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creates the form manager.
    self.inputsFormManager = [[FLInputsFormManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Register observer keyboard notifications
    [self registerForKeyboardNotifications];
    
    // Gets the first and last inputs for set the initial scrollView contentSize
    [self.inputsFormManager firstAndLastInputFieldsWithCompletion:^(UIControl *firstInput, UIControl *lastInput) {
        CGFloat maxY = CGRectGetMaxY([self.formScrollView convertRect:firstInput.frame fromView:firstInput.superview]);
        CGFloat minY = CGRectGetMinY([self.formScrollView convertRect:lastInput.frame fromView:lastInput.superview]);
        
        self.formScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.formScrollView.frame), minY + maxY);
    }];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc {
    // Remove observer keyboard notifications
    [self unregisterForKeyboardNotifications];
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification *)notification
{
    // In this method the scrollView adjust from the selected field
    // animating the scroll and showing keyboard
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.formScrollView.contentInset = contentInsets;
    self.formScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect currentInputFrame = self.inputsFormManager.currentInputField.frame;
    UIView *currentInputSuperView = self.inputsFormManager.currentInputField.superview;
    ASSERT_CLASS_OR_NIL(currentInputSuperView, UIView);
    
    // Get the frame of the input field in the scroll view.
    CGRect inputFieldRect = [self.formScrollView convertRect:currentInputFrame fromView:currentInputSuperView];
    
    // UIControl *inputControl = (UIControl *)self.inputsFormManager.currentInputField;
    // CGFloat visibleHeight = self.formScrollView.bounds.size.height - keyboardSize.height - inputControl.frame.size.height;
    CGFloat scrollPointY = CGRectGetMinY(inputFieldRect) - kFormTopScrollPadding;
    
    if (scrollPointY > 0.0f) {
        CGPoint scrollPoint = CGPointMake(0.0f, scrollPointY);
        
        __weak FLFormViewController *weakSelf = self;
        
        if ([animationDuration compare:@0] == NSOrderedSame) {
            animationDuration = @(kDefaultAnimationDuration);
        }
        
        [UIView animateWithDuration:[animationDuration floatValue] delay:0.0 options:[animationCurve intValue] animations: ^{
            [weakSelf.formScrollView setContentOffset:scrollPoint animated:NO];
        } completion: ^(BOOL finished) {
            // Prevent scrolling when editing the form.
            weakSelf.formScrollView.scrollEnabled = NO;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    // In this method, we restore the scroll view offset.
    
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    __weak FLFormViewController *weakSelf = self;
    
    [UIView animateWithDuration:[animationDuration floatValue] delay:0.0 options:[animationCurve intValue] animations: ^{
        weakSelf.formScrollView.contentInset = UIEdgeInsetsZero;
        weakSelf.formScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    } completion: ^(BOOL finished) {
        weakSelf.formScrollView.scrollEnabled = YES;
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered
{
    if ([textField isKindOfClass:[FLTextField class]])
    {
        return [((FLTextField *)textField)shouldChangeTextWithText : textEntered];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIResponder *nextResponder = self.inputsFormManager.nextInputField;
    
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
        return NO;
    } else {
        [textField resignFirstResponder];
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // In case the input field is not within the form, we don't want to let the user edit it.
    // Example: when the field is hidden.
    return [self.inputsFormManager.inputFields containsObject:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Let the input field manager know what text field is the one with focus.
    self.inputsFormManager.currentInputField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.inputsFormManager.currentInputField = nil;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // In case the input field is not within the form, we don't want to let the user edit it.
    // Example: when the field is hidden.
    BOOL shouldBeginEditing = [self.inputsFormManager.inputFields containsObject:textView];
    
    if (shouldBeginEditing) {
        // Let the input field manager know what text view is the one with focus.
        // We wan to do this now, and not in textViewDidBeginEditing:, becasue that
        // method will fire AFTER the keyboardWillBeShown notification
        self.inputsFormManager.currentInputField = textView;
    }
    
    return shouldBeginEditing;
}


@end
