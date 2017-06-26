//
//  NSError+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSError+Utils.h"
#import "FLApiError.h"

@implementation NSError (Utils)

- (FLApiError *)fl_apiErrorWithHttpStatusCode:(NSInteger)statusCode;
{
    FLApiError *serviceError = [[FLApiError alloc] init];
    if (self.code == kCFURLErrorNotConnectedToInternet)
    {
        serviceError.httpStatusCode = kServiceErrorNotConnectedToInternet;
    }
    else if (self.code == kCFURLErrorCancelled || self.code == kCFHostErrorUnknown)
    {
        serviceError.httpStatusCode = kServiceErrorCancelled;
    }
    else
    {
        //serviceError = [[self.userInfo objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
        if (!serviceError)
        {
            serviceError = [[FLApiError alloc] init];
        }
        serviceError.httpStatusCode = statusCode ? statusCode : kServiceErrorUnknown;
    }
    return serviceError;
}

@end
