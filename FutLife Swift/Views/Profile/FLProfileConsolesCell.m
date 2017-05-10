//
//  FLProfileConsolesCell.m
//  FutLife
//
//  Created by Rene Santis on 2/21/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLProfileConsolesCell.h"
#import "FLRegisterRequestModel.h"
#import "FLGameModel.h"

#define CONSOLE_IMAGE_WIDTH 80.0f
#define CONSOLE_IMAGE_HEIGHT 14.0f

@interface FLProfileConsolesCell ()

@property (weak, nonatomic) IBOutlet UIImageView *consoleImageView;
@property (weak, nonatomic) IBOutlet UILabel *consoleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *consoleDescLabel;
@property (weak, nonatomic) IBOutlet UIView *gamesContainerView;

@end

@implementation FLProfileConsolesCell

- (void)addConsoleImageUrl:(NSURL *)consoleImageUrl
{
    [_consoleImageView setImageWithURL:consoleImageUrl placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)addConsoleTitleText:(NSString *)titleText
{
    _consoleTitleLabel.text = titleText;
}

- (void)addConsoleDescText:(NSString *)descText
{
    _consoleDescLabel.text = descText;
}

- (void)addGameImageWithPreferences:(NSArray *)preferences
{
    UIImageView *previousImage = nil;
    
    // Remove consoles subViews
    for (UIView *subView in self.gamesContainerView.subviews) {
        [subView removeFromSuperview];
    }
    
//    NSMutableArray *gamesToAdd = [NSMutableArray new];
//    NSArray *games = [FLTemporalSessionManager sharedInstance].parameters.games;
//    FLGameModel *previousGame = nil;
//    for (FLRegisterPreferencesModel *preference in preferences) {
//        for (int i = 0; i < games.count; i++) {
//            FLGameModel *game = games[i];
//            if ((game.gameId == preference.gameId) && (previousGame.gameId != game.gameId)) {
//                [gamesToAdd addObject:game];
//                previousGame = game;
//            }
//        }
//    }
    
    for (FLGameModel *game in preferences) {
        if (!previousImage) {
            // Autolayout bug (?) set the tableView width
            UIImageView *consoleImage = [[UIImageView alloc] initWithFrame:CGRectMake(90.0f - CONSOLE_IMAGE_WIDTH - 10.0f, 8.0f, CONSOLE_IMAGE_WIDTH, CONSOLE_IMAGE_HEIGHT)];
            if ([game.name isEqualToString:@"FIFA16"]) {
                [consoleImage setImage:[UIImage imageNamed:@"f16"]];
            } else if ([game.name isEqualToString:@"FIFA17"]) {
                [consoleImage setImage:[UIImage imageNamed:@"f17"]];
            } else if ([game.name isEqualToString:@"PES16"]) {
                [consoleImage setImage:[UIImage imageNamed:@"P16"]];
            } else {
                [consoleImage setImage:[UIImage imageNamed:@"p17"]];
            }
            
            consoleImage.contentMode = UIViewContentModeScaleAspectFit;
            
            previousImage = consoleImage;
            [self.gamesContainerView addSubview:consoleImage];
        } else {
            UIImageView *consoleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(previousImage.frame) + 10.0f, 8.0f, CONSOLE_IMAGE_WIDTH, CONSOLE_IMAGE_HEIGHT)];
            
            if ([game.name isEqualToString:@"FIFA16"]) {
                [consoleImage setImage:[UIImage imageNamed:@"f16"]];
            } else if ([game.name isEqualToString:@"FIFA17"]) {
                [consoleImage setImage:[UIImage imageNamed:@"f17"]];
            } else if ([game.name isEqualToString:@"PES16"]) {
                [consoleImage setImage:[UIImage imageNamed:@"P16"]];
            } else {
                [consoleImage setImage:[UIImage imageNamed:@"p17"]];
            }
            
            consoleImage.contentMode = UIViewContentModeScaleAspectFit;
            
            previousImage = consoleImage;
            
            [self.gamesContainerView addSubview:consoleImage];
        }
        
    }
    
}

@end
