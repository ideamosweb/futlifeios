//
//  FLError.h
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLError : NSObject

@property (assign, nonatomic) NSUInteger errorCode;
@property (copy, nonatomic) NSString *errorMessage;

- (id)initWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage;

@end
