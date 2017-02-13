//
//  FLMenuManager.m
//  FutLife
//
//  Created by Rene Santis on 1/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLMenuManager.h"
#import "FLProfileViewController.h"
#import "FLLoginViewController.h"
#import "FLUserProfileViewController.h"

@implementation FLMenuManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static FLMenuManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[FLMenuManager alloc] initMenuManager];
    });
    return sharedInstance;
}

- (id)init
{
    @throw [NSException fl_singletonExceptionWithClass:[self class]];
}

- (id)initMenuManager
{
    self = [super init];
    if (self)
    {
        self.menuItemDefinitions = [self loadMenuDefinitions];
    }
    return self;
}

- (NSDictionary *)loadMenuDefinitions
{
    NSDictionary *menuDefinitions = [[NSDictionary alloc] initWithContentsOfFile:
                                     [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"MenuItemDefinitions.plist"]];
    return menuDefinitions;
}

#pragma Mark - Touch Up inside menu button methods

- (void)onHomeTapped:(id)sender
{
    
}

- (void)onProfileTapped:(id)sender withAvatar:(UIImage *)avatar userName:(NSString *)userName name:(NSString *)name
{
    DDLogInfo(@"%@", NSStringFromSelector(_cmd));
    DDLogInfo(@"%@", self.currentViewController.title);
    
//    if (![self.currentViewController isKindOfClass:[FLProfileViewController class]]) {
//        UINavigationController *nav = [FLAppDelegate mainNavigationController];
//        NSArray *consoles = [FLLocalDataManager sharedInstance].consoles;
//        NSArray *games = [FLLocalDataManager sharedInstance].games;
//        self.currentViewController = [[FLProfileViewController alloc] initWithConsoles:consoles games:games confirmButton:false completedBlock:nil];
//        
//        [nav fl_pushViewControllerFromRoot:self.currentViewController animated:YES];
//    }
    
    if (![self.currentViewController isKindOfClass:[FLUserProfileViewController class]]) {
        UINavigationController *nav = [FLAppDelegate mainNavigationController];
        //NSArray *consoles = [FLLocalDataManager sharedInstance].consoles;
        //NSArray *games = [FLLocalDataManager sharedInstance].games;
        self.currentViewController = [[FLUserProfileViewController alloc] initWithAvatar:avatar name:name userName:userName];
        
        [nav fl_pushViewControllerFromRoot:self.currentViewController animated:YES];
    }
}

- (void)onSettingsTapped:(id)sender
{
    
}

- (void)onAboutUsTapped:(id)sender
{
    
}

- (void)onHelpTapped:(id)sender
{
    
}

- (void)onSuggestionTapped:(id)sender
{
    
}

- (void)onSendEmailTapped:(id)sender
{
    
}

- (void)onLogOutTapped:(id)sender
{
    DDLogInfo(@"%@", NSStringFromSelector(_cmd));
    DDLogInfo(@"%@", self.currentViewController.title);
    
    if (![self.currentViewController isKindOfClass:[FLLoginViewController class]]) {
        [[FLLoginManager sharedInstance] logOut];
        //UINavigationController *nav = [FLAppDelegate mainNavigationController];
        //self.currentViewController = [[FLLoginViewController alloc] init];
        
        //[nav fl_pushViewControllerFromRoot:self.currentViewController animated:YES];
    }
}

@end
