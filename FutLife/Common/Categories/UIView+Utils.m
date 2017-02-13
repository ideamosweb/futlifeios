//
//  UIView+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)fl_centerInView:(UIView *)aView
{
    CGRect viewBounds = aView.bounds;
    
    CGPoint startPoint = CGPointZero;
    CGRect selfBounds = self.bounds;
    startPoint.x = CGRectGetWidth(viewBounds) / 2 - CGRectGetWidth(selfBounds) / 2;
    startPoint.y = CGRectGetHeight(viewBounds) / 2 - CGRectGetHeight(selfBounds) / 2;
    self.frame = CGRectMake(startPoint.x, startPoint.y, selfBounds.size.width, selfBounds.size.height);
}

- (void)fl_fadeInWithDuration:(NSTimeInterval)duration
                   completion:(void (^)())completion
{
    self.alpha = 0;
    [UIView animateWithDuration:duration animations: ^{
        self.alpha = 1;
    } completion: ^(BOOL finished) {
        if (completion)
        {
            completion();
        }
    }];
}

- (void)fl_fadeOutWithDuration:(NSTimeInterval)duration
                    completion:(void (^)())completion
{
    [UIView animateWithDuration:duration animations: ^{
        self.alpha = 0;
    } completion: ^(BOOL finished) {
        if (completion)
        {
            completion();
        }
    }];
}

- (void)fl_applyBottomShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:self.layer.shadowOpacity];
        anim.toValue = [NSNumber numberWithFloat:opacity];
        anim.duration = kDefaultAnimationDuration;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    }
    [FLMiscUtils addBasicShadow:self];
    [FLMiscUtils addBorder:self];
}

- (void)fl_dropShadow
{
    [self fl_applyBottomShadowRadius:1.5f opacity:0.3f animated:NO];
}

- (void)fl_applySurroundingShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:self.layer.shadowOpacity];
        anim.toValue = [NSNumber numberWithFloat:opacity];
        anim.duration = kDefaultAnimationDuration;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    }
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = opacity;
}

- (void)fl_applySidesShadowRadius:(CGFloat)shadowRadius opacity:(float)opacity animated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:self.layer.shadowOpacity];
        anim.toValue = [NSNumber numberWithFloat:opacity];
        anim.duration = kDefaultAnimationDuration;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    }
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = opacity;
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Draw a rotated hourglass shape
    // Start at the Top Left Corner
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    // Move to middle
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0)];
    // Move to the Top Right Corner
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0.0)];
    // Move to the Bottom Right Corner
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    // Move to middle
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0)];
    // Move to the Bottom Left Corner
    [path addLineToPoint:CGPointMake(0.0, CGRectGetHeight(self.frame))];
    // Move to the Close the Path
    [path closePath];
    self.layer.shadowPath = path.CGPath;
}

- (void)fl_removeSurroundingShadowAnimated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:self.layer.shadowOpacity];
        anim.toValue = [NSNumber numberWithFloat:0.0f];
        anim.duration = kDefaultAnimationDuration;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    }
    self.layer.shadowOpacity = 0.0f;
}

- (void)fl_MakeCircularView
{
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.clipsToBounds = YES;
}

- (void)fl_verticallyAlignInView:(UIView *)otherView
{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(otherView.frame) / 2 - CGRectGetHeight(frame) / 2;
    self.frame = frame;
}

- (void)fl_animationLogo
{
    CGRect frame = self.frame;
    
    CGRect frameUP = CGRectMake(frame.origin.x - 20.0, frame.origin.y - 10.0, frame.size.width + 20.0, frame.size.height + 10.0);
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState |
    UIViewAnimationTransitionFlipFromRight;
    [self layoutIfNeeded];
    [self fl_fadeInWithDuration:0.5 completion:nil];
    
    [UIView transitionWithView:self duration:0.6 options:options animations:^{
        self.transform = CGAffineTransformMakeScale(1, -1);
    } completion:^(BOOL finished) {
        [UIView transitionWithView:self duration:0.2 options:options animations:^{
            self.transform = CGAffineTransformMakeScale(1, 0.8);
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self duration:0.1 options:options animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 delay:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    self.bounds = frameUP;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.bounds = frame;
                    } completion:nil];
                }];
            }];
            
        }];
    }];
}

- (void)addShadowLayerWithWidth:(float)shadowWidth
{
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = CGRectMake(5.0f, 0.0f, shadowWidth - 10.0f, 1.0f);
    shadowLayer.shadowOffset = CGSizeZero;
    shadowLayer.shadowRadius = 1.0f;
    shadowLayer.shadowOpacity = 0.2f;
    shadowLayer.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.8f].CGColor;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:shadowLayer];
}

- (void)fl_setY:(CGFloat)y
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}
- (void)fl_setX:(CGFloat)x
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}
- (void)fl_setHeight:(CGFloat)height
{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}
- (void)fl_setWidth:(CGFloat)width
{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}
- (void)fl_addY:(CGFloat)amountToMove
{
    CGRect newFrame = self.frame;
    newFrame.origin.y += amountToMove;
    self.frame = newFrame;
}
- (void)fl_addX:(CGFloat)amountToMove
{
    CGRect newFrame = self.frame;
    newFrame.origin.x += amountToMove;
    self.frame = newFrame;
}
- (void)fl_addHeight:(CGFloat)amountToIncrease
{
    CGRect newFrame = self.frame;
    newFrame.size.height += amountToIncrease;
    self.frame = newFrame;
}
- (void)fl_addWidth:(CGFloat)amountToIncrease
{
    CGRect newFrame = self.frame;
    newFrame.size.width += amountToIncrease;
    self.frame = newFrame;
}
- (void)fl_adjustHeightAfterSubviewRemoval:(UIView *)removedView
{
    CGRect newFrame = self.frame;
    newFrame.size.height -= CGRectGetHeight(removedView.frame);
    self.frame = newFrame;
}
- (void)fl_adjustVerticalPositionAfterAboveViewRemoval:(UIView *)removedView
{
    CGRect newFrame = self.frame;
    newFrame.origin.y -= CGRectGetHeight(removedView.frame);
    self.frame = newFrame;
}

- (UIScrollView *)fl_parentScrollView
{
    UIScrollView *parentScrollView;
    UIView *currentSuperView = self.superview;
    if (!currentSuperView)
    {
        return nil;
    }
    while (!parentScrollView)
    {
        if ([currentSuperView isKindOfClass:[UIScrollView class]])
        {
            parentScrollView = (UIScrollView *)currentSuperView;
        }
        else
        {
            currentSuperView = currentSuperView.superview;
            if (!currentSuperView)
            {
                return nil;
            }
        }
    }
    return parentScrollView;
}

- (UIView *)fl_viewAtBottom
{
    UIView *viewWithMaxY = nil;
    for (UIView *view in self.subviews)
    {
        if (CGRectGetMaxY(viewWithMaxY.frame) <= CGRectGetMaxY(view.frame))
        {
            viewWithMaxY = view;
        }
    }
    return viewWithMaxY;
}

- (NSMutableArray *)fl_allSubViews
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self];
    for (UIView *subview in self.subviews)
    {
        [array addObjectsFromArray:(NSArray*)[subview fl_allSubViews]];
    }
    return array;
}

+ (instancetype)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

@end
