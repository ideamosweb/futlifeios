//
//  FLUserProfileViewController.h
//  FutLife
//
//  Created by Rene Santis on 2/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLUserProfileViewController : FLViewController

- (id)initWithUser:(FLUserModel *)userModel Avatar:(UIImage *)avatar name:(NSString *)name userName:(NSString *)userName;

@end
