//
//  FLRegisterResponseModel.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"
#import "FLUserModel.h"

@interface FLRegisterResponseModel : FLModel

@property (copy, nonatomic) NSString *token;
@property (assign, nonatomic, getter=isSuccess) BOOL success;
@property (strong, nonatomic) FLUserModel *data;

@end

@interface FLRegisterPreferencesResponseModel : FLModel

@property (copy, nonatomic) NSString *token;
@property (assign, nonatomic, getter=isSuccess) BOOL success;
@property (copy, nonatomic) NSString *message;

@end
