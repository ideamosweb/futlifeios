//
//  FLChooseConsoleViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/31/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCarouselViewController.h"
#import "FLGameModel.h"

@interface FLChooseConsoleViewController : FLCarouselViewController

- (id)initWithCompletedBlock:(void (^)(NSArray *consoleType))chooseConsoleCompletedBlock;

@end
