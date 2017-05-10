//
//  FLChallengeView.h
//  FutLife
//
//  Created by Rene Santis on 3/1/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLChallengeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *defiantAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *rivalAvatar;
@property (weak, nonatomic) IBOutlet UILabel *defiantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rivalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *consolesLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *consolesField;
@property (weak, nonatomic) IBOutlet UITextField *gamesField;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSArray *consoles;
@property (strong, nonatomic) NSArray *games;

@end
