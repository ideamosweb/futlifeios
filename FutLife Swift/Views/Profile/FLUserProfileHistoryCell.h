//
//  FLUserProfileHistoryCell.h
//  FutLife
//
//  Created by Rene Santis on 2/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@interface FLUserProfileHistoryCell : FLCustomCell

- (void)addAvatarImageUrl:(NSURL *)imageUrl;
- (void)addNameLabelString:(NSString *)nameString;
- (void)addUserNameLabelString:(NSString *)userNameString;

@end
