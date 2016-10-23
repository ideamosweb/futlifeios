//
//  NSArray+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (id)fl_firstObject
{
    if ([self count] > 0) {
        return [self objectAtIndex:0];
    }
    return nil;
}

- (BOOL)fl_isEmpty
{
    return [self count] == 0;
}

- (id)fl_objectAtIndex:(NSUInteger)index
{
    ASSERT(index < [self count]);
    return (index < [self count] ? [self objectAtIndex:index] : nil);
}

- (id)fl_sortByDescriptorWithKey:(NSString *)key
{
    if (self) {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        NSArray *sortDescriptors = @[descriptor];
        NSArray *sortedArray = [self sortedArrayUsingDescriptors:sortDescriptors];
        
        return sortedArray;
    }
    return nil;
}

@end
