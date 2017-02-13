//
//  FLBannersViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/5/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLBannersViewController.h"
#import "FLPageBannerViewController.h"

@interface FLBannersViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *bannerVCs;
@property (nonatomic, copy) void (^bannersCompletionBlock)();

@end

@implementation FLBannersViewController

- (id)initWithCompletionBlock:(void (^)())completionBlock
{
    self = [super initWithNibName:NSStringFromClass([FLBannersViewController class]) bundle:nil];
    if (self)
    {
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:NULL];
        self.bannersCompletionBlock = completionBlock;
        
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = NO;
    
    [self.pageViewController setViewControllers:@[[self bannerForIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController.view setFrame:CGRectMake(0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    [self performSelector:@selector(showSkipButton) withObject:nil afterDelay:2.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (FLPageBannerViewController *)bannerForIndex:(NSInteger)index
{
    if (self.bannerVCs == nil)
    {
        self.bannerVCs = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSInteger i = 0; i < 3; i++) {
            UIImage *bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"BG_slide_0%ld", (long)(i + 1)]];
            UIImage *titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"text_slide%ld", (long)(i + 1)]];
            UIImage *contentImage = [UIImage imageNamed:[NSString stringWithFormat:@"content_image_intro_slide-%ld", (long)(i + 1)]];
            FLPageBannerViewController *page = [[FLPageBannerViewController alloc] initWithBackgroundImage:bgImage titleImage:titleImage contentImage:contentImage index:i];
            
            page.view.tag = i;
            [self.bannerVCs addObject:page];
        }
        
    }
    
    if (self.bannerVCs.count > 0) {
        return self.bannerVCs[index];
    }
    
    return [(FLPageBannerViewController *)[FLPageBannerViewController alloc] init];
}

- (void)showSkipButton
{
    [self.skipButton fl_fadeInWithDuration:1.0 completion:nil];    
}

- (IBAction)onSkipButtonTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.bannersCompletionBlock();        
    }];
}

- (void)localize
{
    
}

#pragma mark - UIPageViewController delegate methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = viewController.view.tag;
    FLPageBannerViewController *currentViewController = (FLPageBannerViewController *)self.bannerVCs[index];
    if (index == 0) {
        currentViewController.firstOrLastPage = YES;
        return nil;
    } else {
        currentViewController.firstOrLastPage = NO;
    }
    
    index--;
    
    return self.bannerVCs[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = viewController.view.tag;
    index++;
    
    FLPageBannerViewController *currentViewController = (FLPageBannerViewController *)self.bannerVCs[index - 1];
    
    if (index == self.bannerVCs.count) {
        currentViewController.firstOrLastPage = YES;
        return nil;
    } else {
        currentViewController.firstOrLastPage = NO;
    }
    
    return self.bannerVCs[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        return;
    }
    FLPageBannerViewController *currentViewController = (FLPageBannerViewController *)[pageViewController viewControllers][0];
    self.pageControl.currentPage = currentViewController.index;    
    [currentViewController configContentImages];
    
    for (FLPageBannerViewController *previouVC in previousViewControllers) {
        [previouVC removeElementsFromSuperView];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    if (pageViewController) {
        
    }
    
}

@end
