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
@property (weak, nonatomic) IBOutlet UIButton *userOptionsButton;

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

#pragma mark - FLUserListCell protocol methods

- (IBAction)onUserOptionsTouch:(id)sender
{
    // Rotate userOptions button animation
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(120)];
    rotate.duration = 0.25;
    rotate.repeatCount = 1;
    [self.userOptionsButton.layer addAnimation:rotate forKey:@"userOptions.button.animation"];
    
    // Delay execution of my block for 0.25 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(userOptionsWithAvatar:name:userName:)]) {
            [self.delegate userOptionsWithAvatar:self.userImageView name:self.nameLabel.text userName:self.userNameLabel.text];
        }
    });
    
    
}

@end
