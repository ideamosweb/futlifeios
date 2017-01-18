//
//  UIFont+Utils.m
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+ (UIFont *)fl_boldRobotoFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Roboto-Bold" size:size];
}

+ (UIFont *)fl_mediumRobotoFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Roboto-Medium" size:size];
}

+ (UIFont *)fl_robotoFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Roboto-Regular" size:size];
}

+ (UIFont *)fl_italicCronosFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"CronosMMIt" size:size];
}

+ (UIFont *)fl_italicRobotoFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Roboto-Italic" size:size];
}

+ (UIFont *)fl_boldBebasFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Bebas Neue Bold" size:size];
}

+ (UIFont *)fl_bebasFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Bebas Neue" size:size];
}

+ (UIFont *)fl_lightBebasFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Bebas Neue Light" size:size];
}

+ (UIFont *)fl_bookBebasFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Bebas Neue Book" size:size];
}

+ (UIFont *)fl_thinBebasFontOfSize:(CGFloat)size
{
    return [self fontWithName:@"Bebas Neue Thin" size:size];
}

+ (UIFont *)fl_helveticaFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)fl_boldHelveticaFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-bold" size:size];
}

+ (UIFont *)fl_lightHelveticaFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-light" size:size];
}

@end
