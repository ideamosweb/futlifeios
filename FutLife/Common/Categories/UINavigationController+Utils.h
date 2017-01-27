//
//  UINavigationController+Utils.h
//  FutLife
//
//  Created by Rene Santis on 1/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Utils)

- (void)fl_pushViewControllerFromRoot:(UIViewController *)viewController animated:(BOOL)animated;

@end
