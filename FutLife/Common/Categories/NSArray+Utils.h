//
//  NSArray+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

- (id)fl_firstObject;
- (BOOL)fl_isEmpty;
- (id)fl_objectAtIndex:(NSUInteger)index;
- (id)fl_sortByDescriptorWithKey:(NSString *)key;

@end
