//
//  FLChooseGameViewController.h
//  FutLife
//
//  Created by Rene Santis on 11/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCarouselViewController.h"
#import "FLGameModel.h"

@interface FLChooseGameViewController : FLCarouselViewController

- (id)initWithConsoles:(NSArray *)consoles completedBlock:(void (^)())chooseGameCompletedBlock;

@end
