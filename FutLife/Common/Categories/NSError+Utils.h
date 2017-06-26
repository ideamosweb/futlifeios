//
//  NSError+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLApiError;

@interface NSError (Utils)

- (FLApiError *)fl_apiErrorWithHttpStatusCode:(NSInteger)statusCode;

@end