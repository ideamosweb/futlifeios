//
//  FLLoginRequestModel.h
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLLoginRequestModel : FLModel

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;

@end
