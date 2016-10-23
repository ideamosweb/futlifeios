//
//  FLToolbar.m
//  FutLife
//
//  Created by Rene Santis on 10/19/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLToolbar.h"

@interface FLToolbar ()

@property (nonatomic, strong) UISegmentedControl *previousAndNextControl;
@property (nonatomic, strong) UISegmentedControl *doneControl;

@end

@implementation FLToolbar

- (id)initWithDelegate:(id <FLToolBarDelegate, UIToolbarDelegate> )delegate previousEnabled:(BOOL)prevEnabled nextEnabled:(BOOL)nextEnabled
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        self.toolbarDelegate = delegate;
        
        [self sizeToFit];
        
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        
        NSString *previousTitle = @"Anterior";
        NSString *nextTitle = @"Siguiente";
        NSString *doneTitle = @"Listo";
        
        self.previousAndNextControl = [[UISegmentedControl alloc] initWithItems:@[previousTitle,
                                                                                  nextTitle]];
        self.previousAndNextControl.momentary = YES;
        self.previousAndNextControl.tintColor = [UIColor darkGrayColor];
        [self.previousAndNextControl addTarget:self.toolbarDelegate action:@selector(onInputAccessorySegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *previousAndNextBarSegment = [[UIBarButtonItem alloc] initWithCustomView:self.previousAndNextControl];
        
        [itemsArray addObject:previousAndNextBarSegment];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [itemsArray addObject:flexButton];
        
        self.doneControl = [[UISegmentedControl alloc] initWithItems:@[doneTitle]];
        self.doneControl.momentary = YES;
        self.doneControl.tintColor = [UIColor darkGrayColor];
        [self.doneControl addTarget:self.toolbarDelegate action:@selector(onInputAccessoryDoneButtonTouched) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *doneBarSegment = [[UIBarButtonItem alloc] initWithCustomView:self.doneControl];
        
        [itemsArray addObject:doneBarSegment];
        
        self.items = itemsArray;
        
        self.previousEnabled = prevEnabled;
        self.nextEnabled = nextEnabled;
        
        NSInteger osVersion = [[UIDevice currentDevice] systemVersion].integerValue;
        [self setBarStyle:osVersion < 7 ? UIBarStyleBlackTranslucent:UIBarStyleDefault];
    }
    return self;
}

- (void)setPreviousEnabled:(BOOL)previousEnabled
{
    _previousEnabled = previousEnabled;
    [self.previousAndNextControl setEnabled:previousEnabled forSegmentAtIndex:0];
}

- (void)setNextEnabled:(BOOL)nextEnabled
{
    _nextEnabled = nextEnabled;
    [self.previousAndNextControl setEnabled:nextEnabled forSegmentAtIndex:1];
}

- (void)setDoneEnabled:(BOOL)doneEnabled
{
    _doneEnabled = doneEnabled;
    [self.doneControl setEnabled:doneEnabled forSegmentAtIndex:0];
}

@end
