//
//  FLToolbar.h
//  FutLife
//
//  Created by Rene Santis on 10/19/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLToolBarDelegate <NSObject>

@required

- (void)onInputAccessorySegmentedControlValueChanged:(UISegmentedControl *)sender;
- (void)onInputAccessoryDoneButtonTouched;

@end

@interface FLToolbar : UIToolbar

@property (nonatomic, weak) id <FLToolBarDelegate, UIToolbarDelegate> toolbarDelegate;
@property (nonatomic, assign, getter = isPreviousEnabled) BOOL previousEnabled;
@property (nonatomic, assign, getter = isNextEnabled) BOOL nextEnabled;
@property (nonatomic, assign, getter = isDoneEnabled) BOOL doneEnabled;

- (id)initWithDelegate:(id <FLToolBarDelegate, UIToolbarDelegate> )delegate previousEnabled:(BOOL)prevEnabled nextEnabled:(BOOL)nextEnabled;

@end
