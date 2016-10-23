//
//  FLConstants.h
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

// CocoaLumberjack logging level.
extern const int ddLogLevel;

// Default animation duration.
extern const NSTimeInterval kDefaultAnimationDuration;

// Default Input Scroll padding
extern const CGFloat kFormTopScrollPadding;

// GUID Alphabet
extern NSString *const kGUIDAlphabet;
// GUID length
extern const NSUInteger kGUIDLength;

/*********************************/
/* Constants got from info.plist */
/*********************************/
NSString *FLApiBaseUrl();
NSString *FLTestFairyAppToken();
NSString *FLCountryCode();
NSString *FLGoogleAnalyticsTrackingId();
NSString *FLGoogleAnalyticsPerformanceTrackingId();
NSString *FLConfigCountryPrefix();

// UA Keys
NSString *FLUADevelopmentAppKey();
NSString *FLUADevelopmentAppSecret();
NSString *FLUAProductionAppKey();
NSString *FLUAProductionAppSecret();
