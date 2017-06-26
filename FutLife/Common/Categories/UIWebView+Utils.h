//
//  UIWebView+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Utils)

- (void)mt_loadHTMLFromFile:(NSString *)fileName;
- (void)mt_loadHTMLFromFile:(NSString *)fileName languageCode:(NSString *)languageCode;

@end
