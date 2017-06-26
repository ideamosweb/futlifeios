//
//  FLDebug.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

/*
 to disable: remove -DEBUG from Preprocessing settings
*/

#ifndef FLDebug_h
#define FLDebug_h

#if DEBUG
#define ASSERT(condition) NSCAssert(condition, @"%@", [NSString stringWithUTF8String:#condition])
#else
#define ASSERT(condition) (void)NULL
#endif

#if DEBUG
#define ASSERT_CLASS(object, aClass) ASSERT([object isKindOfClass:[aClass class]])
#else
#define ASSERT_CLASS(object, aClass) (void)NULL
#endif

#if DEBUG
#define ASSERT_CLASS_OR_NIL(object, aClass) ASSERT(!object || [object isKindOfClass:[aClass class]])
#else
#define ASSERT_CLASS_OR_NIL(object, aClass) (void)NULL
#endif

#if DEBUG
#define ASSERT_CLASS_CLASS(aClass, aSuperClass) ASSERT([aClass isSubclassOfClass:[aSuperClass class]])
#else
#define ASSERT_CLASS_CLASS(aClass, aSuperClass) (void)NULL
#endif

#if DEBUG
#define ASSERT_CLASS_CLASS_OR_NIL(aClass, aSuperClass) ASSERT(!aClass || [aClass isSubclassOfClass:[aSuperClass class]])
#else
#define ASSERT_CLASS_CLASS_OR_NIL(aClass, aSuperClass) (void)NULL
#endif

#if DEBUG
#define ASSERT_PROTOCOL(object, aProtocol) ASSERT([object conformsToProtocol:@protocol(aProtocol)])
#else
#define ASSERT_PROTOCOL(object, aProtocol) (void)NULL
#endif

#if DEBUG
#define ASSERT_PROTOCOL_OR_NIL(object, aProtocol) ASSERT(!object || [object conformsToProtocol:@protocol(aProtocol)])
#else
#define ASSERT_PROTOCOL_OR_NIL(object, aProtocol) (void)NULL
#endif

#if DEBUG
#define UNUSED(object) (void)object
#else
#define UNUSED(object) (void)NULL
#endif


#endif /* FLDebug_h */
