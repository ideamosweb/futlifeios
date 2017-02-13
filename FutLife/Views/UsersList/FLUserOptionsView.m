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
    if ([self.delegate respondsToSelector:@selector(goToViewProfileWithAvatar:userName:name:)]) {
        [self.delegate goToViewProfileWithAvatar:self.userOptionsAvatarImageView.image userName:self.userOptionsUserNameLabel.text name:self.userOptionsNameLabel.text];
    }
}

- (IBAction)onChallengeButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToChallenge)]) {
        [self.delegate goToChallenge];
    }
}

- (IBAction)onViewConsolesButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToViewConsoles)]) {
        [self.delegate goToViewConsoles];
    }
}

- (IBAction)onViewGamesButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(goToViewGames)]) {
        [self.delegate goToViewGames];
    }
}

@end
