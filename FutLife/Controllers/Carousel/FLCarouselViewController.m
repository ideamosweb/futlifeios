//
//  FLCarouselViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/31/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCarouselViewController.h"
#define CAROUSEL_STR @"carousel%ld"

@interface FLCarouselViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation FLCarouselViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.carousels = [NSArray new];
        self.carouselItemsViewDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.carousels = [NSArray new];
        self.carouselItemsViewDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    self.selectedItems = [NSMutableArray new];
    self.indexSelectedItems = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setScrollContentSize];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self adjustLayout];
}

- (void)adjustLayout
{
    if (self.carousels.count > 1) {
        self.topConstraint.constant = 50.0;
    }
}

- (void)setScrollContentSize
{
    if (self.carousels.count > 1) {
        UIView *lastView = [self.carousels lastObject];
        CGFloat maxY = CGRectGetMaxY([self.scrollView convertRect:lastView.frame fromView:lastView.superview]);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), maxY);
    }
}

- (void)carouselsReloadData
{
    for (iCarousel *createdCarousel in self.carousels) {
        if (createdCarousel) {
            [createdCarousel reloadData];
        }
    }
}

- (iCarousel *)getCurrentCarouselFrom:(iCarousel *)carousel
{
    for (iCarousel *createdCarousel in self.carousels) {
        if (carousel == createdCarousel) {
            return createdCarousel;
        }
    }
    
    return nil;
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
    
    if (currentCarousel) {
        return [[self.carouselItemsViewDict objectForKey:[NSString stringWithFormat:CAROUSEL_STR, (long)currentCarousel.tag]] count];
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
    
    if (currentCarousel) {
        //create new view if no view is available for recycling
        if (view == nil) {
            view = [self.carouselItemsViewDict objectForKey:[NSString stringWithFormat:CAROUSEL_STR, (long)currentCarousel.tag]][index];
        }
    }
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    UIView *itemView = [carousel itemViewAtIndex:index];
    if ([self checkSelectedItem:index withCarousel:carousel]) {
        /**** TODO: Fix image sizes for selected, this is a workaround ****/
        // Set "selected" state image to a item selected
        NSString *imageName = [(UIImageView *)itemView accessibilityIdentifier];
        if (itemView.frame.size.width > 135.0f) {
            CGRect frame = itemView.frame;
            frame.origin.x = itemView.frame.origin.x - 15.0f;
            frame.origin.y = itemView.frame.origin.y - 15.0f;
            frame.size.width = itemView.frame.size.width + 30;
            frame.size.height = itemView.frame.size.height + 30;
            itemView.frame = frame;
        } else {
            CGRect frame = itemView.frame;
            frame.origin.x = itemView.frame.origin.x - 7.5f;
            frame.origin.y = itemView.frame.origin.y - 11.5f;
            frame.size.width = itemView.frame.size.width + 15;
            frame.size.height = itemView.frame.size.height + 23;
            itemView.frame = frame;
        }
        [((UIImageView *)itemView) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", imageName]]];
        
        [self.indexSelectedItems addObject:@(index + 1)];
        [self.selectedItems addObject:@(index)];
    } else {
        if (self.selectedItems.count > 0) {
            // Back to "normal" steate
            NSString *imageName = [(UIImageView *)itemView accessibilityIdentifier];
            if (itemView.frame.size.width > 150.0f) {
                CGRect frame = itemView.frame;
                frame.origin.x = itemView.frame.origin.x + 15.0f;
                frame.origin.y = itemView.frame.origin.y + 15.0f;
                frame.size.width = itemView.frame.size.width - 30;
                frame.size.height = itemView.frame.size.height - 30;
                itemView.frame = frame;
            } else {
                CGRect frame = itemView.frame;
                frame.origin.x = 0.0;
                frame.origin.y = 0.0;
                frame.size.width = 135.0;
                frame.size.height = 192.0;
                itemView.frame = frame;
            }
            [((UIImageView *)itemView) setImage:[UIImage imageNamed:imageName]];
            
            [self.selectedItems removeObject:@(index)];
            [self.indexSelectedItems removeObject:@(index + 1)];
        }
    }
    
    // Post notification to notify selection of an item
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectCarouselItemNotification
                                                        object:@(index)];
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option) {
        case iCarouselOptionWrap: {
            //normally you would hard-code this to YES or NO
            return NO;
        } case iCarouselOptionSpacing: {
            //add a bit of spacing between the item views
            if (carousel.currentItemView.frame.size.width > 135.0f) {
                return value * 1.3f;
            }
            return value * 1.3f;
        }case iCarouselOptionOffsetMultiplier: {
            return 1.0f;
        } case iCarouselOptionVisibleItems: {
            iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
            
            if (currentCarousel) {
                return [[self.carouselItemsViewDict objectForKey:[NSString stringWithFormat:CAROUSEL_STR, (long)currentCarousel.tag]] count];
            }
            
            return 0.0f;
        } case iCarouselOptionCount: {
            iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
            
            if (currentCarousel) {
                return [[self.carouselItemsViewDict objectForKey:[NSString stringWithFormat:CAROUSEL_STR, (long)currentCarousel.tag]] count] * 4.0f;
            }
            
            return 15.0f;
        } case iCarouselOptionFadeMax: {
            if (carousel.type == iCarouselTypeCustom) {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        } case iCarouselOptionShowBackfaces: {
            return NO;
        } default: {
            return value;
        }
    }
}

- (BOOL)checkSelectedItem:(NSInteger)item withCarousel:(iCarousel *)carousel
{    
    if (![self.selectedItems containsObject:@(item)]) {
        return YES;
    }
    
    return NO;
}

@end
