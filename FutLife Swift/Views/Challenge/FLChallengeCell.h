//
//  FLChallengeCell.h
//  FutLife
//
//  Created by Rene Santis on 2/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@interface FLChallengeCell : FLCustomCell

- (void)setDefiantAvatarUrl:(NSURL *)defiantAvatarUrl withBorder:(BOOL)border;
- (void)setRivalAvatarUrl:(NSURL *)rivalAvatarUrl withBorder:(BOOL)border;
- (void)setDefiantScoreLabelText:(NSString *)defiantScoreLabel;
- (void)setRivalScoreLabelText:(NSString *)rivalScoreLabel;
- (void)setDefiantNameLabelText:(NSString *)defiantNameLabel;
- (void)setRivalNameLabelText:(NSString *)rivalNameLabel;
- (void)setAmountLabelText:(NSString *)amountLabel;
- (void)setDefiantStatusViewWithColor:(UIColor *)color;
- (void)setRivalStatusViewWithColor:(UIColor *)color;

@end
