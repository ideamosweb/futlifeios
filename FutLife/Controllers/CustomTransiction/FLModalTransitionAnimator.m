//
//  FLModalTransitionAnimator.m
//  FutLife
//
//  Created by Rene Santis on 2/1/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModalTransitionAnimator.h"

@implementation FLModalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5; // 1
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext // 2
{
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if([destination isBeingPresented]) { // 3
        [self animatePresentation:transitionContext]; // 4
    } else {
        //[self animateDismissal:transitionContext]; // 5
    }
}

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* container = transitionContext.containerView;
    
    // Take destination view snapshot
    UIView* destinationSS = [destination.view snapshotViewAfterScreenUpdates:YES]; // YES because the view hasn't been rendered yet.
    
    // Add snapshot view
    [container addSubview:destinationSS];
    
    // Move destination snapshot back in Z plane
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -1000.0;
    perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100);
    destinationSS.layer.transform = perspectiveTransform;
    
    // Start appearance transition for source controller
    // Because UIKit does not remove views from hierarchy when transition finished
    [source beginAppearanceTransition:NO animated:YES];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            CGRect sourceRect = source.view.frame;
            sourceRect.origin.y = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            source.view.frame = sourceRect;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.8 animations:^{
            destinationSS.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        // Remove destination snapshot
        [destinationSS removeFromSuperview];
        
        // Add destination controller to view
        [container addSubview:destination.view];
        
        // Finish transition
        [transitionContext completeTransition:finished];
        
        // End appearance transition for source controller
        [source endAppearanceTransition];
    }];
}

@end
