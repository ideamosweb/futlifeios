//
//  UsersListViewController.h
//  FutLife
//
//  Created by Rene Santis on 1/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLUsersListViewController : FLViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (id)initWithUsers:(NSArray *)users;

@end
