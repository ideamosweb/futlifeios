//
//  UIFont+Utils.h
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Utils)

+ (UIFont *)fl_boldRobotoFontOfSize:(CGFloat)size;
+ (UIFont *)fl_robotoFontOfSize:(CGFloat)size;
+ (UIFont *)fl_italicRobotoFontOfSize:(CGFloat)size;
+ (UIFont *)fl_italicCronosFontOfSize:(CGFloat)size;

+ (UIFont *)fl_boldBebasFontOfSize:(CGFloat)size;
+ (UIFont *)fl_bebasFontOfSize:(CGFloat)size;
+ (UIFont *)fl_lightBebasFontOfSize:(CGFloat)size;
+ (UIFont *)fl_bookBebasFontOfSize:(CGFloat)size;
+ (UIFont *)fl_thinBebasFontOfSize:(CGFloat)size;

+ (UIFont *)fl_helveticaFontOfSize:(CGFloat)size;
+ (UIFont *)fl_boldHelveticaFontOfSize:(CGFloat)size;
+ (UIFont *)fl_lightHelveticaFontOfSize:(CGFloat)size;

@end
