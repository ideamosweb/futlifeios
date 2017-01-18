//
//  FLRegisterRequestModel.m
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLRegisterRequestModel.h"

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

@implementation FLComplementRegisterRequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"user_id",
             @"userName": @"username",
             @"avatar": @"avatar",
             @"preferences": @"preferences"
             };
}

@end
