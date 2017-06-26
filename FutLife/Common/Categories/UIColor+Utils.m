//
//  UIColor+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

#pragma mark - UIColor Random color
+ (UIColor *)fl_randomColor {
    UIColor *color;
    float randomRed   = (arc4random()%255)/255.0f;
    float randomGreen = (arc4random()%255)/255.0f;
    float randomBlue  = (arc4random()%255)/255.0f;
    
    color= [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
    
    return color;
}

#pragma mark - UIColor with Hex string

+ (UIColor *)fl_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
            case 3: // #RGB
            alpha = 1.0f;
            red   = [self fl_colorComponentFrom: colorString start: 0 length: 1];
            green = [self fl_colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self fl_colorComponentFrom: colorString start: 2 length: 1];
            break;
            case 4: // #ARGB
            alpha = [self fl_colorComponentFrom: colorString start: 0 length: 1];
            red   = [self fl_colorComponentFrom: colorString start: 1 length: 1];
            green = [self fl_colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self fl_colorComponentFrom: colorString start: 3 length: 1];
            break;
            case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self fl_colorComponentFrom: colorString start: 0 length: 2];
            green = [self fl_colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self fl_colorComponentFrom: colorString start: 4 length: 2];
            break;
            case 8: // #AARRGGBB
            alpha = [self fl_colorComponentFrom: colorString start: 0 length: 2];
            red   = [self fl_colorComponentFrom: colorString start: 2 length: 2];
            green = [self fl_colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self fl_colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            red = 0 ; green = 0 ; blue = 0; alpha = 1;
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)fl_colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark - UIColor with RGB value
+ (UIColor *)fl_colorWithRGB:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

#pragma mark - Gradient Color

+ (UIColor*)fl_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height
{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
