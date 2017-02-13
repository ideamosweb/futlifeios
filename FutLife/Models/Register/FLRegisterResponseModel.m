//
//  FLRegisterResponseModel.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLRegisterResponseModel.h"

@implementation FLRegisterResponseModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token" : @"token",
             @"success" : @"success",
             @"data" : @"data"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:FLUserModel.class];
}

@end

@implementation FLRegisterPreferencesResponseModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"token" : @"token",
             @"success" : @"success",
             @"message" : @"message"
             };
}

@end
