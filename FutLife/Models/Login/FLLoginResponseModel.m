//
//  FLLoginResponseModel.m
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLLoginResponseModel.h"

@implementation FLLoginResponseModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token" : @"token",
             @"success" : @"success",
             @"data" : @"data"
             };
}

@end
