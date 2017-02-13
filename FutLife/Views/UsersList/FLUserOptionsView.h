//
//  FLUserOptionsView.h
//  FutLife
//
//  Created by Rene Santis on 2/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLUserOptionsProtocol <NSObject>

- (void)goToViewProfileWithAvatar:(UIImage *)avatar userName:(NSString *)userName name:(NSString *)name;
- (void)goToChallenge;
- (void)goToViewConsoles;
- (void)goToViewGames;

@end

@interface FLUserOptionsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *userOptionsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOptionsUserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userOptionsAvatarImageView;

@property (assign, nonatomic) id<FLUserOptionsProtocol> delegate;

@end
