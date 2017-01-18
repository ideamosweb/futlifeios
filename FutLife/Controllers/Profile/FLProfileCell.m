//
//  FLProfileCell.m
//  FutLife
//
//  Created by Rene Santis on 12/1/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLProfileCell.h"

#define CONSOLE_IMAGE_WIDTH 80.0f
#define CONSOLE_IMAGE_HEIGHT 20.0f

@interface FLProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *consolesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopConstraint;

@end

@implementation FLProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    selected ? [self showDetails] : [self hideDetails];
}

- (void)hideDetails
{
    [self.consolesView fl_fadeOutWithDuration:kDefaultAnimationDuration completion:nil];
}

- (void)showDetails
{
    [self.consolesView fl_fadeInWithDuration:kDefaultAnimationDuration completion:nil];
}

- (void)setGameImageName:(NSString *)gameImageName gameName:(NSString *)gameName gameYear:(NSNumber *)gameYear gameNumber:(NSString *)gameNumber
{
    [self.gameImageView setImageWithURL:[NSURL URLWithString:gameImageName] placeholderImage:nil];
    if (!gameYear) {
        self.gameYearLabel.hidden = YES;
        self.nameTopConstraint.constant = 12;
    } else {
        self.gameYearLabel.text = [NSString stringWithFormat:@"%@", gameYear];
        self.nameTopConstraint.constant = 3;
    }
    
    self.gameNameLabel.text= gameName;
    
    self.gameNumberLabel.text = gameNumber;
}

- (void)setConsoles:(NSArray *)consoles width:(CGFloat)width
{
    UIImageView *previousImage = nil;
    
    // Remove consoles subViews
    for (UIView *subView in self.consolesView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (FLConsoleModel *console in consoles) {
        if (!previousImage) {
            // Autolayout bug (?) set the tableView width
            UIImageView *consoleImage = [[UIImageView alloc] initWithFrame:CGRectMake(width - CONSOLE_IMAGE_WIDTH - 5.0f, 1.0f, CONSOLE_IMAGE_WIDTH, CONSOLE_IMAGE_HEIGHT)];
            if ([console.name isEqualToString:@"XBOX ONE"]) {
                [consoleImage setImage:[UIImage imageNamed:@"one_thumb2"]];
            } else if ([console.name isEqualToString:@"XBOX 360"]) {
                [consoleImage setImage:[UIImage imageNamed:@"360_thumb"]];
            } else if ([console.name isEqualToString:@"PS3"]) {
                [consoleImage setImage:[UIImage imageNamed:@"ps3_thumb"]];
            } else {
                [consoleImage setImage:[UIImage imageNamed:@"ps4_thumb"]];
            }
            
            consoleImage.contentMode = UIViewContentModeScaleAspectFit;
            
            previousImage = consoleImage;
            [self.consolesView addSubview:consoleImage];
        } else {
            UIImageView *consoleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(previousImage.frame) - CONSOLE_IMAGE_WIDTH - 5.0f, 1.0f, CONSOLE_IMAGE_WIDTH, CONSOLE_IMAGE_HEIGHT)];
            
            if ([console.name isEqualToString:@"XBOX ONE"]) {
                [consoleImage setImage:[UIImage imageNamed:@"one_thumb2"]];
            } else if ([console.name isEqualToString:@"XBOX 360"]) {
                [consoleImage setImage:[UIImage imageNamed:@"360_thumb"]];
            } else if ([console.name isEqualToString:@"PS3"]) {
                [consoleImage setImage:[UIImage imageNamed:@"ps3_thumb"]];
            } else {
                [consoleImage setImage:[UIImage imageNamed:@"ps4_thumb"]];
            }
            
            consoleImage.contentMode = UIViewContentModeScaleAspectFit;
            
            previousImage = consoleImage;
            
            [self.consolesView addSubview:consoleImage];
        }
    }    
}

@end
