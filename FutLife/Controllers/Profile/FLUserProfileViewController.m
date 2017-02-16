//
//  FLUserProfileViewController.m
//  FutLife
//
//  Created by Rene Santis on 2/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUserProfileViewController.h"
#import "BLKFlexibleHeightBar.h"
#import "SquareCashStyleBehaviorDefiner.h"

#import "FLUserProfileCell.h"
#import "FacebookStyleBarBehaviorDefiner.h"

#define USERNAME_LABEL_Y_POSITION ((int) 80)

@interface FLUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) FLUserModel *user;
@property (strong, nonatomic) NSMutableArray *consoles;
@property (strong, nonatomic) NSMutableArray *games;
@property (strong, nonatomic) UIScrollView *tabsContainerScroll;
@property (strong, nonatomic) UIView *selectedButtonView;
@property (strong, nonatomic) UIButton *consolesButton;
@property (strong, nonatomic) UIButton *gamesButton;

@property (strong, nonatomic) UITableView *consolesTableView;
@property (strong, nonatomic) UITableView *gamesTableView;

@end

@implementation FLUserProfileViewController

- (id)initWithUser:(FLUserModel *)userModel Avatar:(UIImage *)avatar name:(NSString *)name userName:(NSString *)userName
{
    self = [super init];
    if (self) {
        self.avatar = avatar;
        self.name = name;
        self.userName = userName;
        self.user = userModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height)];
    scrollView.contentSize = CGSizeMake([FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height + 190.0f);
    [self.view addSubview:scrollView];
    scrollView.bounces = NO;
    
    /********** FLEXIBLE NAV-BAR ***********/
    BLKFlexibleHeightBar *myBar = [[BLKFlexibleHeightBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 320.0)];
    myBar.minimumBarHeight = 64.0f;
    myBar.behaviorDefiner = [SquareCashStyleBehaviorDefiner new];
    
    scrollView.delegate = (id<UIScrollViewDelegate>)myBar.behaviorDefiner;
    
    /************* NAVBAR VIEW **************/
    CGRect navBarHeaderFrame = CGRectMake(0.0, 0.0, [FLMiscUtils screenViewFrame].size.width, 64.0f);
    UIView *navBar = [[UIView alloc] initWithFrame:navBarHeaderFrame];
    navBar.backgroundColor = [UIColor colorWithRed:0.4f/255.0f green:21.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    
    [myBar addSubview:navBar];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForNB = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForNB.size = navBar.frame.size;
    initialLayoutAttributesForNB.center = CGPointMake(187.0f, 32.0f);
    initialLayoutAttributesForNB.alpha = 0.0f;
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [navBar addLayoutAttributes:initialLayoutAttributesForNB forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForNB = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForNB];
    finalLayoutAttributesForNB.alpha = 1.0f;
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [navBar addLayoutAttributes:finalLayoutAttributesForNB forProgress:1.0];
    
    /************* BACKGROUND BAR IMAGE **************/
    UIImage *bgBarImage = [UIImage imageNamed:@"headerFlexNavBg_curve"];
    
    UIImageView *bgBarImageView = [[UIImageView alloc] initWithFrame:myBar.frame];
    bgBarImageView.image = bgBarImage;
    
    bgBarImageView.layer.cornerRadius = 100.0f;
    
    [myBar addSubview:bgBarImageView];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForBG = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForBG.size = bgBarImageView.frame.size;
    initialLayoutAttributesForBG.center = CGPointMake(CGRectGetMidX(myBar.bounds), CGRectGetMidY(myBar.bounds));    
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [bgBarImageView addLayoutAttributes:initialLayoutAttributesForBG forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *middleLayoutAttributesForBG = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForBG];
    middleLayoutAttributesForBG.alpha = 0.7f;
    CGAffineTransform translationMiddleForBG = CGAffineTransformMakeTranslation(0.0, -140.0);
    CGAffineTransform scaleMiddleForBG = CGAffineTransformMakeScale(1.0, 0.3);
    middleLayoutAttributesForBG.transform = CGAffineTransformConcat(scaleMiddleForBG, translationMiddleForBG);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [bgBarImageView addLayoutAttributes:middleLayoutAttributesForBG forProgress:0.7];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForBG = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForBG];
    finalLayoutAttributesForBG.alpha = 0.0f;
    CGAffineTransform translationForBG = CGAffineTransformMakeTranslation(0.0, -140.0);
    CGAffineTransform scaleForBG = CGAffineTransformMakeScale(1.0, 0.3);
    finalLayoutAttributesForBG.transform = CGAffineTransformConcat(scaleForBG, translationForBG);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [bgBarImageView addLayoutAttributes:finalLayoutAttributesForBG forProgress:1.0];
    
    /*********** AVATAR IMAGE *************/
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX([FLMiscUtils screenViewFrame]), 0.0f, 150.0f, 150.0f)];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [avatar setImage:self.avatar];
    [avatar fl_MakeCircularView];
    [myBar addSubview:avatar];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForAvatar = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForAvatar.size = avatar.frame.size;
    initialLayoutAttributesForAvatar.center = CGPointMake(CGRectGetMidX(myBar.bounds), 140.0);
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [avatar addLayoutAttributes:initialLayoutAttributesForAvatar forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForAvatar = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForAvatar];
    finalLayoutAttributesForAvatar.alpha = 0.0;
    CGAffineTransform translationForAvatar = CGAffineTransformMakeTranslation(0.0, -100.0);
    CGAffineTransform scaleForAvatar = CGAffineTransformMakeScale(0.2, 0.2);
    finalLayoutAttributesForAvatar.transform = CGAffineTransformConcat(scaleForAvatar, translationForAvatar);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [avatar addLayoutAttributes:finalLayoutAttributesForAvatar forProgress:1.0];
    
    /************** USERNAME LABEL ****************/
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = self.userName;
    userNameLabel.font = [UIFont fl_bebasFontOfSize:27];
    userNameLabel.textColor = [UIColor whiteColor];
    [userNameLabel sizeToFit];
    [myBar addSubview:userNameLabel];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForUserName = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForUserName.size = userNameLabel.frame.size;
    initialLayoutAttributesForUserName.center = CGPointMake(CGRectGetMidX(myBar.bounds), CGRectGetHeight(myBar.bounds) - USERNAME_LABEL_Y_POSITION);
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [userNameLabel addLayoutAttributes:initialLayoutAttributesForUserName forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForUserName = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForUserName];
    //finalLayoutAttributes.alpha = 0.0;
    CGAffineTransform translationForUserName = CGAffineTransformMakeTranslation(0.0, -myBar.frame.size.height + userNameLabel.frame.size.height + 90.0f);
    CGAffineTransform scaleForUserName = CGAffineTransformMakeScale(0.7, 0.7);
    finalLayoutAttributesForUserName.transform = CGAffineTransformConcat(scaleForUserName, translationForUserName);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [userNameLabel addLayoutAttributes:finalLayoutAttributesForUserName forProgress:1.0];
    
    /**************** NAME LABEL ******************/
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.name;
    nameLabel.font = [UIFont fl_bebasFontOfSize:24];
    nameLabel.textColor = [UIColor lightGrayColor];
    [nameLabel sizeToFit];
    [myBar addSubview:nameLabel];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForName = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForName.size = nameLabel.frame.size;
    initialLayoutAttributesForName.center = CGPointMake(CGRectGetMidX(myBar.bounds), CGRectGetHeight(myBar.bounds) - USERNAME_LABEL_Y_POSITION + 30.0f);
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [nameLabel addLayoutAttributes:initialLayoutAttributesForName forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForName = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForName];
    finalLayoutAttributesForName.alpha = 0.0;
    CGAffineTransform translationForName = CGAffineTransformMakeTranslation(0.0, -250.0f);
    CGAffineTransform scaleForName = CGAffineTransformMakeScale(0.7, 0.7);
    finalLayoutAttributesForName.transform = CGAffineTransformConcat(scaleForName, translationForName);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [nameLabel addLayoutAttributes:finalLayoutAttributesForName forProgress:1.0];
    
    /**************** PERCENTAGE LABEL *****************/
    UILabel *percentageLabel = [[UILabel alloc] init];
    percentageLabel.text = @"40%";
    percentageLabel.font = [UIFont fl_bebasFontOfSize:22];
    percentageLabel.textColor = [UIColor orangeColor];
    [percentageLabel sizeToFit];
    [myBar addSubview:percentageLabel];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialLayoutAttributesForPercentage = [BLKFlexibleHeightBarSubviewLayoutAttributes new];
    initialLayoutAttributesForPercentage.size = percentageLabel.frame.size;
    initialLayoutAttributesForPercentage.center = CGPointMake(CGRectGetMidX(myBar.bounds), CGRectGetHeight(myBar.bounds) - USERNAME_LABEL_Y_POSITION + 60.0f);
    
    // This is what we want the bar to look like at its maximum height (progress == 0.0)
    [percentageLabel addLayoutAttributes:initialLayoutAttributesForPercentage forProgress:0.0];
    
    // Create a final set of layout attributes based on the same values as the initial layout attributes
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalLayoutAttributesForPercentage = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialLayoutAttributesForPercentage];
    finalLayoutAttributesForPercentage.alpha = 0.0;
    CGAffineTransform translationForPercentage = CGAffineTransformMakeTranslation(0.0, -250.0f);
    CGAffineTransform scaleForPercentage = CGAffineTransformMakeScale(0.7, 0.7);
    finalLayoutAttributesForPercentage.transform = CGAffineTransformConcat(scaleForPercentage, translationForPercentage);
    
    // This is what we want the bar to look like at its minimum height (progress == 1.0)
    [percentageLabel addLayoutAttributes:finalLayoutAttributesForPercentage forProgress:1.0];
    
    //myBar.backgroundColor = [UIColor colorWithRed:0.86 green:0.25 blue:0.23 alpha:1];
    [self.view addSubview:myBar];
    
    [self createTabsWithBar:myBar scrollView:scrollView];
    
    UIButton *challengeButton = [[UIButton alloc] initWithFrame:CGRectMake(([FLMiscUtils screenViewFrame].size.width / 2) - 25.0f, [FLMiscUtils screenViewFrame].size.height - 60.0f, 50.0f, 50.0f)];
    [challengeButton setImage:[UIImage imageNamed:@"user_challenge_icon"] forState:UIControlStateNormal];
    
    [self.view addSubview:challengeButton];
}

- (void)createTabsWithBar:(BLKFlexibleHeightBar *)myBar scrollView:(UIScrollView *)scrollView
{
    self.consolesButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [FLMiscUtils screenViewFrame].size.width / 2, 50.0f)];
    [self.consolesButton setImage:[UIImage imageNamed:@"user_view_consoles_icon"] forState:UIControlStateNormal];
    [self.consolesButton addTarget:self action:@selector(onConsolesButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.consolesButton.frame) + 5.0f, [FLMiscUtils screenViewFrame].size.width / 2, 22.0f)];
    label1.font = [UIFont fl_bebasFontOfSize:15.0];
    label1.text = @"Consolas";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor darkGrayColor];
    
    UIView *separatorVerticalView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.consolesButton.frame), 10.0f, 2.0f, 50.0f)];
    separatorVerticalView.backgroundColor = [UIColor lightGrayColor];
    
    self.gamesButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.consolesButton.frame), 0.0f, [FLMiscUtils screenViewFrame].size.width / 2, 50.0f)];
    [self.gamesButton setImage:[UIImage imageNamed:@"user_view_games_icon"] forState:UIControlStateNormal];
    [self.gamesButton addTarget:self action:@selector(onGamesButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(label1.frame), CGRectGetHeight(self.gamesButton.frame) + 5.0f, [FLMiscUtils screenViewFrame].size.width / 2, 22.0f)];
    label2.font = [UIFont fl_bebasFontOfSize:15.0];
    label2.text = @"Juegos";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor darkGrayColor];
    
    CGRect tabsViewFrame = CGRectMake(0.0f, CGRectGetHeight(myBar.frame) - 55.0f, [FLMiscUtils screenViewFrame].size.width, 80.0f);
    UIView *tabsView = [[UIView alloc] initWithFrame:tabsViewFrame];
    
    self.selectedButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(label1.frame), CGRectGetWidth(self.consolesButton.frame), 4.0f)];
    self.selectedButtonView.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:164.0f/255.0f blue:36.0f/155.0f alpha:1.0f];
    
    UIView *separatorHorizontalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMinY(self.selectedButtonView.frame), CGRectGetWidth(tabsView.frame), 1.0f)];
    separatorHorizontalView.backgroundColor = [UIColor lightGrayColor];
    
    [tabsView addSubview:self.consolesButton];
    [tabsView addSubview:self.gamesButton];
    [tabsView addSubview:label1];
    [tabsView addSubview:label2];
    [tabsView addSubview:separatorVerticalView];
    [tabsView addSubview:self.selectedButtonView];
    
    [scrollView addSubview:tabsView];
    
    self.tabsContainerScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(tabsView.frame), [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(myBar.frame))];
    self.tabsContainerScroll.bounces = NO;
    
    CGRect consolesTableViewFrame = CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(myBar.frame) - 20.0f);
    
    self.consolesTableView = [[UITableView alloc] initWithFrame:consolesTableViewFrame];
    self.consolesTableView.backgroundColor = [UIColor clearColor];
    UIView *bgTableView = [[UIView alloc] initWithFrame:consolesTableViewFrame];
    UIImageView *bgTableViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(bgTableView.frame), CGRectGetHeight(bgTableView.frame))];
    bgTableViewImage.image = [UIImage imageNamed:@"background-green"];
    [bgTableView addSubview:bgTableViewImage];
    
    //consolesTableView.backgroundView = bgTableView;
    self.consolesTableView.delegate = self;
    self.consolesTableView.dataSource = self;
    self.consolesTableView.scrollEnabled = NO;
    self.consolesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.consolesTableView.clipsToBounds = NO;
    [self.consolesTableView registerNib:[FLUserProfileCell nib] forCellReuseIdentifier:[FLUserProfileCell cellIdentifier]];
    
    CGRect gamesTableViewFrame = CGRectMake(CGRectGetWidth(self.consolesTableView.frame), 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(myBar.frame) - 20.0f);
    
    self.gamesTableView = [[UITableView alloc] initWithFrame:gamesTableViewFrame];
    self.gamesTableView.backgroundColor = [UIColor clearColor];
    self.gamesTableView.delegate = self;
    self.gamesTableView.dataSource = self;
    self.gamesTableView.scrollEnabled = NO;
    self.gamesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gamesTableView.clipsToBounds = NO;
    [self.gamesTableView registerNib:[FLUserProfileCell nib] forCellReuseIdentifier:[FLUserProfileCell cellIdentifier]];
    
    [self.tabsContainerScroll addSubview:self.consolesTableView];
    [self.tabsContainerScroll addSubview:self.gamesTableView];
    self.tabsContainerScroll.contentSize = CGSizeMake(CGRectGetWidth(self.consolesTableView.frame) * 2, CGRectGetHeight(self.consolesTableView.frame));
    
    [scrollView addSubview:self.tabsContainerScroll];
    
    self.consoles = [NSMutableArray new];
    self.games = [NSMutableArray new];
    
    NSArray *userPreferences = self.user.preferences;
    FLRegisterPreferencesModel *preference1 = [userPreferences objectAtIndex:0];
    FLConsoleModel *console1 = [[FLConsoleModel new] getConsoleById:preference1.consoleId];
    FLGameModel *game1 = [[FLGameModel new] getGameById:preference1.gameId];
    [self.consoles addObject:console1];
    [self.games addObject:game1];
    for (int i = 1; i < userPreferences.count; i++) {
        FLRegisterPreferencesModel *preference = [userPreferences objectAtIndex:i];
        if (preference.consoleId != preference1.consoleId) {
            FLConsoleModel *console = [[FLConsoleModel new] getConsoleById:preference.consoleId];
            [self.consoles addObject:console];
        }
        
        if (preference.gameId != preference1.gameId) {
            FLGameModel *game = [[FLGameModel new] getGameById:preference.gameId];
            [self.games addObject:game];
        }
    }

}

- (void)onConsolesButtonTouch:(id)sender
{
    CGPoint point = CGPointMake(CGRectGetMinX(self.consolesTableView.frame), 0.0f);
    [self.tabsContainerScroll setContentOffset:point animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selectedButtonViewFrame = self.selectedButtonView.frame;
        selectedButtonViewFrame.origin.x = CGRectGetMinX(self.consolesButton.frame);
        self.selectedButtonView.frame = selectedButtonViewFrame;
    }];
}

- (void)onGamesButtonTouch:(id)sender
{
    CGPoint point = CGPointMake(CGRectGetMinX(self.gamesTableView.frame), 0.0f);
    [self.tabsContainerScroll setContentOffset:point animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selectedButtonViewFrame = self.selectedButtonView.frame;
        selectedButtonViewFrame.origin.x = CGRectGetMinX(self.gamesButton.frame);
        self.selectedButtonView.frame = selectedButtonViewFrame;
    }];
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 1) {
//        return self.user.preferences.count;
//    }
//    
//    return self.consoles.count
    
    if (tableView == self.consolesTableView) {
        return self.consoles.count;
    }
    
    return self.games.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"Consolas";
//    }
//    
//    return @"Juegos";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLUserProfileCell cellIdentifier]];
    if (cell) {
        FLRegisterPreferencesModel *preferences = [self.user.preferences objectAtIndex:indexPath.row];
        FLConsoleModel *console = [[FLConsoleModel new] getConsoleById:preferences.consoleId];
        FLGameModel *game = [[FLGameModel new] getGameById:preferences.gameId];
        
        NSString *avatar = (tableView == self.consolesTableView) ? console.avatar : game.avatar;
        NSString *name = (tableView == self.consolesTableView) ? console.name : game.name;
        
        [cell setThumbnailWithUrl:[NSURL URLWithString:avatar]];
        [cell setTitleLabelStr:name];
        [cell setDescLabelStr:name];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.textLabel.font = [UIFont fl_bebasFontOfSize:18.0f];
//        cell.textLabel.text = [NSString stringWithFormat:@"Bajo construcción: %ld", (long)indexPath.row];
//        
//        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (void)localize {
    
}

@end
