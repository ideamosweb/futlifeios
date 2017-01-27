//
//  UINavigationController+Utils.m
//  FutLife
//
//  Created by Rene Santis on 1/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "UINavigationController+Utils.h"

@implementation UINavigationController (Utils)

- (void)fl_pushViewControllerFromRoot:(UIViewController *)viewController animated:(BOOL)animated
{
    [self popToRootViewControllerAnimated:NO];
    [self pushViewController:viewController animated:animated];
}

@end
