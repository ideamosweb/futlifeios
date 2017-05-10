//
//  FLUserOptionsView.m
//  FutLife
//
//  Created by Rene Santis on 2/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUserOptionsView.h"

@implementation FLUserOptionsView

- (IBAction)onViewProfileButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToViewProfileWithUser:avatar:userName:name:)]) {
        [self.delegate goToViewProfileWithUser:self.user avatar:self.userOptionsAvatarImageView.image userName:self.userOptionsUserNameLabel.text name:self.userOptionsNameLabel.text];
    }
}

- (IBAction)onChallengeButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToChallengeWithUserOpponent:)]) {
        [self.delegate goToChallengeWithUserOpponent:self.user];
    }
}

- (IBAction)onViewConsolesButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToViewConsolesWithUser:)]) {
        [self.delegate goToViewConsolesWithUser:self.user];
    }
}

- (IBAction)onViewGamesButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToViewProfileWithUser:avatar:userName:name:)]) {
        [self.delegate goToViewProfileWithUser:self.user avatar:self.userOptionsAvatarImageView.image userName:self.userOptionsUserNameLabel.text name:self.userOptionsNameLabel.text];
    }
    
//    if ([self.delegate respondsToSelector:@selector(goToViewGamesWithUser:)]) {
//        [self.delegate goToViewGamesWithUser:self.user];
//    }
}

@end
