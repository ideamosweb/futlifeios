//
//  TabsViewController.h
//  FutLife
//
//  Created by Rene Santis on 1/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLTabsViewController : FLViewController

// Set the view controller for each tab
@property (strong, nonatomic) NSMutableArray *tabsViewControllers;

// Reload tabs after set view's controllers
- (void)reloadTabs;

@end
