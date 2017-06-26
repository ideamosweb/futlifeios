//
//  FLValidatable.h
//  FutLife
//
//  Created by Rene Santis on 10/19/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLValidatable <NSObject>

// Validates the input field and returns the validation messages.
// It returns an empty array when there is no validation errors.
- (NSArray *)validate;

@end
