//
//  FLProfileViewController.h
//  FutLife
//
//  Created by Rene Santis on 12/1/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLProfileViewController : FLViewController

- (id)initWithConsoles:(NSArray *)consoles games:(NSArray *)games ompletedBlock:(void (^)())profileCompletedBlock;

@end
