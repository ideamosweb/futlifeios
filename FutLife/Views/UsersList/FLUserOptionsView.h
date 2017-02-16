//
//  FLUserOptionsView.h
//  FutLife
//
//  Created by Rene Santis on 2/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLUserModel.h"

@protocol FLUserOptionsProtocol <NSObject>

- (void)goToViewProfileWithUser:(FLUserModel *)userModel avatar:(UIImage *)avatar userName:(NSString *)userName name:(NSString *)name;
- (void)goToChallenge;
- (void)goToViewConsoles;
- (void)goToViewGames;

@end

@interface FLUserOptionsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *userOptionsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOptionsUserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userOptionsAvatarImageView;

@property (strong, nonatomic) FLUserModel *user;

@property (assign, nonatomic) id<FLUserOptionsProtocol> delegate;

@end
