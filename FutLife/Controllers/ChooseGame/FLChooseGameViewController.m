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

#define VIEW_ITEM_WIDTH 135.0f
#define VIEW_ITEM_HEIGHT 192.0f

@interface FLChooseGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chooseMoreThanOneGameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

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
    
    self.nextButton.enabled = NO;
    
    [self getGames];
    
    // Observer when an carousel item is selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCarouselItem)
                                                 name:kDidSelectCarouselItemNotification
                                               object:nil];
}

- (void)createCarouselsWithViewItems:(NSArray *)viewItems
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
                carousel.tag = i;
                self.carouselItemsViews[carousel.tag] = [self configCarouselsViewsItems:viewItems];
                
                previousCarousel = carousel;
                [carouselsArray addObject:carousel];
                [self.scrollView addSubview:carousel];
            } else {
                iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(previousCarousel.frame) + CAROUSELS_PADDING, [FLMiscUtils screenViewFrame].size.width, CAROUSELS_HEIGHT)];
                carousel.type = iCarouselTypeRotary;
                carousel.delegate = self;
                carousel.dataSource = self;
                carousel.bounceDistance = 0.3f;
                carousel.tag = i;
                self.carouselItemsViews[carousel.tag] = [self configCarouselsViewsItems:viewItems];
                
                previousCarousel = carousel;
                [carouselsArray addObject:carousel];
                
                [self.scrollView addSubview:carousel];
            }
        }
    }
    
    // Let's add carousels for config
    self.carousels = carouselsArray;
}

- (void)getGames
{
    __weak FLChooseGameViewController *weakSelf = self;
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] gamesRequestWithSuccess:^(FLGameResponseModel *responseModel) {
        [FLAppDelegate hideLoadingHUD];
        if (responseModel) {
            [weakSelf createCarouselsWithViewItems:responseModel.data];
            
            // We need to reload data for take all the items
            [weakSelf carouselsReloadData];
        }
    } failure:^(FLApiError *error) {
        [FLAppDelegate hideLoadingHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (NSArray *)configCarouselsViewsItems:(NSArray *)viewsItems
{
    NSMutableArray *carouselsItemsViews = [NSMutableArray array];
    for (FLGameModel *game in viewsItems) {
        
        UIView *imageView = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
        [((UIImageView *)imageView) setImageWithURL:[NSURL URLWithString:game.avatar] placeholderImage:nil];
        
        [carouselsItemsViews addObject:imageView];
    }
    
    return carouselsItemsViews;
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
    
}

- (void)localize
{
    
}

@end
