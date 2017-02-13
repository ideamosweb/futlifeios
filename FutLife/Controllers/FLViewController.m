//
//  FLViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"
#import "FLAppDelegate.h"
#import "FLStartUpViewController.h"

@interface FLViewController ()

@end

@implementation FLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = NO;
    
    // Localize the view
    [self localize];
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar
{
    UINavigationController *mainNavController = (UINavigationController *)[FLAppDelegate mainNavigationController];
    if (showNavigationBar) {
        mainNavController.navigationBarHidden = NO;
        [mainNavController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        mainNavController.navigationBar.shadowImage = [UIImage new];
        mainNavController.navigationBar.translucent = YES;
        mainNavController.view.backgroundColor = [UIColor clearColor];
        mainNavController.navigationBar.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        if (mainNavController.viewControllers.count > 1) {
            [self addBackButton];
        } else {
            [self removeBackButton];
        }
    } else {
        mainNavController.navigationBarHidden = YES;
    }
}

- (void)localize
{
    @throw [NSException fl_mustOverrideExceptionWithClass:[self class] selector:_cmd];
}

- (void)addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 12.5f, 23.0f)];
    [backButton setImage:[UIImage imageNamed:@"NavigationBarBackButton"]
                forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonTouch)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)removeBackButton
{
    self.navigationItem.hidesBackButton = YES;    
}

- (void)onBackButtonTouch
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
