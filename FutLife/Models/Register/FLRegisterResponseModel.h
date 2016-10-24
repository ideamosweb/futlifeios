//
//  FLRegisterResponseModel.h
//  FutLife
//
//  Created by Rene Santis on 10/23/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLRegisterResponseModel : FLModel

@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic, getter=isSuccess) BOOL success;

@end
