//
//  FLRegisterViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLRegisterViewController.h"
#import "FLLocalDataManager.h"

@interface FLRegisterViewController ()

@property (weak, nonatomic) IBOutlet FLTextField *nameTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *emailTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *passwordTextfield;

@property (nonatomic, copy) void (^registrationCompletedBlock)();

@end

@implementation FLRegisterViewController

- (id)initWithCompletedBlock:(void (^)())registrationCompletedBlock
{
    self = [super initWithNibName:@"FLRegisterViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.registrationCompletedBlock = registrationCompletedBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;    
    
    // Let's pass the fields to inputsFormManager
    self.inputsFormManager.inputFields = @[self.nameTextfield, self.userNameTextfield, self.emailTextfield, self.passwordTextfield];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self configTextFields];
}

- (void)configTextFields
{
    self.nameTextfield.mandatoryValidation = YES;
    self.nameTextfield.minTypeableLengthValidation = 5;
    self.nameTextfield.maxTypeableLengthValidation = 20;
    UIRectCorner rectTopCorner = (UIRectCornerTopLeft | UIRectCornerTopRight);
    [self.nameTextfield setRoundedCorners:rectTopCorner cornerRadii:CGSizeMake(10.0, 10.0)];
    
    self.userNameTextfield.mandatoryValidation = YES;
    self.userNameTextfield.minTypeableLengthValidation = 5;
    self.userNameTextfield.maxTypeableLengthValidation = 20;
    
    self.emailTextfield.mandatoryValidation = YES;
    self.emailTextfield.email = YES;
    
    self.passwordTextfield.mandatoryValidation = YES;
    self.passwordTextfield.password = YES;
    self.passwordTextfield.minTypeableLengthValidation = 6;
    self.passwordTextfield.maxTypeableLengthValidation = 20;
    UIRectCorner rectBottomCorner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
    [self.passwordTextfield setRoundedCorners:rectBottomCorner cornerRadii:CGSizeMake(10.0, 10.0)];
}

- (IBAction)onRegisterButtonTouch:(id)sender
{
    [self.inputsFormManager.currentInputField resignFirstResponder];
    
    [self.inputsFormManager validateFormWithSuccess:^{
        [self registerUser];
    } failureBlock:^(FLError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:error.errorMessage buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (IBAction)onFacebookConnectButtonTouch:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:@"Función deshabilitada por ahora" buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
            
        }];
        [alert show];
    });
    
}

- (void)registerUser
{
    FLRegisterRequestModel *requestModel = [FLRegisterRequestModel new];
    requestModel.name = self.nameTextfield.text;
    requestModel.userName = self.userNameTextfield.text;
    requestModel.email = self.emailTextfield.text;
    requestModel.password = self.passwordTextfield.text;
    requestModel.passwordConfirmation = self.passwordTextfield.text;
    // self.registrationCompletedBlock();
    
    __weak __typeof(self)weakSelf = self;
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] registerRequestWithModel:requestModel success:^(FLRegisterResponseModel *responseModel) {
        [FLAppDelegate hideLoadingHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FLUserModel *user = (FLUserModel *)responseModel.data;
        [FLLocalDataManager sharedInstance].user = user;
        
        strongSelf.registrationCompletedBlock();
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
