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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation FLUserProfileCell

- (void)setThumbnailWithUrl:(NSURL *)url
{
    [_thumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading_placeholder"]];
}

- (void)setTitleLabelStr:(NSString *)labelString
{
    _titleLabel.text = labelString;
}

- (void)setDescLabelStr:(NSString *)descString
{
    _descriptionLabel.text = descString;
}

@end
