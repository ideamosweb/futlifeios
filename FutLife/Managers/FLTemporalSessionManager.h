//
//  FLTemporalSessionManager.h
//  FutLife
//
//  Created by Rene Santis on 1/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLTemporalSessionManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign, getter=isLogOut) BOOL logOut;
@property (copy, nonatomic) NSString *sessionToken;

@end
