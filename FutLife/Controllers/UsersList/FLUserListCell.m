//
//  FLUserListCell.m
//  FutLife
//
//  Created by Rene Santis on 1/24/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUserListCell.h"

@interface FLUserListCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation FLUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];   
}

- (void)setUserName:(NSString *)userName
{
    _userNameLabel.text = userName;
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;    
}

- (void)setUserAvatarWithUrl:(NSURL *)avatarUrl
{
    [_userImageView fl_MakeCircularView];
    [_userImageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

@end
