//
//  FLUserListCell.h
//  FutLife
//
//  Created by Rene Santis on 1/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"
#import "FLUserListProtocol.h"

@interface FLUserListCell : FLCustomCell

- (void)setUserName:(NSString *)userName;
- (void)setName:(NSString *)name;
- (void)setUserAvatarWithUrl:(NSURL *)avatarUrl;

@property (nonatomic) id<FLUserListProtocol> delegate;

@end
