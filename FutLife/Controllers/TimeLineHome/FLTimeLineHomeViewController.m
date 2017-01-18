//
//  FLTimeLineHomeViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLTimeLineHomeViewController.h"
#import "FLNavMenuViewController.h"

@interface FLTimeLineHomeViewController ()

@end

@implementation FLTimeLineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setLeftDrawerViewController:[[FLNavMenuViewController alloc] init]];
    
    self.showNavigationBar = YES;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 17.0f)];
    [menuButton setImage:[UIImage imageNamed:@"slidingMenuButton"]
                forState:UIControlStateNormal];
    
    [menuButton addTarget:self action:@selector(onMenuButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    menuButton.accessibilityIdentifier = @"Side_Menu_Button";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];    
    
    self.title = @"Time Line";
}

- (void)onMenuButtonTouch
{
    [self.navigationController.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)localize
{
    
}

@end
