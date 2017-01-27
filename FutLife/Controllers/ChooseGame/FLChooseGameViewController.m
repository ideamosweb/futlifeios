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
#define CAROUSELS_HEIGHT 330.0f

#define VIEW_ITEM_WIDTH 225.0f
#define VIEW_ITEM_HEIGHT 282.0f

@interface FLChooseGameViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, FLAlertViewProtocol>

@property (weak, nonatomic) IBOutlet UILabel *chooseMoreThanOneGameLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, copy) void (^chooseGameCompletedBlock)();
@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSArray *games;
@property (strong, nonatomic) NSMutableArray *gamesSelected;
@property (strong, nonatomic) NSMutableArray *consolesSelected;
@property (assign, nonatomic, getter=isShowMultipleCarousels) BOOL ShowMultipleCarousels;

@end

@implementation FLChooseGameViewController

- (id)initWithConsoles:(NSArray *)consoles completedBlock:(void (^)(NSArray *consoles, NSArray *games))chooseGameCompletedBlock
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
    
    // For show more than one carousel in view, please turn to YES this property
    self.ShowMultipleCarousels = NO;
    
    [self getGames];
    
    // [self addPickerView];
    
    self.consolesSelected = [NSMutableArray new];
    self.gamesSelected = [NSMutableArray new];
    
    // Observer when an carousel item is selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCarouselItem:)
                                                 name:kDidSelectCarouselItemNotification
                                               object:nil];
}

- (void)createCarouselsWithViewItems:(NSArray *)viewItems
{
    NSMutableArray *carouselsArray = [NSMutableArray new];
    iCarousel *previousCarousel = nil;
    NSInteger numberOfCarousels = (!self.ShowMultipleCarousels) ? 1 : self.consoles.count;
    if (numberOfCarousels) {
        for (int i = 0; i < numberOfCarousels; i++) {
            if (!previousCarousel) {
                iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CAROUSELS_MARGIN_TOP, [FLMiscUtils screenViewFrame].size.width, CAROUSELS_HEIGHT)];
                carousel.type = iCarouselTypeRotary;
                carousel.delegate = self;
                carousel.dataSource = self;
                carousel.bounceDistance = 0.3f;
                carousel.scrollSpeed = 0.3f;
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
                carousel.scrollSpeed = 0.3f;
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
            weakSelf.games = responseModel.data;
            
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
        [((UIImageView *)imageView) setImageWithURL:[NSURL URLWithString:game.avatar] placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
        
        [carouselsItemsViews addObject:imageView];
    }
    
    return carouselsItemsViews;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - iCarousel delegate methods
- (void)didSelectCarouselItem:(NSNotification *)item
{
    NSNumber *index = (NSNumber *)item.object;
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray *consolesName = [NSMutableArray new];
    for (int i = 0; i < [self.consoles count]; i++) {
        FLConsoleModel *console = self.consoles[i];
        [consolesName addObject:console.name];
    }
    
    if (self.consoles.count > 1) {
        if ([self.selectedItems containsObject:index]) {
            [[[FLAlertView alloc] initWithNumberOfOptions:self.consoles.count title:@"Selecciona la consola" optionsText:consolesName optionsOn:nil buttonTitles:@[@"Aceptar"] buttonTypes:@[] delegate:self clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                FLGameModel *game = [strongSelf.games objectAtIndex:[index integerValue]];
                
                if ([strongSelf.consolesSelected count] > 0) {
                    game.consoles = [strongSelf.consolesSelected mutableCopy];
                    [strongSelf.gamesSelected addObject:game];
                    
                    strongSelf.nextButton.enabled = (strongSelf.indexSelectedItems.count > 0);
                    
                    [strongSelf.consolesSelected removeAllObjects];
                } else {
                    iCarousel *carousel = strongSelf.carousels[0];
                    [strongSelf carousel:carousel didSelectItemAtIndex:[index integerValue]];
                }
            }] show];
        } else {
            FLGameModel *game = [self.games objectAtIndex:[index integerValue]];
            if ([self.gamesSelected containsObject:game]) {
                [self.gamesSelected removeObject:game];
            }
            
            self.nextButton.enabled = (self.indexSelectedItems.count > 0 && [self.consolesSelected count] > 0);
            
            [self.consolesSelected removeAllObjects];
        }
    } else if (self.consoles.count == 1) {
        FLGameModel *game = [self.games objectAtIndex:[index integerValue]];
        game.consoles = self.consoles;
        [self.gamesSelected addObject:game];
        
        self.nextButton.enabled = (self.indexSelectedItems.count > 0);
    }
}

- (void)addPickerView
{
    UIPickerView *consolesPickerView = [[UIPickerView alloc] init];
    consolesPickerView.delegate = self;
    consolesPickerView.dataSource = self;
    
    [self.view addSubview:consolesPickerView];
}

#pragma mark - UIPickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.consoles count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    FLConsoleModel *console = self.consoles[row];
    return console.name;
}



- (IBAction)onNextButtonTouch:(id)sender
{
    [FLLocalDataManager sharedInstance].games = self.gamesSelected;
    self.chooseGameCompletedBlock(self.consoles, self.gamesSelected);
    
}

- (void)localize
{
    
}

#pragma mark - FLAlertView protocol methods

- (void)onSelectConsoleSwitch:(id)sender
{
    ASSERT_CLASS(sender, UISwitch);
    FLConsoleModel *console = nil;
    UISwitch *switchView = (UISwitch *)sender;
    if ([self.consoles objectAtIndex:switchView.tag - 1] != [NSNull null]) {
        console = [self.consoles objectAtIndex:switchView.tag - 1];
    }
    
    if (switchView.isOn) {
        if (console) {
            if (![self.consolesSelected containsObject:console]) {
                [self.consolesSelected addObject:console];
            }
        }
    } else {
        if (console) {
            if ([self.consolesSelected containsObject:console]) {
                [self.consolesSelected removeObject:console];
            }
        }
    }
}

@end
