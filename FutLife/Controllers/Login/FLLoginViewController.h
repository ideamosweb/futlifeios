//
//  FLLoginViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLFormViewController.h"

@interface FLLoginViewController : FLFormViewController

- (id)initWithRegisterBlock:(void (^)())registerBlock loginBlock:(void (^)())loginBlock;

@end
