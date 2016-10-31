//
//  StartUpViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLStartUpViewController.h"
#import "FLRegisterViewController.h"
#import "FLLoginViewController.h"
#import "FLAppDelegate.h"

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
    
    [self performSelector:@selector(goToLogin) withObject:nil afterDelay:4.0];
}

- (void)animationLogo
{
    CGRect frame = CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, self.logoImageView.frame.size.width, self.logoImageView.frame.size.height);
    
    CGRect frameUP = CGRectMake(self.logoImageView.frame.origin.x - 10.0, self.logoImageView.frame.origin.y - 10.0, self.logoImageView.frame.size.width + 20.0, self.logoImageView.frame.size.height + 10.0);
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState |
    UIViewAnimationTransitionFlipFromRight;
    [self.logoImageView layoutIfNeeded];
    [self.logoImageView fl_fadeInWithDuration:0.5 completion:nil];
    
    [UIView transitionWithView:self.logoImageView duration:0.6 options:options animations:^{
        self.logoImageView.transform = CGAffineTransformMakeScale(1, -1);
    } completion:^(BOOL finished) {
        [UIView transitionWithView:self.logoImageView duration:0.2 options:options animations:^{
            self.logoImageView.transform = CGAffineTransformMakeScale(1, 0.8);
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.logoImageView duration:0.1 options:options animations:^{
                self.logoImageView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 delay:0.8 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    self.logoImageView.frame = frameUP;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.logoImageView.frame = frame;
                    } completion:nil];
                }];
            }];
            
        }];
    }];
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
    FLRegisterViewController *registerVC = [[FLRegisterViewController alloc] initWithCompletedBlock:^{
        [FLLocalDataManager sharedInstance].registeredUser = YES;
        // Login User
        // [self goToLogin];
    }];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)goToLogin
{
    FLLoginViewController *loginVC = [[FLLoginViewController alloc] initWithRegisterBlock:^{
        // Go to register user
        [self registerUser];
    } loginBlock:^{
        // Go to dashoboard!
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
