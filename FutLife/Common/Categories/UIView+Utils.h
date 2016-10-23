//
//  UIView+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

+ (instancetype)loadFromNib;

- (void)fl_centerInView:(UIView *)aView;
- (void)fl_fadeInWithDuration:(NSTimeInterval)duration completion:(void (^)())completion;

- (void)fl_fadeOutWithDuration:(NSTimeInterval)duration completion:(void (^)())completion;

- (void)fl_applyBottomShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated;
- (void)fl_dropShadow;
- (void)fl_applySurroundingShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated;
- (void)fl_applySidesShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated;
- (void)fl_removeSurroundingShadowAnimated:(BOOL)animated;

- (void)fl_MakeCircularView;

- (void)fl_verticallyAlignInView:(UIView *)otherView;

- (void)fl_adjustHeightAfterSubviewRemoval:(UIView *)removedView;

- (void)fl_adjustVerticalPositionAfterAboveViewRemoval:(UIView *)removedView;

- (void)fl_setY:(CGFloat)y;
- (void)fl_setX:(CGFloat)x;
- (void)fl_setHeight:(CGFloat)height;
- (void)fl_setWidth:(CGFloat)width;
- (void)fl_addY:(CGFloat)amountToMove;
- (void)fl_addX:(CGFloat)amountToMove;
- (void)fl_addHeight:(CGFloat)amountToIncrease;
- (void)fl_addWidth:(CGFloat)amountToIncrease;
- (UIView *)fl_viewAtBottom;

- (UIScrollView *)fl_parentScrollView;
- (NSMutableArray *)fl_allSubViews;

@end
