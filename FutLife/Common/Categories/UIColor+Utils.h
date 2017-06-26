//
//  UIColor+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+ (UIColor *)fl_randomColor;

+ (UIColor *)fl_colorWithHexString:(NSString *)hexString;

+ (UIColor *)fl_colorWithRGB:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

+ (UIColor*)fl_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

@end
