//
//  NSUserDefaults+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Utils)

+ (NSString *)fl_stringForKey:(NSString *)key;
+ (id)fl_objectForKey:(NSString *)key;
+ (void)fl_setObject:(id)value forKey:(NSString *)key;

+ (id)fl_dataObjectForKey:(NSString *)key;
+ (void)fl_setDataObject:(id)value forKey:(NSString *)key;

+ (NSString *)fl_decryptedStringForKey:(NSString *)key;
+ (void)fl_encryptAndSetString:(NSString *)string forKey:(NSString *)key;

@end
