//
//  FLAlertView.m
//  FutLife
//
//  Created by Rene Santis on 10/26/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLAlertView.h"
#import "FLValidatable.h"

const CGFloat kAlertViewExternalPadding = 100.0f;
const CGFloat kAlertViewInnerPadding = 10.0f;
const CGFloat kAlertViewTitleFontSize = 22.0f;
const CGFloat kAlertViewMaxMessageViewHeight = 90.0f;
const CGFloat kAlertViewMessageFontSize = 12.0f;
const CGFloat kAlertViewButtonHeight = 34.0f;
const CGFloat kAlertViewButtonSpacing = 5.0f;
const CGFloat kOptionSwitchViewHeight = 44.0f;
const CGFloat kOptionSwitchPaddingHorizontal = 10.0f;
const CGFloat kOptionSwitchPaddingTop = 3.0f;

@interface FLAlertView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *inputFields;
@property (nonatomic, copy) void (^clickedButtonBlock)(UIButton *clickedButton);

@end

@implementation FLAlertView

- (id)initWithContentView:(UIView *)contentView buttonsInContentView:(NSArray *)buttons inputFieldsInContentView:(NSArray *)inputFields clickedButton:(void (^)(UIButton *clickedButton))clickedButtonBlock
{
    self.dynamic = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height) : CGRectMake(0.0f, 0.0f, screenSize.height, screenSize.width);
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView = contentView;
        self.buttons = buttons;
        self.inputFields = inputFields;
        
        for (UIButton *button in buttons) {
            [button addTarget:self action:@selector(onButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.clickedButtonBlock = clickedButtonBlock;
        self.tintColor = [UIColor clearColor];
        self.blurRadius = 4.0f;
        self.iterations = 2;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonTypes:(NSArray *)buttonTypes clickedButtonAtIndex:(void (^)(NSUInteger clickedButtonIndex))clickedButtonIndexBlock
{
    BOOL hasTitle = (title && ![title fl_isEmpty]);
    NSUInteger buttonCount = [buttonTitles count];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat alertWidth = screenSize.width - kAlertViewExternalPadding;
    CGFloat buttonsHeight = kAlertViewButtonHeight;
    if (buttonCount > 2) {
        buttonsHeight += (kAlertViewButtonSpacing + buttonsHeight) * (buttonCount - 1);
    }
    
    CGFloat alertHeight = 2.0f * kAlertViewInnerPadding + kAlertViewTitleFontSize * hasTitle + kAlertViewMaxMessageViewHeight + kAlertViewButtonSpacing * 2.0f + buttonsHeight;
    
    // Setup container.
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, alertWidth, alertHeight)];
    contentView.center = CGPointMake(screenSize.width / 2.0f, screenSize.height / 2.0f);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10.0;
    // Setup title
    CGFloat messageViewY = kAlertViewInnerPadding;
    if (hasTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewInnerPadding, kAlertViewInnerPadding + 5.0f, alertWidth - 2.0f * kAlertViewInnerPadding, kAlertViewTitleFontSize)];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        messageViewY = CGRectGetMaxY(titleLabel.frame);
    }
    // Setup message.
    UITextView *messageView = [self setupMessageViewWithText:message contentView:contentView posY:messageViewY];
    [self resizeContentView:contentView andMessageView:messageView messageText:message];
    
    // Setup buttons
    NSArray *buttons = [self setupButtonsWithTitles:buttonTitles types:buttonTypes contentView:contentView posY:CGRectGetMaxY(messageView.frame)];
    
    return [self initWithContentView:contentView
                buttonsInContentView:buttons inputFieldsInContentView:nil clickedButton: ^(UIButton *clickedButton) {
                    if (clickedButtonIndexBlock)
                    {
                        clickedButtonIndexBlock([buttons indexOfObject:clickedButton]);
                    }
                }];
}

- (id)initWithNumberOfOptions:(NSInteger)options title:(NSString *)title optionsText:(NSArray *)optionsText optionsOn:(NSArray *)optionsOn buttonTitles:(NSArray *)buttonTitles buttonTypes:(NSArray *)buttonTypes delegate:(id)delegate clickedButtonAtIndex:(void (^)(NSUInteger clickedButtonIndex))clickedButtonIndexBlock
{
    BOOL hasTitle = (title && ![title fl_isEmpty]);
    NSUInteger buttonCount = [buttonTitles count];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat alertWidth = screenSize.width - kAlertViewExternalPadding;
    CGFloat buttonsHeight = kAlertViewButtonHeight;
    if (buttonCount > 2) {
        buttonsHeight += (kAlertViewButtonSpacing + buttonsHeight) * (buttonCount - 1);
    }
    
    if (delegate) {
        self.delegate = delegate;
    }
    
    UIView *contentOptionsView = [UIView new];
    UIView *previousView = nil;
    for (int i = 0; i  < options; i++) {
        UISwitch *optionSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 30.0f, 20.0f)];
        optionSwitch.tag = i + 1;
        [optionSwitch addTarget:self action:@selector(onSelectConsoleSwitch:) forControlEvents:UIControlEventValueChanged];
        optionSwitch.on = [optionsOn[i] boolValue];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(optionSwitch.frame) + 15.0f, 15.0f, alertWidth - (kOptionSwitchPaddingHorizontal * 4) - CGRectGetWidth(optionSwitch.frame), 15.0f)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Bebas" size:15.0f];
        label.text = (NSString *)optionsText[i];
        if (!previousView) {
            UIView *optionsView = [[UIView alloc] initWithFrame:CGRectMake(kOptionSwitchPaddingHorizontal, 0.0f, alertWidth - (kOptionSwitchPaddingHorizontal * 4), kOptionSwitchViewHeight)];
            [optionsView addSubview:optionSwitch];
            [optionsView addSubview:label];
            
            if (i < options - 1) {
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(optionsView.frame) - 1, CGRectGetWidth(optionsView.frame), 1)];
                separatorView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:219.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
                [optionsView addSubview:separatorView];
            }
            
            contentOptionsView.frame = optionsView.frame;
            [contentOptionsView addSubview:optionsView];
            
            previousView = optionsView;
        } else {
            UIView *optionsView = [[UIView alloc] initWithFrame:CGRectMake(kOptionSwitchPaddingHorizontal, CGRectGetMaxY(previousView.frame), alertWidth - (kOptionSwitchPaddingHorizontal * 4), kOptionSwitchViewHeight)];
            [optionsView addSubview:optionSwitch];
            [optionsView addSubview:label];
            
            if (i < options - 1) {
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(optionsView.frame) - 1, CGRectGetWidth(optionsView.frame), 1)];
                separatorView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:219.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
                [optionsView addSubview:separatorView];
            }
            
            CGRect contentOptionsViewFrame = contentOptionsView.frame;
            contentOptionsViewFrame.size.height = contentOptionsView.frame.size.height + previousView.frame.size.height;
            contentOptionsView.frame = contentOptionsViewFrame;
            
            [contentOptionsView addSubview:optionsView];
            
            previousView = optionsView;
        }
    }
    
    CGFloat alertHeight = 2.0f * kAlertViewInnerPadding + kAlertViewTitleFontSize * hasTitle + contentOptionsView.frame.size.height + kOptionSwitchPaddingTop + kAlertViewButtonSpacing * 2.0f + buttonsHeight;
    
    // Setup container.
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, alertWidth, alertHeight)];
    contentView.center = CGPointMake(screenSize.width / 2.0f, screenSize.height / 2.0f);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10.0;
    // Setup title
    CGFloat messageViewY = kAlertViewInnerPadding;
    if (hasTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewInnerPadding, kAlertViewInnerPadding + 5.0f, alertWidth - 2.0f * kAlertViewInnerPadding, kAlertViewTitleFontSize)];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        messageViewY = CGRectGetMaxY(titleLabel.frame);
    }
    
    CGRect contentOptionsViewFrame = contentOptionsView.frame;
    contentOptionsViewFrame.origin.y = messageViewY + kOptionSwitchPaddingTop;
    contentOptionsView.frame = contentOptionsViewFrame;
    
    [contentView addSubview:contentOptionsView];
    
    // Setup buttons
    NSArray *buttons = [self setupButtonsWithTitles:buttonTitles types:buttonTypes contentView:contentView posY:CGRectGetMaxY(contentOptionsView.frame)];
    
    return [self initWithContentView:contentView
                buttonsInContentView:buttons inputFieldsInContentView:nil clickedButton: ^(UIButton *clickedButton) {
                    if (clickedButtonIndexBlock)
                    {
                        clickedButtonIndexBlock([buttons indexOfObject:clickedButton]);
                    }
                }];
    
}

- (UITextView *)setupMessageViewWithText:(NSString *)message contentView:(UIView *)contentView posY:(CGFloat)messageViewY
{
    //CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    //CGFloat alertWidth = screenSize.width - kAlertViewExternalPadding;
    // Setup message.
    UITextView *messageView = [[UITextView alloc] initWithFrame:CGRectMake(kAlertViewInnerPadding, messageViewY, contentView.frame.size.width - kAlertViewInnerPadding, kAlertViewMaxMessageViewHeight)];
    messageView.editable = NO;
    
    // Hack to align the text to the start of the UITextView.
    messageView.contentInset = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? UIEdgeInsetsMake(-4.0f, -4.0f, 0.0f, 0.0f) : UIEdgeInsetsMake(-4.0f, -8.0f, 0.0f, 0.0f);
    
    messageView.font = [UIFont systemFontOfSize:kAlertViewMessageFontSize];
    messageView.textColor = [UIColor grayColor];
    messageView.text = message;
    messageView.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:messageView];
    
    return messageView;
}

- (void)resizeContentView:(UIView *)contentView andMessageView:(UITextView *)messageView messageText:(NSString *)message
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat alertWidth = screenSize.width - kAlertViewExternalPadding;
    CGFloat alertHeight = CGRectGetHeight(contentView.frame);
    //CGFloat alertViewMessageFontSize = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) ? kAlertViewMessageFontSize : kAlertViewMessageFontSize + 1;
    CGFloat messageViewTextHeight = ceilf([message fl_sizeWithFont:[UIFont systemFontOfSize:kAlertViewMessageFontSize] constrainedToSize:CGSizeMake(messageView.frame.size.width, FLT_MAX)].height) + 25.0f;
    
    if (messageViewTextHeight < kAlertViewMaxMessageViewHeight)
    {
        CGRect newMessageViewframe = messageView.frame;
        newMessageViewframe.size.height = messageViewTextHeight;
        messageView.frame = newMessageViewframe;
        messageView.contentSize = messageView.frame.size;
        alertHeight = alertHeight - kAlertViewMaxMessageViewHeight + newMessageViewframe.size.height;
        CGRect newContentViewFrame = CGRectMake(screenSize.width / 2.0f, screenSize.height / 2.0f, alertWidth, alertHeight);
        contentView.frame = newContentViewFrame;
        contentView.center = CGPointMake(screenSize.width / 2.0f, screenSize.height / 2.0f);
    }
}

- (NSArray *)setupButtonsWithTitles:(NSArray *)titles types:(NSArray *)types contentView:(UIView *)contentView posY:(CGFloat)buttonsPosY
{
    // Setup buttons.
    NSUInteger buttonCount = [titles count];
    ASSERT(buttonCount <= 6);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat alertWidth = screenSize.width - kAlertViewExternalPadding;
    CGFloat buttonsHeight = kAlertViewButtonHeight;
    CGFloat buttonWidth = alertWidth - 2.0f * kAlertViewInnerPadding;
    if (buttonCount == 2) {
        buttonWidth = buttonWidth / 2.0f - kAlertViewButtonSpacing;
    } else if (buttonCount > 2) {
        buttonsHeight += (kAlertViewButtonSpacing + buttonsHeight) * (buttonCount - 1);
    }
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:buttonCount];
    for (NSUInteger i = 0; i < buttonCount; i++) {
        NSString *buttonTitle = [titles fl_objectAtIndex:i];
        CGFloat buttonX = kAlertViewInnerPadding;
        CGFloat buttonY = buttonsPosY + kAlertViewButtonSpacing * 2.0f;
        
        if (buttonCount > 2)
        {
            buttonY += i * (kAlertViewButtonHeight + kAlertViewButtonSpacing);
        }
        else if (buttonCount == 2 && i == 1)
        {
            buttonX += buttonWidth + kAlertViewButtonSpacing;
        }
        
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonWidth, kAlertViewButtonHeight);
        // FLButton TODO
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
//        if (!types) {
//            if (buttonCount > 1) {
//                button.type = (buttonCount > 1 && i == buttonCount - 1) ? MTButtonTypeGray : MTButtonTypeDarkBlue;
//            } else {
//                button.type = MTButtonTypeDarkBlue;
//            }
//        }
//        else
//        {
//            button.type = [[types mt_objectAtIndex:i] unsignedIntValue];
//        }
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, buttonsPosY + 5.0f, alertWidth, 1.0)];
        [separatorView setBackgroundColor:[UIColor lightGrayColor]];
        [contentView addSubview:separatorView];
        
        [contentView addSubview:button];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:66.0f/255.0 green:141.0f/255.0 blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [buttons addObject:button];
    }
    return buttons;
}

- (void)show
{
    [self.contentView fl_applySurroundingShadowRadius:2.0f opacity:0.5f animated:YES];
    self.contentView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.alpha = 0.0f;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    __weak FLAlertView *weakSelf = self;
    [UIView animateWithDuration:kDefaultAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        weakSelf.contentView.transform = CGAffineTransformIdentity;
        weakSelf.alpha = 1.0f;
    } completion:nil];
}

// Validates a particular input field.
// Returns an empty non-nil array if there
// are no validation errors.
- (NSArray *)validateInputField:(UIView *)inputField
{
    if ([inputField conformsToProtocol:@protocol(FLValidatable)])
    {
        return [((id < FLValidatable >)inputField)validate];
    }
    
    return [[NSMutableArray alloc] init];
}

- (void)onButtonTouchUpInside:(id)sender
{
    ASSERT_CLASS(sender, UIButton);
    UIButton *button = sender;
    [self.contentView fl_removeSurroundingShadowAnimated:YES];
    [self endEditing:NO];
    NSMutableArray *validationMessages = [[NSMutableArray alloc] init];
    if (button != [self.buttons lastObject])
    {
        // Validate all the input fields.
        for (UIView *inputField in self.inputFields)
        {
            NSArray *inputFieldValidationMessages = [self validateInputField:inputField];
            ASSERT(inputFieldValidationMessages);
            [validationMessages addObjectsFromArray:inputFieldValidationMessages];
        }
    }
    if ([validationMessages fl_isEmpty])
    {
        __weak FLAlertView *weakSelf = self;
        [UIView animateWithDuration:kDefaultAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations: ^{
            weakSelf.contentView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
            weakSelf.alpha = 0.0f;
        } completion: ^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
        
        if (self.clickedButtonBlock)
        {
            self.clickedButtonBlock(button);
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGFloat visibleHeight = self.bounds.size.height - keyboardSize.height - self.contentView.frame.size.height;
    
    [UIView animateWithDuration:[animationDuration floatValue] delay:0.0 options:[animationCurve intValue] animations: ^{
        UIView *alertView = self.contentView;
        alertView.frame = CGRectMake(CGRectGetMinX(alertView.frame), visibleHeight / 2.0f, CGRectGetWidth(alertView.frame), CGRectGetHeight(alertView.frame));
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[animationDuration floatValue] delay:0.0 options:[animationCurve intValue] animations: ^{
        UIView *alertView = self.contentView;
        alertView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    } completion:nil];
}

#pragma mark - Protocol delegate methods

- (void)onSelectConsoleSwitch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSelectConsoleSwitch:)]) {
        [self.delegate onSelectConsoleSwitch:sender];
    }    
}

@end
