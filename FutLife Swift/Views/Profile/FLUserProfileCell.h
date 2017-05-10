//
//  FLUserProfileCell.h
//  FutLife
//
//  Created by Rene Santis on 2/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@interface FLUserProfileCell : FLCustomCell

- (void)setThumbnailWithImageName:(NSString *)imageName;
- (void)setGameThumbnailWithUrl:(NSURL *)url;
- (void)setConsoleWithUrl:(NSURL *)url;
- (void)setTitleLabelStr:(NSString *)labelString placeHolder:(NSString *)placeholder;
- (void)setDescLabelStr:(NSString *)descString;

@end
