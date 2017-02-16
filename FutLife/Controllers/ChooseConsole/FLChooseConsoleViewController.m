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


@interface FLChooseConsoleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *consoleCarousel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSMutableArray *selectedConsoles;
@property (strong, nonatomic) UITableView *selectedConsolesTable;
@property (assign, nonatomic, getter=isNavBar) BOOL navBar;

@property (nonatomic, copy) void (^chooseConsoleCompletedBlock)();

@end

@implementation FLChooseConsoleViewController

- (id)initWithNavBar:(BOOL)navBar completedBlock:(void (^)(NSArray *consoleType))chooseConsoleCompletedBlock
{    
    self = [super initWithNibName:@"FLChooseConsoleViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.chooseConsoleCompletedBlock = chooseConsoleCompletedBlock;
        self.navBar = navBar;
    }
    
    return self;
}

- (NSArray *)configCarouselsItemsViews:(NSArray *)consoles
{
    NSMutableArray *carouselsItemsViews = [NSMutableArray array];
    for (FLConsoleModel *console in consoles) {
        
        UIView *imageView = (UIView *)[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_ITEM_WIDTH, VIEW_ITEM_HEIGHT)];
        [((UIImageView *)imageView) setImageWithURL:[NSURL URLWithString:console.avatar] placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
        
        [carouselsItemsViews addObject:imageView];
    }
    
    return carouselsItemsViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = self.navBar;
    
    self.nextButton.enabled = NO;
    self.consoleCarousel.type = iCarouselTypeRotary;
    self.consoleCarousel.bounceDistance = 0.3f;
    self.consoleCarousel.scrollSpeed = 0.3f;
    
    // Let's add carousels items
    self.carousels = @[self.consoleCarousel];
    
    // Request for get consoles
    [self getConsoles];
    
    // Observer when an carousel item is selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCarouselItem:)
                                                 name:kDidSelectCarouselItemNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Add SelectedConsoles
    [self addSelectedConsoles];
}

- (void)addSelectedConsoles
{
    self.selectedConsoles = [[NSMutableArray alloc] init];
    UILabel *selectedConsolesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(self.consoleCarousel.frame) + 40.0f, [FLMiscUtils screenViewFrame].size.width, 20.0f)];
    selectedConsolesLabel.text = @"CONSOLAS SELECCIONADAS:";
    selectedConsolesLabel.font = [UIFont fl_bebasFontOfSize:20.0f];
    selectedConsolesLabel.textColor = [UIColor whiteColor];
    selectedConsolesLabel.textAlignment = NSTextAlignmentLeft;
    
    CGRect selectedConsolesTableFrame = CGRectMake(0, CGRectGetMaxY(selectedConsolesLabel.frame) + 10.0f, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetMaxY(selectedConsolesLabel.frame) + 10.0f);
    self.selectedConsolesTable = [[UITableView alloc] initWithFrame:selectedConsolesTableFrame];
    self.selectedConsolesTable.delegate = self;
    self.selectedConsolesTable.dataSource = self;
    self.selectedConsolesTable.scrollEnabled = NO;
    self.selectedConsolesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectedConsolesTable.backgroundColor = [UIColor clearColor];
    self.selectedConsolesTable.clipsToBounds = NO;
    
    [self.view insertSubview:selectedConsolesLabel belowSubview:self.nextButton];
    [self.view insertSubview:self.selectedConsolesTable belowSubview:self.nextButton];
}

- (void)getConsoles
{
    __weak __typeof(self)weakSelf = self;
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] consolesRequestWithSuccess:^(FLConsoleResponseModel *responseModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [FLAppDelegate hideLoadingHUD];
        if (responseModel) {
            strongSelf.carouselItemsViews[self.consoleCarousel.tag] = [self configCarouselsItemsViews:responseModel.data];
            strongSelf.consoles = responseModel.data;
            
            [FLLocalDataManager sharedInstance].allConsoles = strongSelf.consoles;
            
            // We need to reload data for take all the items
            [strongSelf carouselsReloadData];
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

- (void)didSelectCarouselItem:(NSNotification *)item
{
    self.nextButton.enabled = (self.indexSelectedItems.count > 0);
    
    // Let's update selected tableView
    NSNumber *index = (NSNumber *)item.object;
    NSNumber *indexToDelete = nil;
    NSMutableArray *indexesToReload = [NSMutableArray new];
    FLConsoleModel *console = [self.consoles objectAtIndex:[index integerValue]];
    if ([self.selectedConsoles containsObject:console]) {
        NSInteger indexObject = [self.selectedConsoles indexOfObject:console];
        // Retrive indexes to reload
        for (int i = 0; i < [self.selectedConsoles count]; i++) {
            if (i != indexObject) {
                [indexesToReload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
        
        [self.selectedConsoles removeObject:console];
        indexToDelete = @(indexObject);
    } else {
        [self.selectedConsoles addObject:console];
    }
    
    NSMutableArray *indexPathToInsert = [NSMutableArray array];
    [indexPathToInsert addObject:[NSIndexPath indexPathForRow:[self.selectedConsoles count] - 1 inSection:0]];
    
    [self.selectedConsolesTable beginUpdates];
    
    if (indexToDelete) {
        [self.selectedConsolesTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[indexToDelete integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.selectedConsolesTable reloadRowsAtIndexPaths:indexesToReload withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.selectedConsolesTable insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:UITableViewRowAnimationFade];        
    }
    
    [self.selectedConsolesTable endUpdates];
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedConsoles && [self.selectedConsoles count] > 0) {
        return [self.selectedConsoles count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell) {
        FLConsoleModel *console = [self.selectedConsoles objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fl_bebasFontOfSize:18.0f];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", console.name];
        
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (IBAction)onNextButtonTouch:(id)sender
{
    NSMutableArray *consolesArray = [NSMutableArray new];
    for (NSNumber *item in self.indexSelectedItems) {
        FLConsoleModel *console = [self.consoles objectAtIndex:[item integerValue] - 1];
        [consolesArray addObject:console];
    }
    
    [FLLocalDataManager sharedInstance].consoles = consolesArray;   
    self.chooseConsoleCompletedBlock(consolesArray);
}

- (void)localize
{
    
}

@end
