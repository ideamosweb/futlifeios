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
        self.carouselItemsViews = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.carousels = [NSArray new];
        self.carouselItemsViews = [NSMutableArray new];
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
        return [self.carouselItemsViews[currentCarousel.tag] count];
    }
    
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
    
    if (currentCarousel) {
        //create new view if no view is available for recycling
        if (view == nil) {
            view = self.carouselItemsViews[currentCarousel.tag][index];
        }
    }
    
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    UIView *itemView = [carousel itemViewAtIndex:index];
    if ([self checkSelectedItem:index withCarousel:carousel]) {
        // Set yellow shadow to itemView
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:itemView.bounds];
        itemView.layer.masksToBounds = NO;
        itemView.layer.shadowColor = [UIColor yellowColor].CGColor;
        itemView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        itemView.layer.shadowOpacity = 0.5f;
        itemView.layer.shadowPath = shadowPath.CGPath;
        
        [self.indexSelectedItems addObject:@(index + 1)];
        [self.selectedItems addObject:@(index)];
    } else {
        // Back to "normal" steate
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:itemView.bounds];
        itemView.layer.masksToBounds = NO;
        itemView.layer.shadowColor = [UIColor clearColor].CGColor;
        itemView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        itemView.layer.shadowOpacity = 0.5f;
        itemView.layer.shadowPath = shadowPath.CGPath;
        
        [self.selectedItems removeObject:@(index)];
        [self.indexSelectedItems removeObject:@(index + 1)];
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
            return value * 1.3f;
        }case iCarouselOptionOffsetMultiplier: {
            return 1.0f;
        } case iCarouselOptionVisibleItems: {
            iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
            
            if (currentCarousel && [self.carouselItemsViews count] > 0) {
                return [self.carouselItemsViews[currentCarousel.tag] count];
            }
            
            return 0.0f;
        } case iCarouselOptionCount: {
            iCarousel *currentCarousel = [self getCurrentCarouselFrom:carousel];
            
            if (currentCarousel && [self.carouselItemsViews count] > 0) {
                return [self.carouselItemsViews[currentCarousel.tag] count] * 3.0f;
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
