//
//  FLChooseConsoleViewController.m
//  FutLife
//
//  Created by Rene Santis on 10/31/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLChooseConsoleViewController.h"
#import "FLConsoleModel.h"

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
        self.chooseConsoleCompletedBlock = chooseConsoleCompletedBlock;
    }
    
    return self;
}

- (NSArray *)configCarouselsItemsViews:(NSArray *)consoles
{
    NSMutableArray *carouselsItemsViews = [NSMutableArray array];
    for (FLConsoleModel *console in consoles) {
        
        UIView *imageView = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
        [((UIImageView *)imageView) setImageWithURL:[NSURL URLWithString:console.avatar] placeholderImage:nil];
        
        [carouselsItemsViews addObject:imageView];
    }
    
    return carouselsItemsViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    self.nextButton.enabled = NO;
    self.consoleCarousel.type = iCarouselTypeRotary;
    self.consoleCarousel.bounceDistance = 0.3f;
    
    // Let's add carousels items
    self.carousels = @[self.consoleCarousel];
    
    // Request for get consoles
    [self getConsoles];
    
    // Observer when an carousel item is selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCarouselItem)
                                                 name:kDidSelectCarouselItemNotification
                                               object:nil];
}

- (void)getConsoles
{
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] consolesRequestWithSuccess:^(FLConsoleResponseModel *responseModel) {
        [FLAppDelegate hideLoadingHUD];
        if (responseModel) {
            self.carouselItemsViews[self.consoleCarousel.tag] = [self configCarouselsItemsViews:responseModel.data];
            
            // We need to reload data for take all the items
            [self carouselsReloadData];
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
