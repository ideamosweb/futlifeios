//
//  FLRegisterViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLRegisterViewController.h"

@interface FLRegisterViewController ()

@property (weak, nonatomic) IBOutlet FLTextField *nameTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *emailTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet FLTextField *passwordConfirmationTextfield;

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
    
    [self configTextFields];
    
    // Let's pass the fields to inputsFormManager
    self.inputsFormManager.inputFields = @[self.nameTextfield, self.userNameTextfield, self.emailTextfield, self.passwordTextfield, self.passwordConfirmationTextfield];
}

- (void)configTextFields
{
    self.nameTextfield.mandatoryValidation = YES;
    self.nameTextfield.minTypeableLengthValidation = 5;
    
    self.userNameTextfield.mandatoryValidation = YES;
    self.userNameTextfield.minTypeableLengthValidation = 5;
    
    self.emailTextfield.mandatoryValidation = YES;
    self.emailTextfield.email = YES;
    
    self.passwordTextfield.mandatoryValidation = YES;
    self.passwordConfirmationTextfield.mandatoryValidation = YES;
}

- (IBAction)onRegisterButtonTouch:(id)sender
{
    [self.inputsFormManager.currentInputField resignFirstResponder];
    if (self.inputsFormManager.isValid) {
        [self registerUser];
    }
}

- (void)registerUser
{
    FLRegisterRequestModel *requestModel = [FLRegisterRequestModel new];
    requestModel.name = self.nameTextfield.text;
    requestModel.userName = self.userNameTextfield.text;
    requestModel.email = self.emailTextfield.text;
    requestModel.password = self.passwordTextfield.text;
    requestModel.passwordConfirmation = self.passwordConfirmationTextfield.text;
    
    [[FLApiManager sharedInstance] registerRequestWithModel:requestModel success:^(FLRegisterResponseModel *responseModel) {
        NSLog(@"***Register success");
    } failure:^(NSError *error) {
        NSLog(@"***Register failed");
    }];
}

- (void)localize
{
    
}

@end
