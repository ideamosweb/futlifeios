//
//  UIViewController+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/30/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (void)fl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIView *theWindow = self.view ;
    if( animated ) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:1.45f];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[theWindow layer] addAnimation:animation forKey:@""];
    }
    
    //make sure we pass the super "animated:NO" or we will get both our
    //animation and the super's animation
    [self.navigationController pushViewController:viewController animated:NO];
    
    //[self.navigationController swapButtonsForViewController:viewController];
    
}

@end
