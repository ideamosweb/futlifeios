//
//  FLLoginRequestModel.m
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLoginRequestModel.h"

@implementation FLLoginRequestModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userName": @"username",
             @"password": @"password"
             };
}

@end
