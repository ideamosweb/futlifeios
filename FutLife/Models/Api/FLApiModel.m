//
//  FLApiModel.m
//  FutLife
//
//  Created by Rene Santis on 1/27/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLApiModel.h"

@implementation FLApiModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"message" : @"message",
             @"success" : @"success"
             };
}

@end
