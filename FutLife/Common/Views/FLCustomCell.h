//
//  FLCustomCell.h
//  FutLife
//
//  Created by Rene Santis on 12/4/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLCustomCell : UITableViewCell

+ (UINib *)nib;

+ (NSString *)cellIdentifier;

+ (NSNumber *)rowHeight;

@end
