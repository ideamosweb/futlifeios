//
//  StartUpViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLAppDelegate.h"

#import "FLStartUpViewController.h"
#import "FLRegisterViewController.h"
#import "FLLoginViewController.h"
#import "FLChooseConsoleViewController.h"
#import "FLChooseGameViewController.h"
#import "FLProfileViewController.h"
#import "FLBannersViewController.h"

@interface FLStartUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (strong, nonatomic) NSMutableArray *animateableConstraints;

@end

@implementation FLStartUpViewController

- (id)init
{
    self = [super initWithNibName:@"FLStartUpViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        //Set Masonry AutoLayout constraints to views
        [self masMakeConstraints];
    }
    return self;
}

- (void)masMakeConstraints
{
    self.animateableConstraints = [NSMutableArray new];
    UIView *superView = self.view;
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superView);
        make.width.equalTo(@240);
        make.height.equalTo(@110);
    }];
    
    self.logoImageView.transform = CGAffineTransformMakeScale(1, 1);
    
    [self.versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(superView.top);
        make.left.greaterThanOrEqualTo(superView.left);
        make.bottom.greaterThanOrEqualTo(superView.bottom);
        make.right.greaterThanOrEqualTo(superView.right);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Control login behaviour
    if (![FLTemporalSessionManager sharedInstance].isLogOut) {
        [self setVersionLabel];
        [self animationLogo];
    } else {
        [self goToLogin];
    }
}

- (void)animationLogo
{
    [self getParameters];
    [self.logoImageView fl_animationLogo];
}

- (void)getParameters
{
    __weak __typeof(self)weakSelf = self;
    [[FLApiManager sharedInstance] getParametersRequestWithSuccess:^(FLConfigurationMatrixModel *responseModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [FLTemporalSessionManager sharedInstance].parameters = responseModel;
        
        if ([FLLocalDataManager sharedInstance].completedRegister || [FLLocalDataManager sharedInstance].logged) {
            [strongSelf performSelector:@selector(goToTimeLineHome) withObject:nil afterDelay:4.0];
        } else {
            [strongSelf performSelector:@selector(showBanners) withObject:nil afterDelay:4.0];
        }
    } failure:^(FLApiError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (void)setVersionLabel
{
    NSString *currentAppVersion = [NSBundle fl_appVersion];
    
    if (currentAppVersion) {
        self.versionLabel.text = [NSString stringWithFormat:@"v%@", currentAppVersion];
    }
}

- (void)showBanners
{
    __weak __typeof(self)weakSelf = self;
    FLBannersViewController *bannersVC = [[FLBannersViewController alloc] initWithCompletionBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf checkLoginOrRegisterProcess];
    }];
    
    //[self.navigationController pushViewController:bannersVC animated:YES];
    [self presentViewController:bannersVC animated:YES completion:nil];
}

- (void)checkLoginOrRegisterProcess
{
    if (![FLLocalDataManager sharedInstance].registeredUser) {
        [self goToLogin];
    } else {
        if (![FLLocalDataManager sharedInstance].registeredUser) {
            [self registerUser];
        } else if (![FLLocalDataManager sharedInstance].chosenConsole) {
            [self goToChooseConsoleWithNavBar:YES];
        } else if (![FLLocalDataManager sharedInstance].chosenGame) {
            [self goToChooseGameWithConsoles:[FLLocalDataManager sharedInstance].consoles];
        } else if (![FLLocalDataManager sharedInstance].completedRegister) {
            [self goToUserProfileWithConsoles:[FLLocalDataManager sharedInstance].consoles games:[FLLocalDataManager sharedInstance].games];
        } else {
            [self goToTimeLineHome];
        }
    }
}

- (void)registerUser
{
    __weak __typeof(self)weakSelf = self;
    FLRegisterViewController *registerVC = [[FLRegisterViewController alloc] initWithCompletedBlock:^{
        // Set registered user
        [FLLocalDataManager sharedInstance].registeredUser = YES;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // Go to Choose Console
        [strongSelf goToChooseConsoleWithNavBar:YES];
    }];
    
    [[FLAppDelegate mainNavigationController] pushViewController:registerVC animated:YES];
}

- (void)goToChooseConsoleWithNavBar:(BOOL)navBar
{
    __weak __typeof(self)weakSelf = self;
    FLChooseConsoleViewController *chooseConsoleVC = [[FLChooseConsoleViewController alloc] initWithNavBar:navBar completedBlock:^(NSArray *consoleType) {
        [FLLocalDataManager sharedInstance].chosenConsole = YES;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToChooseGameWithConsoles:consoleType];
    }];
    
    [[FLAppDelegate mainNavigationController] pushViewController:chooseConsoleVC animated:YES];
}

- (void)goToChooseGameWithConsoles:(NSArray *)consoles
{
    __weak __typeof(self)weakSelf = self;
    FLChooseGameViewController *chooseGameVC = [[FLChooseGameViewController alloc] initWithConsoles:consoles completedBlock:^(NSArray *consoleType, NSArray *games) {
        [FLLocalDataManager sharedInstance].chosenGame = true;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToUserProfileWithConsoles:consoleType games:games];
    }];
    
    [[FLAppDelegate mainNavigationController] pushViewController:chooseGameVC animated:YES];
}

- (void)goToUserProfileWithConsoles:(NSArray *)consoles games:(NSArray *)games
{
    __weak __typeof(self)weakSelf = self;
    FLProfileViewController *profileVC = [[FLProfileViewController alloc] initWithConsoles:consoles games:games confirmButton:true completedBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToTimeLineHome];
    }];
    
    [[FLAppDelegate mainNavigationController] pushViewController:profileVC animated:YES];
}

- (void)goToLogin
{
    if ([FLTemporalSessionManager sharedInstance].isLogOut) {
        // Set nil to left menu after logout for avoid any view on left
        [FLAppDelegate mainNavigationController].mm_drawerController.leftDrawerViewController = nil;
        [FLTemporalSessionManager sharedInstance].logOut = false;
    }
    
    __weak __typeof(self)weakSelf = self;
    FLLoginViewController *loginVC = [[FLLoginViewController alloc] initWithRegisterBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // Go to register user
        [strongSelf registerUser];
    } loginBlock:^{
        // Go to dashboard!
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToTimeLineHome];
    }];
    
    [[FLAppDelegate mainNavigationController] pushViewController:loginVC animated:YES];
}

- (void)goToTimeLineHome
{
    [[FLAppDelegate sharedInstance] openTimeLineHome];
}

- (void)localize
{
    
}

@end
