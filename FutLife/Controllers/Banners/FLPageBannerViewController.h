//
//  FLPageBannerViewController.h
//  FutLife
//
//  Created by Rene Santis on 1/5/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLViewController.h"

@interface FLPageBannerViewController : UIViewController

@property (assign, nonatomic) NSInteger index;

- (id)initWithBackgroundImage:(UIImage *)bgImage titleImage:(UIImage *)titleImage contentImage:(UIImage *)contentImage index:(NSInteger)index;
- (void)perFormConfigContentImages;
- (void)configContentImages;
- (void)removeElementsFromSuperView;

@property (assign, nonatomic, getter=isFirstOrLastPage) BOOL firstOrLastPage;

@end
