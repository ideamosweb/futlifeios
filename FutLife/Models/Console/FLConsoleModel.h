//
//  FLConsoleModel.h
//  FutLife
//
//  Created by Rene Santis on 11/13/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLConsoleModel : FLModel

@property (strong, nonatomic) NSNumber *consoleId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *year;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic, getter=isActive) BOOL active;
@property (strong, nonatomic) NSNumber *platformId;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@end

@interface FLConsoleResponseModel : FLModel

@property (copy, nonatomic) NSArray *data;
@property (assign, nonatomic, getter=isSuccess) BOOL success;

@end
