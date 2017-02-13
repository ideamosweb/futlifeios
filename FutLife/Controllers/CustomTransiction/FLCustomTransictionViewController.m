//
//  FLCustomTransictionViewController.m
//  FutLife
//
//  Created by Rene Santis on 2/1/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomTransictionViewController.h"

@interface FLCustomTransictionViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation FLCustomTransictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    return [FLModalTransitionAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [FLModalTransitionAnimator new];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
