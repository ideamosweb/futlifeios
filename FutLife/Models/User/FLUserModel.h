//
//  FLUserModel.h
//  FutLife
//
//  Created by Rene Santis on 12/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLUserModel : FLModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSArray *games;

@end
