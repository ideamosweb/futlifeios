//
//  FLAlertView.h
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <FXBlurView/FXBlurView.h>
#import "FLViewController.h"

@protocol FLAlertViewProtocol <NSObject>

- (void)onSelectConsoleSwitch:(id)sender;

@end

@interface FLAlertView : FXBlurView

// FLAlertView delegate for some cases (if needed)
@property (assign, nonatomic) id<FLAlertViewProtocol> delegate;

// Creates an alert view with a custom content view inside
// with buttons and custom inputs fields
- (id)initWithContentView:(UIView *)contentView buttonsInContentView:(NSArray *)buttons inputFieldsInContentView:(NSArray *)inputFields clickedButton:(void (^)(UIButton *clickedButton))clickedButtonBlock;

// Creates an alert view with a title, a message and an array of buttons.
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonTypes:(NSArray *)buttonTypes clickedButtonAtIndex:(void (^)(NSUInteger clickedButtonIndex))clickedButtonIndexBlock;

// Creates an alert view sending a custom viewController
//- (instancetype)initAsPopUpWithViewController:(FLViewController *)viewController whenClosed:(void (^)())closed;

- (id)initWithNumberOfOptions:(NSInteger)options title:(NSString *)title optionsText:(NSArray *)optionsText optionsOn:(NSArray *)optionsOn buttonTitles:(NSArray *)buttonTitles buttonTypes:(NSArray *)buttonTypes delegate:(id)delegate clickedButtonAtIndex:(void (^)(NSUInteger clickedButtonIndex))clickedButtonIndexBlock;


// Presents the alert view, modally.
- (void)show;

@end
