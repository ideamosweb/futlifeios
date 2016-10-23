//
//  FLApiError.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLApiError.h"

@implementation FLApiError

- (BOOL)isConnectivityError
{
    return kServiceErrorNotConnectedToInternet == self.httpStatusCode;
}

- (BOOL)isCancelledError
{
    return kServiceErrorCancelled == self.httpStatusCode;
}

- (BOOL)isUnknownError
{
    return kServiceErrorUnknown == self.httpStatusCode;
}

@end
