//
//  FLGameModel.h
//  FutLife
//
//  Created by Rene Santis on 11/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

typedef NS_ENUM(NSInteger, FLConsoleTypes)
{
    FLConsolePlayStationS3 = 1,
    FLConsolePlayStation4,
    FLConsoleXbox360,
    FLConsoleXboxOne
};

@interface FLGameModel : FLModel

@property (strong, nonatomic) NSNumber *gameId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *year;
@property (copy, nonatomic) NSString *avatar;
@property (assign, nonatomic, getter=isActive) BOOL active;
@property (strong, nonatomic) NSNumber *platformId;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@property (strong, nonatomic) NSArray *consoles;

@end

@interface FLGameResponseModel : FLModel

@property (copy, nonatomic) NSArray *data;
@property (assign, nonatomic, getter=isSuccess) BOOL success;

@end
