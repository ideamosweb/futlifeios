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
#import "FLUserOptionsView.h"
#import "FLMenuManager.h"

@interface FLTimeLineHomeViewController ()<FLUserOptionsProtocol>

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) FLMenuManager *menuManager;

@property (strong, nonatomic) FLUserOptionsView *userOptionsView;
@property (strong, nonatomic) UIButton *darkBackgroundButton;

@property (nonatomic, copy) void (^timeLineCompletedBlock)();

@end

@implementation FLTimeLineHomeViewController

- (id)init
{
    self = [super initWithNibName:@"FLTimeLineHomeViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.menuManager = [FLMenuManager sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setLeftDrawerViewController:[[FLNavMenuViewController alloc] init]];
    
    self.showNavigationBar = YES;
    
    self.navigationItem.hidesBackButton = NO;
    
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
            FLUsersListViewController *usersVC = [[FLUsersListViewController alloc] initWithUsers:strongSelf.users parentViewController:self];
            FLUsersListViewController *usersVC2 = [[FLUsersListViewController alloc] initWithUsers:strongSelf.users parentViewController:self];
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

- (void)hideUserOptionsView:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect userOptionsViewFrame = self.userOptionsView.frame;
        userOptionsViewFrame.origin.y = [FLMiscUtils screenViewFrame].size.height + 20.0f;
        self.userOptionsView.frame = userOptionsViewFrame;
    } completion:^(BOOL finished) {
        self.darkBackgroundButton.hidden = YES;
        if (self.timeLineCompletedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLineCompletedBlock();
            });
        }        
    }];
}

#pragma mark - FLUserListCell protocol methods

- (void)userOptionsWithUser:(FLUserModel *)userModel avatar:(UIImageView *)avatar name:(NSString *)name userName:(NSString *)userName
{
    self.timeLineCompletedBlock = nil;
    CGRect darkBgViewFrame = CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height);
    self.darkBackgroundButton = [[UIButton alloc] initWithFrame:darkBgViewFrame];
    self.darkBackgroundButton.backgroundColor = [UIColor blackColor];
    self.darkBackgroundButton.alpha = 0.5f;
    self.darkBackgroundButton.userInteractionEnabled = YES;
    [self.darkBackgroundButton addTarget:self action:@selector(hideUserOptionsView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self.darkBackgroundButton];
    
    self.userOptionsView = [[[NSBundle mainBundle] loadNibNamed:@"FLUserOptionsView" owner:self options:nil] objectAtIndex:0];
    self.userOptionsView.delegate = self;
    CGRect useroptionsViewFrame = self.userOptionsView.frame;
    useroptionsViewFrame.size.width = [FLMiscUtils screenViewFrame].size.width;
    self.userOptionsView.frame = useroptionsViewFrame;
    
    CGRect userOptionsViewFrame = self.userOptionsView.frame;
    userOptionsViewFrame.origin.y = [FLMiscUtils screenViewFrame].size.height;
    self.userOptionsView.frame = userOptionsViewFrame;
    
    self.userOptionsView.userOptionsNameLabel.text = name;
    self.userOptionsView.userOptionsUserNameLabel.text = userName;
    [self.userOptionsView.userOptionsAvatarImageView fl_MakeCircularView];
    self.userOptionsView.userOptionsAvatarImageView.image = avatar.image;
    // Set all the user information
    self.userOptionsView.user = userModel;
    
    [self.userOptionsView layoutSubviews];
    [currentWindow addSubview:self.userOptionsView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect userOptionsViewFrame = self.userOptionsView.frame;
        userOptionsViewFrame.origin.y = [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(self.userOptionsView.frame) + 20.0f;
        self.userOptionsView.frame = userOptionsViewFrame;
    }];
}

#pragma mark - FLUserOptionsView protocol methods

- (void)goToViewProfileWithUser:(FLUserModel *)userModel avatar:(UIImage *)avatar userName:(NSString *)userName name:(NSString *)name
{
    __weak __typeof(self)weakSelf = self;    
    self.timeLineCompletedBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.menuManager.currentViewController = nil;
        //[strongSelf.menuManager onProfileTapped:nil withAvatar:avatar userName:userName name:name];
        [strongSelf.menuManager onProfileTapped:nil withUser:userModel withAvatar:avatar userName:userName name:name];
    };
    
    [self hideUserOptionsView:nil];
}

- (void)goToChallenge
{
    
}

- (void)goToViewConsoles
{
    
}

- (void)goToViewGames
{
    
}

- (void)localize
{
    
}

@end
