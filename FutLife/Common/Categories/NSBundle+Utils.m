//
//  NSBundle+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSBundle+Utils.h"

@implementation NSBundle (Utils)

+ (NSString *)fl_appVersion
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)fl_appBuildString
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}

@end
