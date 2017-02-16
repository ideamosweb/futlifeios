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

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    return dateFormatter;
}

+ (NSNumberFormatter *)numberFormatter {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return numberFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gameId": @"game_id",
             @"consoleId": @"console_id",
             @"active" : @"active",
             @"preferenceId" : @"id",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at",
             @"userId" : @"user_id"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)userIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)consoleIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)preferenceIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)gameIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end

@implementation FLRegisterPreferencesRequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"user_id",             
             @"games": @"games"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)gamesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FLGameRequestModel.class];
}

@end
