//
//  FLChooseConsoleViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/31/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLChooseConsoleViewController.h"

#define VIEW_ITEM_WIDTH 240.0f
#define VIEW_ITEM_HEIGHT 220.0f


@interface FLChooseConsoleViewController ()

@property (weak, nonatomic) IBOutlet iCarousel *consoleCarousel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, copy) void (^chooseConsoleCompletedBlock)();

@end

@implementation FLChooseConsoleViewController

- (id)initWithCompletedBlock:(void (^)(NSArray *consoleType))chooseConsoleCompletedBlock
{    
    self = [super initWithNibName:@"FLChooseConsoleViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        [self.carouselItemsViewDict setObject:[self configCarouselsItemsViews] forKey:[NSString stringWithFormat:CAROUSEL_STR, (long)1]];
        
        self.chooseConsoleCompletedBlock = chooseConsoleCompletedBlock;
    }
    
    return self;
}

- (NSArray *)configCarouselsItemsViews
{
    UIView *imageView1 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
    ((UIImageView *)imageView1).image = [UIImage imageNamed:@"icon_PS3_console"];
    [imageView1 setAccessibilityIdentifier:@"icon_PS3_console"];
    //imageView1.contentMode = UIViewContentModeCenter;
    
    UIView *imageView2 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
    ((UIImageView *)imageView2).image = [UIImage imageNamed:@"icon_PS4_console"];
    [imageView2 setAccessibilityIdentifier:@"icon_PS4_console"];
    //imageView2.contentMode = UIViewContentModeCenter;
    
    UIView *imageView3 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
    ((UIImageView *)imageView3).image = [UIImage imageNamed:@"icon_xbox360_console"];
    [imageView3 setAccessibilityIdentifier:@"icon_xbox360_console"];
    //imageView3.contentMode = UIViewContentModeCenter;
    
    UIView *imageView4 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
    ((UIImageView *)imageView4).image = [UIImage imageNamed:@"icon_xboxOne_console"];
    [imageView4 setAccessibilityIdentifier:@"icon_xboxOne_console"];
    //imageView4.contentMode = UIViewContentModeCenter;
    
    
    
    return @[imageView1, imageView2, imageView3, imageView4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    self.nextButton.enabled = NO;
    self.consoleCarousel.type = iCarouselTypeRotary;
    self.consoleCarousel.bounceDistance = 0.3f;
    self.carousels = @[self.consoleCarousel];
    
    // We need to reload data for take all the items
    [self carouselsReloadData];
    
    // Observer when an carousel item is selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCarouselItem)
                                                 name:kDidSelectCarouselItemNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didSelectCarouselItem
{
    self.nextButton.enabled = (self.indexSelectedItems.count > 0);
}

- (IBAction)onNextButtonTouch:(id)sender
{
    self.chooseConsoleCompletedBlock(self.indexSelectedItems);
}

- (void)localize
{
    
}

@end
