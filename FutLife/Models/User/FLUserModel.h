//
//  FLUserModel.h
//  FutLife
//
//  Created by Rene Santis on 12/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLUserModel : FLModel

@property (strong, nonatomic) NSNumber *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSArray *games;
@property (assign, nonatomic, getter=isActive) BOOL active;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@end
