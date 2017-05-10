//
//  FLUserProfileCell.m
//  FutLife
//
//  Created by Rene Santis on 2/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUserProfileCell.h"

@interface FLUserProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *consoleThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *gameThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation FLUserProfileCell

- (void)setThumbnailWithImageName:(NSString *)imageName
{
    [_thumbnail setImage:[UIImage imageNamed:imageName]];
}

- (void)setGameThumbnailWithUrl:(NSURL *)url
{
    [_gameThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)setConsoleWithUrl:(NSURL *)url
{
    [_consoleThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)setTitleLabelStr:(NSString *)labelString placeHolder:(NSString *)placeholder
{
    _titleLabel.hidden = YES;
    [_titleTextField setPlaceholder:placeholder];
    if (![labelString fl_isEmpty]) {
        _titleTextField.text = labelString;
        _titleTextField.userInteractionEnabled = NO;
    } else {
        _titleTextField.userInteractionEnabled = YES;
    }
}

- (void)setDescLabelStr:(NSString *)descString
{
    _descriptionLabel.text = descString;
}

@end
