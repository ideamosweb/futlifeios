//
//  FLUserProfileCell.h
//  FutLife
//
//  Created by Rene Santis on 2/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@interface FLUserProfileCell : FLCustomCell

- (void)setThumbnailWithUrl:(NSURL *)url;
- (void)setTitleLabelStr:(NSString *)labelString;
- (void)setDescLabelStr:(NSString *)descString;

@end
