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
    
    [self setVersionLabel];
    [self animationLogo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![FLLocalDataManager sharedInstance].registeredUser) {
        [self performSelector:@selector(registerUser) withObject:nil afterDelay:4.0];
    } else {
        [self performSelector:@selector(goToChooseConsole) withObject:nil afterDelay:4.0];
    }
}

- (void)animationLogo
{
    [self.logoImageView fl_animationLogo];
}

- (void)setVersionLabel
{
    NSString *currentAppVersion = [NSBundle fl_appVersion];
    
    if (currentAppVersion) {
        self.versionLabel.text = [NSString stringWithFormat:@"v%@", currentAppVersion];
    }
}

- (void)registerUser
{
    __weak __typeof(self)weakSelf = self;
    FLRegisterViewController *registerVC = [[FLRegisterViewController alloc] initWithCompletedBlock:^{
        [FLLocalDataManager sharedInstance].registeredUser = YES;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // Go to Choose Console
        [strongSelf goToChooseConsole];
    }];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)goToChooseConsole
{
    __weak __typeof(self)weakSelf = self;
    FLChooseConsoleViewController *chooseConsoleVC = [[FLChooseConsoleViewController alloc] initWithCompletedBlock:^(NSArray *consoleType) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToChooseGameWithConsoles:consoleType];
    }];
    
    [self.navigationController pushViewController:chooseConsoleVC animated:YES];
}

- (void)goToChooseGameWithConsoles:(NSArray *)consoles
{
    __weak __typeof(self)weakSelf = self;
    FLChooseGameViewController *chooseGameVC = [[FLChooseGameViewController alloc] initWithConsoles:consoles completedBlock:^(NSArray *consoleType, NSArray *games) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goToUserProfileWithConsoles:consoleType games:games];
    }];
    
    [self.navigationController pushViewController:chooseGameVC animated:YES];
}

- (void)goToUserProfileWithConsoles:(NSArray *)consoles games:(NSArray *)games
{
    FLProfileViewController *profileVC = [[FLProfileViewController alloc] initWithConsoles:consoles games:games ompletedBlock:^{
        
    }];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)goToLogin
{
    __weak __typeof(self)weakSelf = self;
    FLLoginViewController *loginVC = [[FLLoginViewController alloc] initWithRegisterBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // Go to register user
        [strongSelf registerUser];
    } loginBlock:^{
        // Go to dashboard!
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:@"Función login deshabilitada" buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
    
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)localize
{
    
}

@end
