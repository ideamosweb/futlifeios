//
//  FLProfileCell.m
//  FutLife
//
//  Created by Rene Santis on 12/1/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLProfileCell.h"

@interface FLProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNumberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopConstraint;

@end

@implementation FLProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
