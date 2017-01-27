//
//  FLRegisterRequestModel.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLRegisterRequestModel.h"
#import "FLGameModel.h"

@implementation FLRegisterRequestModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"userName": @"username",
             @"email": @"email",
             @"password": @"password",
             @"passwordConfirmation": @"password_confirmation"
             };
}

@end

@implementation FLRegisterPreferencesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"game_id",
             @"preferences": @"console_id",
             @"active" : @"active"
             };
}

@end

@implementation FLRegisterPreferencesRequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"user_id",             
             @"preferences": @"preferences"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)preferencesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FLGameModel.class];
}

@end
