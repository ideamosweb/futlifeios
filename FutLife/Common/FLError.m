//
//  FLError.m
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLError.h"

@implementation FLError

- (id)initWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage
{
    self = [super init];
    if (self) {
        self.errorCode = errorCode;
        self.errorMessage = errorMessage;
    }
    
    return self;
}

@end
