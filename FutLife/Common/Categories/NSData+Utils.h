//
//  NSData+Utils.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utils)

- (NSData *)mt_AES256EncryptWithKey:(NSString *)key;
- (NSData *)mt_AES256DecryptWithKey:(NSString *)key;

@end
