//
//  FLMenuManager.h
//  FutLife
//
//  Created by Rene Santis on 1/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLUserProfileViewController.h"

@interface FLMenuManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDictionary *menuItemDefinitions;
@property (nonatomic, strong) UIViewController *currentViewController;

- (void)onHomeTapped:(id)sender;
- (void)onProfileTapped:(id)sender withUser:(FLUserModel *)user profileType:(FLUserProfileType)profileType;
- (void)onSettingsTapped:(id)sender;
- (void)onAboutUsTapped:(id)sender;
- (void)onHelpTapped:(id)sender;
- (void)onSuggestionTapped:(id)sender;
- (void)onSendEmailTapped:(id)sender;
- (void)onLogOutTapped:(id)sender;

@end
