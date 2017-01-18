//
//  FLRegisterRequestModel.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLRegisterRequestModel : FLModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *passwordConfirmation;

@end

@interface FLComplementRegisterRequestModel : FLModel

@property (strong, nonatomic) NSNumber *userId;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSData *avatar;
@property (strong, nonatomic) NSArray *preferences;

@end
