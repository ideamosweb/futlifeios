//
//  FLPageBannerViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/5/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLPageBannerViewController.h"

NSString * const kTitleAnimationKey = @"titleAnimationKey";
NSString * const kContentAnimationKey = @"contentAnimationKey";

static const NSInteger kPageBannerSlide1 = 0;
static const NSInteger kPageBannerSlide2 = 1;

@interface FLPageBannerViewController ()

@property (weak,nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak,nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak,nonatomic) IBOutlet UIImageView *contentImageView;
@property (strong, nonatomic) UIImage *titleImage;
@property (strong, nonatomic) UIImage *contentImage;
@property (strong, nonatomic) UIImage *bgImage;
@property (assign, nonatomic, getter=isLoaded) BOOL loaded;

@end

@implementation FLPageBannerViewController

- (id)initWithBackgroundImage:(UIImage *)bgImage titleImage:(UIImage *)titleImage contentImage:(UIImage *)contentImage index:(NSInteger)index
{
    self = [super initWithNibName:NSStringFromClass([FLPageBannerViewController class]) bundle:nil];
    if (self) {
        self.bgImage = bgImage;
        self.titleImage = titleImage;
        self.contentImage = contentImage;
        self.index = index;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bgImageView setImage:self.bgImage];
    
    self.loaded = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.titleImageView bringSubviewToFront:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.index == 0 && self.isLoaded) {
        [self perFormConfigContentImages];
        
        self.loaded = NO;
    }
    
    [self.titleImageView bringSubviewToFront:self.view];
    [self.contentImageView sendSubviewToBack:self.view];
}

- (void)perFormConfigContentImages
{
    [self performSelector:@selector(configContentImages) withObject:nil afterDelay:0.5];
}

- (void)configContentImages
{
    [self.titleImageView setImage:self.titleImage];
    
    [self.contentImageView setImage:self.contentImage];
    
    self.contentImageView.alpha = 0.0f;
    
    [self titleAnimation];
}

- (void)titleAnimation
{
    POPSpringAnimation *titleImgAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    titleImgAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, [FLMiscUtils screenViewFrame].size.width - 20.0f, CGRectGetHeight(self.titleImageView.frame) + 70.0f)];
    [self.titleImageView pop_addAnimation:titleImgAnim forKey:kTitleAnimationKey];
    
    [self performSelector:@selector(contentImageAnimation) withObject:nil afterDelay:0.5];
}

- (void)contentImageAnimation
{
    if (self.index == kPageBannerSlide1) {
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.fromValue = @(0.0);
        anim.toValue = @(1.0);
        
        [self.contentImageView pop_addAnimation:anim forKey:kContentAnimationKey];
        
        [self.titleImageView bringSubviewToFront:self.view];
    } else if (self.index == kPageBannerSlide2) {
        CGRect contentImageFrame = self.contentImageView.frame;
        contentImageFrame.origin.x = -600;
        self.contentImageView.frame = contentImageFrame;
        self.contentImageView.alpha = 1.0f;
        NSLog(@"%@", self.contentImageView);
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.contentImageView.frame;
            frame.origin.x = ([FLMiscUtils screenViewFrame].size.width / 2) - (CGRectGetWidth(self.contentImageView.frame) / 2);
            self.contentImageView.frame = frame;
            
            [self.titleImageView bringSubviewToFront:self.view];
            [self.contentImageView sendSubviewToBack:self.view];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.contentImageView.frame;
            frame.origin.x = self.contentImageView.frame.origin.x + 10.0f;
            frame.origin.y = CGRectGetMaxY(self.titleImageView.frame);            
            self.contentImageView.bounds = frame;
            self.contentImageView.alpha = 1.0;
            
            [self.titleImageView bringSubviewToFront:self.view];
            [self.contentImageView sendSubviewToBack:self.view];
        }];
    }
}

- (void)removeElementsFromSuperView
{
    self.titleImageView.image = nil;
    self.contentImageView.image = nil;
}

@end
