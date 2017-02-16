//
//  FLConfigurationMatrixModel.m
//  FutLife
//
//  Created by Rene Santis on 2/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLConfigurationMatrixModel.h"
#import "FLConsoleModel.h"
#import "FLGameModel.h"

@implementation FLConfigurationMatrixModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"consoles" : @"consoles",
             @"games" : @"games"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)consolesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FLConsoleModel.class];
}

+ (NSValueTransformer *)gamesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FLGameModel.class];
}

@end
