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

#import "FLProfileCell.h"
#import "FacebookStyleBarBehaviorDefiner.h"

#define USERNAME_LABEL_Y_POSITION ((int) 80)

@interface FLUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userName;

@end

@implementation FLUserProfileViewController

- (id)initWithAvatar:(UIImage *)avatar name:(NSString *)name userName:(NSString *)userName
{
    self = [super init];
    if (self) {
        self.avatar = avatar;
        self.name = name;
        self.userName = userName;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height)];
    [bgImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:bgImageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height)];
    scrollView.contentSize = CGSizeMake([FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height + 300.0f);
    [self.view addSubview:scrollView];
    
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
    UIImage *bgBarImage = [UIImage imageNamed:@"headerFlexNavBg"];
    UIImage *blurredBGImage = [bgBarImage fl_blurredImage:10.0f];
    
    UIImageView *bgBarImageView = [[UIImageView alloc] initWithFrame:myBar.frame];
    bgBarImageView.image = blurredBGImage;
    
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
    
    UIView *tabsContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(myBar.frame), [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(myBar.frame))];
    
    CGRect consolesTableViewFrame = CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, [FLMiscUtils screenViewFrame].size.height - CGRectGetHeight(myBar.frame));
    
    UITableView *consolesTableView = [[UITableView alloc] initWithFrame:consolesTableViewFrame];
    consolesTableView.backgroundColor = [UIColor clearColor];
    consolesTableView.delegate = self;
    consolesTableView.dataSource = self;
    consolesTableView.scrollEnabled = YES;
    consolesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    consolesTableView.clipsToBounds = NO;
    [consolesTableView registerNib:[FLProfileCell nib] forCellReuseIdentifier:[FLProfileCell cellIdentifier]];
    [tabsContainer addSubview:consolesTableView];
    
    [scrollView addSubview:tabsContainer];
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fl_bebasFontOfSize:18.0f];
        cell.textLabel.text = [NSString stringWithFormat:@"Bajo construcción: %ld", (long)indexPath.row];
        
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (void)localize {
    
}

@end
