//
//  FLViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FLViewController : GAITrackedViewController

@property (assign, nonatomic, getter=isShowNavigationBar) BOOL showNavigationBar;

@end

