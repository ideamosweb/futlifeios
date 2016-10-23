//
//  FLConstants.m
//  FutLife
//
//  Created by Rene Santis on 10/16/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLConstants.h"

// CocoaLumberjack logging.
#ifdef DEBUG
int const ddLogLevel = LOG_LEVEL_VERBOSE;
#else
int const ddLogLevel = LOG_LEVEL_WARN;
#endif

// Default animation duration.
const NSTimeInterval kDefaultAnimationDuration = 0.3;

// Default Input Scroll padding
const CGFloat kFormTopScrollPadding = 10.0f;

NSString *const kGUIDAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
const NSUInteger kGUIDLength = 100;

NSString *FLApiBaseUrl()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"api.base.url"];
}

NSString *FLTestFairyAppToken()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"testFairy.appToken"];
}

NSString *FLCountryCode()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"config.CountryCode"];
}

NSString *FLGoogleAnalyticsTrackingId()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"googleAnalytics.trackerId"];
}

NSString *FLGoogleAnalyticsPerformanceTrackingId()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"googleAnalytics.performance.trackerId"];
}

NSString *FLConfigCountryPrefix()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"config.countryPrefix"];
}

/* Urban Airship keys */
NSString *FLUADevelopmentAppKey()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UADevelopmentAppKey"];
}

NSString *FLUADevelopmentAppSecret()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UADevelopmentAppSecret"];
}

NSString *FLUAProductionAppKey()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UAProductionAppKey"];
}

NSString *FLUAProductionAppSecret()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UAProductionAppSecret"];
}
