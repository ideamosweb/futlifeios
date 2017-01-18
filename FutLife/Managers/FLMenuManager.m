//
//  FLMenuManager.m
//  FutLife
//
//  Created by Rene Santis on 1/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLMenuManager.h"

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

- (void)onProfileTapped:(id)sender
{
    
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
    
}

@end
