//
//  UIWebView+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "UIWebView+Utils.h"

@implementation UIWebView (Utils)

- (void)mt_loadHTMLFromFile:(NSString *)fileName
{
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if (languageCode) {
        [self mt_loadHTMLFromFile:fileName languageCode:languageCode];
    }    
}

- (void)mt_loadHTMLFromFile:(NSString *)fileName languageCode:(NSString *)languageCode
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%@", fileName, languageCode] ofType:@"html"];
    if (!filePath)
    {
        filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
        if (!filePath)
        {
            DDLogError(@"Could not load html file for language code '%@'", languageCode);
            return;
        }
    }
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath isDirectory:NO]]];
}

@end
