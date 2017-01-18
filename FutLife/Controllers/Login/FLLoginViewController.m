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
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, copy) void (^registerBlock)();
@property (nonatomic, copy) void (^loginBlock)();

@end

@implementation FLLoginViewController

- (id)initWithRegisterBlock:(void (^)())registerBlock loginBlock:(void (^)())loginBlock
{
    self = [super initWithNibName:@"FLLoginViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.registerBlock = registerBlock;
        self.loginBlock = loginBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    // Set status bar style
    MMDrawerController *drawerVC = (MMDrawerController *)[FLAppDelegate sharedInstance].window.rootViewController;
    drawerVC.showsStatusBarBackgroundView = YES;
    drawerVC.statusBarViewBackgroundColor = [UIColor blackColor];
    
    // Let's pass the fields to inputsFormManager
    self.inputsFormManager.inputFields = @[self.usernameTextfield, self.passwordTextfield];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showNavigationBar = NO;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
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
    
    __weak __typeof(self)weakSelf = self;
    [self.inputsFormManager validateFormWithSuccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf loginUser];
    } failureBlock:^(FLError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:error.errorMessage buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (IBAction)onRegisterButtonTouch:(id)sender
{
    // Call register block to go to startUp
    self.registerBlock();
}

- (IBAction)onForgetPasswordButtonTouch:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:@"Función deshabilitada por ahora" buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
            
        }];
        [alert show];
    });
    
}

- (void)loginUser
{
    FLLoginRequestModel *request = [FLLoginRequestModel new];
    request.userName = self.usernameTextfield.text;
    request.password = self.passwordTextfield.text;
    
    __weak __typeof(self)weakSelf = self;
    [FLAppDelegate showLoadingHUD];
    
    [[FLLoginManager sharedInstance] loginWithRequest:request successBlock:^{
        [FLAppDelegate hideLoadingHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.loginBlock();
    } failure:^(FLApiError *error) {
        [FLAppDelegate hideLoadingHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (void)localize
{
    
}

@end
