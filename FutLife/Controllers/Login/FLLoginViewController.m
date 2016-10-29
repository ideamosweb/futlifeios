//
//  FLLoginViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLoginViewController.h"

@interface FLLoginViewController ()

@property (weak, nonatomic) IBOutlet FLTextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *passwordTextfield;

@end

@implementation FLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Let's pass the fields to inputsFormManager
    self.inputsFormManager.inputFields = @[self.usernameTextfield, self.passwordTextfield];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self configTextFields];
}

// iOS 10 hotfix TODO: remove this
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self configTextFields];
}

- (void)configTextFields
{
    self.usernameTextfield.mandatoryValidation = YES;
    self.usernameTextfield.minTypeableLengthValidation = 5;
    self.usernameTextfield.maxTypeableLengthValidation = 20;
    UIRectCorner rectTopCorner = (UIRectCornerTopLeft | UIRectCornerTopRight);
    [self.usernameTextfield setRoundedCorners:rectTopCorner cornerRadii:CGSizeMake(10.0, 10.0)];
    
    self.passwordTextfield.mandatoryValidation = YES;
    self.passwordTextfield.password = YES;
    UIRectCorner rectBottomCorner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
    [self.passwordTextfield setRoundedCorners:rectBottomCorner cornerRadii:CGSizeMake(10.0, 10.0)];
}

- (IBAction)onLoginButtonTouch:(id)sender
{
    [self.inputsFormManager.currentInputField resignFirstResponder];
    
    [self.inputsFormManager validateFormWithSuccess:^{
        [self loginUser];
    } failureBlock:^(FLError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:error.errorMessage buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

// TODO: Move this to a LoginManager
- (void)loginUser
{
    
    
}

- (void)localize
{
    
}

@end
