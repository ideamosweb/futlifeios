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
    UIView *superView = self.view;
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superView);
        make.width.equalTo(@240);
        make.height.equalTo(@109);
    }];
    
    [self.versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(superView.top);
        make.left.greaterThanOrEqualTo(superView.left);
        make.bottom.greaterThanOrEqualTo(superView.bottom);
        make.right.greaterThanOrEqualTo(superView.right);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setVersionLabel];
}

- (void)setVersionLabel
{
    NSString *currentAppVersion = [NSBundle fl_appVersion];
    
    if (currentAppVersion) {
        self.versionLabel.text = [NSString stringWithFormat:@"v%@", currentAppVersion];
    }
    
    [self goToRegisterOrLoginUser];
}

- (void)goToRegisterOrLoginUser
{
    if ([FLLocalDataManager sharedInstance].registeredUser) {
        // Go to login User
        [self goToLogin];
    } else {
        [self registerUser];
    }
}

- (void)registerUser
{
    FLRegisterViewController *registerVC = [[FLRegisterViewController alloc] initWithCompletedBlock:^{
        [FLLocalDataManager sharedInstance].registeredUser = YES;
        // Login User
        [self goToLogin];
    }];
    
    [self.navigationController pushViewController:registerVC animated:NO];
}

- (void)goToLogin
{
    FLLoginViewController *loginVC = [[FLLoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVC animated:YES];    
}

- (void)localize
{
    
}

@end
