//
//  FLRegisterViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLFormViewController.h"

@interface FLRegisterViewController : FLFormViewController

- (id)initWithCompletedBlock:(void (^)())registrationCompletedBlock;

@end
