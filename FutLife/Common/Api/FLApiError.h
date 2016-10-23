//
//  FLApiError.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger kServiceErrorCancelled = 9999;
static const NSInteger kServiceErrorNotConnectedToInternet = 9998;
static const NSInteger kServiceErrorUnknown = 9997;

@interface FLApiError : NSObject

@property (nonatomic, assign) NSInteger httpStatusCode;

- (BOOL)isConnectivityError;
- (BOOL)isCancelledError;
- (BOOL)isUnknownError;

@end
