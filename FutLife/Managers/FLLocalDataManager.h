//
//  FLLocalDataManager.h
//  FutLife
//
//  Created by Rene Santis on 10/27/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLLocalDataManager : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) BOOL registeredUser;

@end
