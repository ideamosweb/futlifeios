//
//  FLChooseGameViewController.m
//  FutLife
//
//  Created by Rene Santis on 11/2/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLChooseGameViewController.h"
#define CAROUSELS_MARGIN_TOP 10.0f
#define CAROUSELS_PADDING 0.0f
#define CAROUSELS_HEIGHT 240.0f

@interface FLChooseGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chooseMorethan1Game;

@property (nonatomic, copy) void (^chooseGameCompletedBlock)();
@property (strong, nonatomic) NSArray *consoles;

@end

@implementation FLChooseGameViewController

- (id)initWithConsoles:(NSArray *)consoles completedBlock:(void (^)())chooseGameCompletedBlock
{
    self = [super initWithNibName:@"FLChooseGameViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.chooseGameCompletedBlock = chooseGameCompletedBlock;
        self.consoles = consoles;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    [self createCarousels];
    
    // We need to reload data for take all the items
    [self carouselsReloadData];
}

- (void)createCarousels
{
    NSMutableArray *carouselsArray = [NSMutableArray new];
    iCarousel *previousCarousel = nil;
    if (self.consoles.count > 0) {
        for (int i = 0; i < self.consoles.count; i++) {
            if (!previousCarousel) {
                iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CAROUSELS_MARGIN_TOP, [FLMiscUtils screenViewFrame].size.width, CAROUSELS_HEIGHT)];
                carousel.type = iCarouselTypeRotary;
                carousel.delegate = self;
                carousel.dataSource = self;
                carousel.bounceDistance = 0.3f;
                carousel.tag = [self.consoles[i] integerValue];
                [self.carouselItemsViewDict setObject:[self configCarouselsItemsViewsWithConsoleType:carousel.tag] forKey:[NSString stringWithFormat:CAROUSEL_STR, (long)carousel.tag]];
                
                previousCarousel = carousel;
                [carouselsArray addObject:carousel];
                [self.scrollView addSubview:carousel];
            } else {
                iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previousCarousel.frame) + CAROUSELS_PADDING, [FLMiscUtils screenViewFrame].size.width, CAROUSELS_HEIGHT)];
                carousel.type = iCarouselTypeRotary;
                carousel.delegate = self;
                carousel.dataSource = self;
                carousel.bounceDistance = 0.3f;
                carousel.tag = [self.consoles[i] integerValue];
                [self.carouselItemsViewDict setObject:[self configCarouselsItemsViewsWithConsoleType:carousel.tag] forKey:[NSString stringWithFormat:CAROUSEL_STR, (long)carousel.tag]];
                
                previousCarousel = carousel;
                [carouselsArray addObject:carousel];
                
                [self.scrollView addSubview:carousel];
            }
        }
    }
    
    // Let's add carousels for config
    self.carousels = carouselsArray;
    
}

- (NSArray *)configCarouselsItemsViewsWithConsoleType:(FLConsoleTypes)consoleType
{
    UIView *imageView1 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    UIView *imageView2 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    UIView *imageView3 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    UIView *imageView4 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    UIView *imageView5 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    UIView *imageView6 = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135.0f, 192.0f)];
    
    switch (consoleType) {
        case FLConsolePlayStationS3:
            ((UIImageView *)imageView1).image = [UIImage imageNamed:@"icon_fifa15_ps3"];
            [imageView1 setAccessibilityIdentifier:@"icon_fifa15_ps3"];
            ((UIImageView *)imageView2).image = [UIImage imageNamed:@"icon_fifa16_ps3"];
            [imageView2 setAccessibilityIdentifier:@"icon_fifa16_ps3"];
            ((UIImageView *)imageView3).image = [UIImage imageNamed:@"icon_fifa17_ps3"];
            [imageView3 setAccessibilityIdentifier:@"icon_fifa17_ps3"];
            ((UIImageView *)imageView4).image = [UIImage imageNamed:@"icon_pes15_ps3"];
            [imageView4 setAccessibilityIdentifier:@"icon_pes15_ps3"];
            ((UIImageView *)imageView5).image = [UIImage imageNamed:@"icon_pes16_ps3"];
            [imageView5 setAccessibilityIdentifier:@"icon_pes16_ps3"];
            ((UIImageView *)imageView6).image = [UIImage imageNamed:@"icon_pes17_ps3"];
            [imageView6 setAccessibilityIdentifier:@"icon_pes17_ps3"];
            
            break;
            
        case FLConsolePlayStation4:
            ((UIImageView *)imageView1).image = [UIImage imageNamed:@"icon_fifa15_ps4"];
            [imageView1 setAccessibilityIdentifier:@"icon_fifa15_ps4"];
            ((UIImageView *)imageView2).image = [UIImage imageNamed:@"icon_fifa16_ps4"];
            [imageView2 setAccessibilityIdentifier:@"icon_fifa16_ps4"];
            ((UIImageView *)imageView3).image = [UIImage imageNamed:@"icon_fifa17_ps4"];
            [imageView3 setAccessibilityIdentifier:@"icon_fifa17_ps4"];
            ((UIImageView *)imageView4).image = [UIImage imageNamed:@"icon_pes15_ps4"];
            [imageView4 setAccessibilityIdentifier:@"icon_pes15_ps4"];
            ((UIImageView *)imageView5).image = [UIImage imageNamed:@"icon_pes16_ps4"];
            [imageView5 setAccessibilityIdentifier:@"icon_pes16_ps4"];
            ((UIImageView *)imageView6).image = [UIImage imageNamed:@"icon_pes17_ps4"];
            [imageView6 setAccessibilityIdentifier:@"icon_pes17_ps4"];
            
            break;
            
        case FLConsoleXbox360:
            ((UIImageView *)imageView1).image = [UIImage imageNamed:@"icon_fifa15_xbox360"];
            [imageView1 setAccessibilityIdentifier:@"icon_fifa15_xbox360"];
            ((UIImageView *)imageView2).image = [UIImage imageNamed:@"icon_fifa16_xbox360"];
            [imageView2 setAccessibilityIdentifier:@"icon_fifa16_xbox360"];
            ((UIImageView *)imageView3).image = [UIImage imageNamed:@"icon_fifa17_xbox360"];
            [imageView3 setAccessibilityIdentifier:@"icon_fifa17_xbox360"];
            ((UIImageView *)imageView4).image = [UIImage imageNamed:@"icon_pes15_xbox360"];
            [imageView4 setAccessibilityIdentifier:@"icon_pes15_xbox360"];
            ((UIImageView *)imageView5).image = [UIImage imageNamed:@"icon_pes16_xbox360"];
            [imageView5 setAccessibilityIdentifier:@"icon_pes16_xbox360"];
            ((UIImageView *)imageView6).image = [UIImage imageNamed:@"icon_pes17_xbox360"];
            [imageView6 setAccessibilityIdentifier:@"icon_pes17_xbox360"];
            
            break;
            
        case FLConsoleXboxOne:
            ((UIImageView *)imageView1).image = [UIImage imageNamed:@"icon_fifa15_xboxOne"];
            [imageView1 setAccessibilityIdentifier:@"icon_fifa15_xboxOne"];
            ((UIImageView *)imageView2).image = [UIImage imageNamed:@"icon_fifa16_xboxOne"];
            [imageView2 setAccessibilityIdentifier:@"icon_fifa16_xboxOne"];
            ((UIImageView *)imageView3).image = [UIImage imageNamed:@"icon_fifa17_xboxOne"];
            [imageView3 setAccessibilityIdentifier:@"icon_fifa17_xboxOne"];
            ((UIImageView *)imageView4).image = [UIImage imageNamed:@"icon_pes15_xboxOne"];
            [imageView4 setAccessibilityIdentifier:@"icon_pes15_xboxOne"];
            ((UIImageView *)imageView5).image = [UIImage imageNamed:@"icon_pes16_xboxOne"];
            [imageView5 setAccessibilityIdentifier:@"icon_pes16_xboxOne"];
            ((UIImageView *)imageView6).image = [UIImage imageNamed:@"icon_pes17_xboxOne"];
            [imageView6 setAccessibilityIdentifier:@"icon_pes17_xboxOne"];
            
            break;
            
        default:
            break;
    }
    
    return @[imageView1, imageView2, imageView3, imageView4, imageView5, imageView6];
}

- (void)localize
{
    
}

@end
