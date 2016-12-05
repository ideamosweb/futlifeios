//
//  FLCustomCell.m
//  FutLife
//
//  Created by Rene Santis on 12/4/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@implementation FLCustomCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellIdentifier
{
    return NSStringFromClass(self);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSNumber *)rowHeight
{
    return [NSNumber numberWithFloat:44.0f];
}

@end
