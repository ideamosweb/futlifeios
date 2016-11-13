//
//  FLGameModel.m
//  FutLife
//
//  Created by Rene Santis on 11/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLGameModel.h"

@implementation FLGameModel

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

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gameId" : @"id",
             @"name" : @"name",
             @"year" : @"year",
             @"avatar" : @"avatar",
             @"active" : @"active",
             @"platformId" : @"platform_id",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)consoleIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)platformIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSString *valueId = [NSString stringWithFormat:@"%@", (NSNumber *)value];
        return [self.numberFormatter numberFromString:valueId];
    }];
}

+ (NSValueTransformer *)yearJSONTransformer
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

@implementation FLGameResponseModel

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"data" : @"data",
             @"success" : @"success"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)dataJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:FLGameModel.class];
}

@end
