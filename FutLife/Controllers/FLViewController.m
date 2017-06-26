//
//  FLViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLViewController ()

@end

@implementation FLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Localize the view
    [self localize];
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self addBackButton];
    }
    
}

- (void)localize
{
    @throw [NSException fl_mustOverrideExceptionWithClass:[self class] selector:_cmd];
}

- (void)addBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 17.0f)];
    [backButton setImage:[UIImage imageNamed:@"NavigationBarBackButton"]
                forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonTouch)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)onBackButtonTouch
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
