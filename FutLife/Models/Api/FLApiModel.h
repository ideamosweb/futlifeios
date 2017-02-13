//
//  FLApiModel.h
//  FutLife
//
//  Created by Rene Santis on 1/27/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLApiModel : FLModel

@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) BOOL success;

@end
