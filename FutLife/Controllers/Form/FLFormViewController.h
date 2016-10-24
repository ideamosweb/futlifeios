//
//  FLFormViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"
#import "FLTextField.h"
#import "FLInputsFormManager.h"

@interface FLFormViewController : FLViewController<UITextFieldDelegate>

// The ScrollView for form View controller, it's needs to link in
// interface builder or link programatically
@property (weak, nonatomic) IBOutlet UIScrollView *formScrollView;

// This property manages all the inputs and
// validate the error messages
@property (strong, nonatomic) FLInputsFormManager *inputsFormManager;

@end
