//
//  FLAppDelegate.m
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLAppDelegate.h"
#import "FLStartUpViewController.h"

const CGFloat kNavMenuWidth = 283.0f;

@interface FLAppDelegate ()

@property (nonatomic, strong) UINavigationController *mainNavigationController;

@end

@implementation FLAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self openStartUp];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (instancetype)sharedInstance
{
    return (FLAppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UINavigationController *)mainNavigationController;
{
    ASSERT_CLASS([FLAppDelegate sharedInstance].mainNavigationController, UINavigationController);
    return [FLAppDelegate sharedInstance].mainNavigationController;
}

- (void)openStartUp
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    FLStartUpViewController *startUpVC = [[FLStartUpViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startUpVC];
    navigationController.navigationBarHidden = YES;
    navigationController.navigationBar.translucent = NO;
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:navigationController
                                            leftDrawerViewController:nil];
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    drawerController.maximumLeftDrawerWidth = kNavMenuWidth;
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0f]];
    drawerController.showsStatusBarBackgroundView = YES;
    drawerController.statusBarViewBackgroundColor = [UIColor blackColor];
    
    self.window.rootViewController = drawerController;
    self.mainNavigationController = navigationController;
    self.mainNavigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];    
}


@end
