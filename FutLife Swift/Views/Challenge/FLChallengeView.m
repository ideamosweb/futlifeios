//
//  FLChallengeView.m
//  FutLife
//
//  Created by Rene Santis on 3/1/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLChallengeView.h"

@interface FLChallengeView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *amountPickerView;
@property (strong, nonatomic) UIPickerView *consolesPickerView;
@property (strong, nonatomic) UIPickerView *gamesPickerView;

@end

@implementation FLChallengeView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.defiantAvatar fl_MakeCircularViewWithBorderColor:[UIColor fl_lightGray] borderWidth:1.0];
    [self.rivalAvatar fl_MakeCircularViewWithBorderColor:[UIColor fl_lightGray] borderWidth:1.0];
    
    [self addPickerView];
}

- (void)addPickerView
{
    self.amountPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200.0f, [FLMiscUtils screenViewFrame].size.width, 250.0f)];
    self.amountPickerView.delegate = self;
    self.amountPickerView.dataSource = self;
    self.amountPickerView.showsSelectionIndicator = YES;
    
    self.consolesPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200.0f, [FLMiscUtils screenViewFrame].size.width, 250.0f)];
    self.consolesPickerView.delegate = self;
    self.consolesPickerView.dataSource = self;
    self.consolesPickerView.showsSelectionIndicator = YES;
    
    self.gamesPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200.0f, [FLMiscUtils screenViewFrame].size.width, 250.0f)];
    self.gamesPickerView.delegate = self;
    self.gamesPickerView.dataSource = self;
    self.gamesPickerView.showsSelectionIndicator = YES;
    
    self.amountField.inputView = self.amountPickerView;
    self.consolesField.inputView = self.consolesPickerView;
    self.gamesField.inputView = self.gamesPickerView;
}

#pragma mark - UIPickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.amountPickerView) {
        return 4;
    } else if (pickerView == self.consolesPickerView) {
        return self.consoles.count;
    }
    
    return 1.0; //TODO
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.amountPickerView) {
        return [NSString stringWithFormat:@"%ld", (long)row * 10000];
    } else if (pickerView == self.consolesPickerView) {
        FLConsoleModel *console = self.consoles[row];
        return console.name;
    }
    
    FLGameModel *game = self.games[row];
    return game.name;
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.amountPickerView) {
        self.amountField.text = [NSString stringWithFormat:@"%ld", (long)row * 10000];
        [FLTemporalSessionManager sharedInstance].challengeAmount = self.amountField.text;
    } else if (pickerView == self.consolesPickerView) {
        FLConsoleModel *console = self.consoles[row];
        self.consolesField.text = console.name;
        
        [FLTemporalSessionManager sharedInstance].challengeConsole = console.consoleId;
    } else if (pickerView == self.gamesPickerView) {
        FLGameModel *game = [self.games firstObject];
        
        self.gamesField.text = game.name;
        
        [FLTemporalSessionManager sharedInstance].challengeGame = game.gameId;
    }
}


@end
