//
//  NSException+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (Utils)

+ (NSException *)fl_singletonExceptionWithClass:(Class)clazz;
+ (NSException *)fl_mustOverrideExceptionWithClass:(Class)clazz selector:(SEL)selector;

@end
