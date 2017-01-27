//
//  TabsViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLTabsViewController.h"

static const CGFloat kTabsButtonsViewHeight = 44.0f;
static const CGFloat kTabsButtonsViewMinY = 0.0f;

@interface FLTabsViewController ()

@property (strong, nonatomic) UIView *tabsView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *buttonsView;
@property (strong, nonatomic) UIView *selectorTabButtonView;

@end

@implementation FLTabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabsViewControllers = [NSMutableArray new];   
}

- (void)configElementsOfView
{
    CGFloat scrollViewHeight = [FLMiscUtils screenViewFrame].size.height - kTabsButtonsViewMinY - kTabsButtonsViewHeight;
    
    // Button's tabs container view
    self.buttonsView.backgroundColor = [UIColor colorWithRed:0.4f/255.0f green:21.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    
    // Button's tabs selector
    self.selectorTabButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.buttonsView.frame) - 2.0f, CGRectGetWidth(self.buttonsView.frame) / 2, 2.0f)];
    self.selectorTabButtonView.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:164.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    [self.buttonsView addSubview:self.selectorTabButtonView];
    
    // The scrollView container for view's controllers
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buttonsView.frame), [FLMiscUtils screenViewFrame].size.width, scrollViewHeight)];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.buttonsView];
}

- (void)reloadTabs
{
    // Calculate button's tab width first
    CGFloat buttonWidth = ([FLMiscUtils screenViewFrame].size.width / self.tabsViewControllers.count);
    
    // Container Button's tab frame
    self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, kTabsButtonsViewMinY, [FLMiscUtils screenViewFrame].size.width, kTabsButtonsViewHeight)];
    
    
    [self configElementsOfView];
    
    // Add button's tab to view container
    UIButton *previousButton = nil;
    FLViewController *previousVC = nil;
    // Calculate scrollView width and height
    CGFloat scrollViewContentSizeWidth = [FLMiscUtils screenViewFrame].size.width;
    CGFloat scrollViewnContentSizeHeight = [FLMiscUtils screenViewFrame].size.height - kTabsButtonsViewMinY - kTabsButtonsViewHeight;
    
    int i = 0;
    for (FLViewController *viewController in self.tabsViewControllers) {
        UIButton *buttonTab = [[UIButton alloc] init];
        
        // create buttons by view's controllers
        if (!previousButton) {
            buttonTab.frame = CGRectMake(0.0f, 0.0f, buttonWidth, 44.0f);
            buttonTab.titleLabel.font = [UIFont fl_bebasFontOfSize:20.0];
            [buttonTab setTitleColor:[UIColor colorWithRed:216.0f/255.0f green:219.0f/255.0f blue:223.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [buttonTab setTitle:@"Jugadores" forState:UIControlStateNormal];
            buttonTab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            buttonTab.tag = (i + 1);
            
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(buttonTab.frame) - 1, (CGRectGetHeight(buttonTab.frame) / 2) / 2, 1.0f, 20.0f)];
            separator.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:143.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
            [buttonTab addSubview:separator];
            
            previousButton = buttonTab;
        } else {
            buttonTab.frame = CGRectMake(CGRectGetMaxX(previousButton.frame), 0.0f, buttonWidth, 44.0f);
            buttonTab.titleLabel.font = [UIFont fl_bebasFontOfSize:20.0];
            [buttonTab setTitleColor:[UIColor colorWithRed:216.0f/255.0f green:219.0f/255.0f blue:223.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [buttonTab setTitle:@"Pendientes" forState:UIControlStateNormal];
            buttonTab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            buttonTab.tag = (i + 1);
        }
        
        [buttonTab addTarget:self action:@selector(onButtonTabTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonsView addSubview:buttonTab];
        
        scrollViewContentSizeWidth = scrollViewContentSizeWidth * (i + 1);        
        
        // Add view controllers to scrollView modifying the origin X frame
        if (!previousVC) {
            previousVC = viewController;
        } else {
            CGRect viewControllerFrame = viewController.view.frame;
            viewControllerFrame.origin.x = CGRectGetWidth(previousVC.view.frame);
            viewController.view.frame = viewControllerFrame;
        }
        
        [self addChildViewController:viewController];
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:nil];
        
        i++;
    }
    
    // Set content size scrollView
    self.scrollView.contentSize = CGSizeMake(scrollViewContentSizeWidth, scrollViewnContentSizeHeight);
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
}

- (void)onButtonTabTouch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // Get viewController and calculate the point position for perform scroll
    FLViewController *viewController = [self.tabsViewControllers objectAtIndex:(button.tag - 1)];
    CGPoint point = CGPointMake(CGRectGetMinX(viewController.view.frame), 0.0f);
    [self.scrollView setContentOffset:point animated:YES];
    
    // Selector tabs animation
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *buttonTab = self.buttonsView.subviews[button.tag];
        CGRect selectedButtonViewFrame = self.selectorTabButtonView.frame;
        selectedButtonViewFrame.origin.x = CGRectGetMinX(buttonTab.frame);
        self.selectorTabButtonView.frame = selectedButtonViewFrame;
    }];
}

- (void)localize
{
    
}

@end
