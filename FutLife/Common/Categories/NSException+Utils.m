//
//  NSException+Utils.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "NSException+Utils.h"

@implementation NSException (Utils)

+ (NSException *)fl_singletonExceptionWithClass:(Class)clazz
{
    return [NSException exceptionWithName:@"FLSingletonInstantiationException" reason:[NSString stringWithFormat:@"Cannot instantiate an object of class '%@'. It's a singleton and there should be a method called sharedInstance to get the instance.", NSStringFromClass(clazz)] userInfo:nil];
}

+ (NSException *)fl_mustOverrideExceptionWithClass:(Class)clazz selector:(SEL)selector
{
    return [NSException exceptionWithName:@"FLMustOverrideException" reason:[NSString stringWithFormat:@"The method named '%@' must be overriden in class named '%@'.", NSStringFromSelector(selector), NSStringFromClass(clazz)] userInfo:nil];
}

@end
