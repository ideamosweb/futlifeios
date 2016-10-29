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

- (NSString *)errorMessage
{
    if ([self isConnectivityError]) {
        return @"Error de conexión";
    } else if ([self isCancelledError]) {
        return @"La operación ha sido cancelada";
    } else if ([self isUnknownError]) {
        return @"Algo ocurrio, por favor intente de nuevo";
    }
    
    return @"Algo ocurrio, por favor intente más tarde";
}

@end
