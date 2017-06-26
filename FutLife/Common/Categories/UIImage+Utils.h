//
//  UIImage+utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage *)fl_imageFromUIColor:(UIColor *)color;

+ (UIImage *)fl_screenshot;

- (UIImage*)fl_blurredImage:(CGFloat)blurAmount;

- (UIImage*)fl_scaleToSize:(CGSize)newSize;

- (UIImage *)fl_croppedImage:(CGRect)bounds;

@end
