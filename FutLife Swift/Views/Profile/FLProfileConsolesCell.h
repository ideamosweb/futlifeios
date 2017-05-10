//
//  FLProfileConsolesCell.h
//  FutLife
//
//  Created by Rene Santis on 2/21/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLCustomCell.h"

@interface FLProfileConsolesCell : FLCustomCell

- (void)addConsoleImageUrl:(NSURL *)consoleImageUrl;
- (void)addConsoleTitleText:(NSString *)titleText;
- (void)addConsoleDescText:(NSString *)descText;
- (void)addGameImageWithPreferences:(NSArray *)preferences;

@end
