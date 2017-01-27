//
//  FLTimeLineHomeViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLTimeLineHomeViewController.h"
#import "FLNavMenuViewController.h"
#import "FLUsersListViewController.h"

@interface FLTimeLineHomeViewController ()

@property (strong, nonatomic) NSArray *users;

@end

@implementation FLTimeLineHomeViewController

- (id)init
{
    self = [super initWithNibName:@"FLTimeLineHomeViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Nothing to do here
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setLeftDrawerViewController:[[FLNavMenuViewController alloc] init]];
    
    self.showNavigationBar = YES;    
    
    // Add logo to Navigation Bar
    CGFloat navBarIconHeight = self.navigationController.navigationBar.bounds.size.height * 0.7;
    UIImage *icon = [UIImage imageNamed:@"futLife-logo-text"];
    
    UIImageView *iconTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, navBarIconHeight, navBarIconHeight)];
    iconTitleView.image = icon;
    iconTitleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = iconTitleView;
    
    // Add sliding button
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 17.0f)];
    [menuButton setImage:[UIImage imageNamed:@"slidingMenuButton"]
                forState:UIControlStateNormal];
    
    [menuButton addTarget:self action:@selector(onMenuButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    menuButton.accessibilityIdentifier = @"Side_Menu_Button";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];    
    
    [self performGetAllRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show Navigation bar and set tint
    self.showNavigationBar = true;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4f/255.0f green:21.0f/255.0f blue:35.0f/255.0f alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)onMenuButtonTouch
{
    [self.navigationController.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)performGetAllRequest
{
    __weak __typeof(self)weakSelf = self;
    if ([FLLocalDataManager sharedInstance].sessionToken) {
        [FLAppDelegate showLoadingHUD];
        [[FLApiManager sharedInstance] getAllWithSuccess:^(FLUsersResponse *responseModel) {
            [FLAppDelegate hideLoadingHUD];
            __strong __typeof(weakSelf)strongSelf = weakSelf;            
            strongSelf.users = responseModel.data;
            FLUsersListViewController *usersVC = [[FLUsersListViewController alloc] initWithUsers:strongSelf.users];
            FLUsersListViewController *usersVC2 = [[FLUsersListViewController alloc] initWithUsers:strongSelf.users];
            [strongSelf.tabsViewControllers addObject:usersVC];
            [strongSelf.tabsViewControllers addObject:usersVC2];
            [strongSelf reloadTabs];
        } failure:^(FLApiError *error) {
            [FLAppDelegate hideLoadingHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                    
                }];
                [alert show];
            });
        }];
    }
}

- (void)localize
{
    
}

@end
