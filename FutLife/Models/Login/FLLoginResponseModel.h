//
//  FLLoginResponseModel.h
//  FutLife
//
//  Created by Rene Santis on 1/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLModel.h"

@interface FLLoginResponseModel : FLModel

@property (copy, nonatomic) NSString *token;
@property (assign, nonatomic, getter=isSuccess) BOOL success;
@property (strong, nonatomic) NSDictionary *data;

@end
