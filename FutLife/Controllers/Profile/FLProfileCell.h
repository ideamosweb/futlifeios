//
//  FLProfileCell.h
//  FutLife
//
//  Created by Rene Santis on 12/1/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLCustomCell.h"

@interface FLProfileCell : FLCustomCell

- (void)setGameImageName:(NSString *)gameImageName gameName:(NSString *)gameName gameYear:(NSNumber *)gameYear gameNumber:(NSString *)gameNumber;

@end
