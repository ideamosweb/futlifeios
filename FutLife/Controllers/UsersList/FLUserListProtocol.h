//
//  FLUserListProtocol.h
//  FutLife
//
//  Created by Rene Santis on 2/2/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLUserModel.h"

@protocol FLUserListProtocol <NSObject>

- (void)userOptionsWithUser:(FLUserModel *)userModel avatar:(UIImageView *)avatar name:(NSString *)name userName:(NSString *)userName;

@end
