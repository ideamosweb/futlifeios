//
//  FLUserProfileHistoryCell.m
//  FutLife
//
//  Created by Rene Santis on 2/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUserProfileHistoryCell.h"

@interface FLUserProfileHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation FLUserProfileHistoryCell

- (void)addAvatarImageUrl:(NSURL *)imageUrl
{
    [_avatar setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@""]];
}

- (void)addNameLabelString:(NSString *)nameString
{
    _nameLabel.text = nameString;
}

- (void)addUserNameLabelString:(NSString *)userNameString
{
    _userNameLabel.text = userNameString;
}

@end
