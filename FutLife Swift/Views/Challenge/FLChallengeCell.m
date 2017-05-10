//
//  FLChallengeCell.m
//  FutLife
//
//  Created by Rene Santis on 2/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLChallengeCell.h"

@interface FLChallengeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *defiantAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *rivalAvatar;
@property (weak, nonatomic) IBOutlet UILabel *defiantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rivalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *defiantScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rivalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *defiantStatusView;
@property (weak, nonatomic) IBOutlet UIView *rivalStatusView;

@end

@implementation FLChallengeCell

- (void)setDefiantAvatarUrl:(NSURL *)defiantAvatarUrl withBorder:(BOOL)border
{
    [_defiantAvatar setImageWithURL:defiantAvatarUrl placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
    
    if (border) {
        [_defiantAvatar fl_applyBorderWidth:2.0f borderColor:[UIColor fl_greenDefault]];
    }
}

- (void)setRivalAvatarUrl:(NSURL *)rivalAvatarUrl withBorder:(BOOL)border
{
    [_rivalAvatar setImageWithURL:rivalAvatarUrl placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
    
    if (border) {
        [_rivalAvatar fl_applyBorderWidth:2.0f borderColor:[UIColor fl_greenDefault]];
    }
}

- (void)setDefiantScoreLabelText:(NSString *)defiantScoreLabel
{
    _defiantScoreLabel.text = defiantScoreLabel;
    _defiantScoreLabel.textColor = [UIColor blackColor];
}

- (void)setRivalScoreLabelText:(NSString *)rivalScoreLabel
{
    _rivalScoreLabel.text = rivalScoreLabel;
    _rivalScoreLabel.textColor = [UIColor blackColor];
}

- (void)setDefiantNameLabelText:(NSString *)defiantNameLabel
{
    _defiantNameLabel.text = defiantNameLabel;
}

- (void)setRivalNameLabelText:(NSString *)rivalNameLabel
{
    _rivalNameLabel.text = rivalNameLabel;    
}

- (void)setAmountLabelText:(NSString *)amountLabel
{
    _amountLabel.text = amountLabel;
}

- (void)setDefiantStatusViewWithColor:(UIColor *)color
{
    _defiantStatusView.backgroundColor = color;
}

- (void)setRivalStatusViewWithColor:(UIColor *)color
{
    _rivalStatusView.backgroundColor = color;
}

@end
