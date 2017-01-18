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
static const NSInteger kPageBannerSlide3 = 2;

@interface FLPageBannerViewController ()

@property (weak,nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) UIImage *titleImage;
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) UIImage *contentImage;
@property (strong, nonatomic) UIImageView *contentImageView;
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
    
    //self.index = 0;
    self.loaded = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.index == 0 && self.isLoaded) {
        [self performSelector:@selector(configContentImages) withObject:nil afterDelay:0.5];
        
        self.loaded = NO;
    }
}

- (void)configContentImages
{
    self.titleImageView = [[UIImageView alloc] initWithImage:self.titleImage];
    CGRect titleImageFrame = self.titleImageView.frame;
    titleImageFrame.origin.x = 185.0f;
    titleImageFrame.origin.y = 150.0f;
    titleImageFrame.size.width = 0.0f;
    titleImageFrame.size.height = 0.0f;
    self.titleImageView.frame = titleImageFrame;
    
    self.contentImageView = [[UIImageView alloc] initWithImage:self.contentImage];
    CGRect contentImageFrame = self.contentImageView.frame;
    contentImageFrame.origin.x = (self.index != kPageBannerSlide2) ? 0.0f : -500.0f;
    contentImageFrame.origin.y = (self.index != kPageBannerSlide3) ? CGRectGetMaxY(self.titleImageView.frame) + 90.0f : 2000.0f;
    contentImageFrame.size.width = [FLMiscUtils screenViewFrame].size.width - 20.0f;
    contentImageFrame.size.height = [FLMiscUtils screenViewFrame].size.height - CGRectGetMinY(self.contentImageView.frame) - 300.0f;
    self.contentImageView.frame = contentImageFrame;
    self.contentImageView.alpha = 0.0;
    
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.contentImageView];
    
    [self titleAnimation];
}

- (void)titleAnimation
{
    POPSpringAnimation *titleImgAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    titleImgAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, [FLMiscUtils screenViewFrame].size.width - 20.0f, 200.0f)];
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
    } else if (self.index == kPageBannerSlide2) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.contentImageView.frame;
            frame.origin.x = 10;
            self.contentImageView.frame = frame;
            self.contentImageView.alpha = 1.0;
            
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.contentImageView.frame;
            frame.origin.x = self.contentImageView.frame.origin.x + 10.0f;
            frame.origin.y = CGRectGetMaxY(self.titleImageView.frame);            
            self.contentImageView.frame = frame;
            self.contentImageView.alpha = 1.0;
        }];
    }
}

- (void)removeElementsFromSuperView
{
    [self.titleImageView removeFromSuperview];
    [self.contentImageView removeFromSuperview];
}

@end
