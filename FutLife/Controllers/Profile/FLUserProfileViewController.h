//
//  FLUserProfileViewController.h
//  FutLife
//
//  Created by Rene Santis on 2/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

typedef NS_ENUM (NSInteger, FLUserProfileType) {
    kFLUserProfileInfoType = 0,
    kFLUserProfileGamesType = 1,
    kFLUserProfileConsolesType = 2,
};

@interface FLUserProfileViewController : FLViewController

- (id)initWithUser:(FLUserModel *)userModel profileType:(FLUserProfileType)profileType;

@end
