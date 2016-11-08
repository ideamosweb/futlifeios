//
//  FLCarouselViewController.h
//  FutLife
//
//  Created by Rene Santis on 10/31/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLViewController.h"
#import "iCarousel.h"

#define CAROUSEL_ITEMS_VIEW @"carouselItemsView"
#define IMAGE_CAROUSEL_TOUCH_VIEW @"imageCarouselTouchView"
#define LABEL_CAROUSEL_VIEW @"imageCarouselTouchView"
#define CAROUSEL_STR @"carousel%ld"

@interface FLCarouselViewController : FLViewController<iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) NSArray *carousels;
@property (strong, nonatomic) NSMutableDictionary *carouselItemsViewDict;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray *indexSelectedItems;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Reload data for all carousels
- (void)carouselsReloadData;

@end
