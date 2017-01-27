//
//  FLLocalDataManager.h
//  FutLife
//
//  Created by Rene Santis on 10/27/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLUserModel.h"

@interface FLLocalDataManager : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) BOOL registeredUser;
@property (strong, nonatomic) FLUserModel *user;
@property (strong, nonatomic) UIImage *avatar;
@property (assign, nonatomic) BOOL chosenGame;
@property (assign, nonatomic) BOOL chosenConsole;
@property (assign, nonatomic) BOOL completedRegister;
@property (assign, nonatomic) BOOL logged;
@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSArray *games;
@property (copy, nonatomic) NSString *sessionToken;

@end
