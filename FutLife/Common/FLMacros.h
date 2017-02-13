//
//  FLMacros.h
//  FutLife
//
//  Created by Rene Santis on 10/17/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#ifndef FLMacros_h
#define FLMacros_h

/* Thanks to milanpanchal */
#pragma mark - Macros
/** Float: Degrees -> Radian **/
#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180.0)

/** Float: Radians -> Degrees **/
#define RADIANS_TO_DEGREES(radians) ((radians * 180.0)/ M_PI)

/** Float: Return screen width **/
#define SCREEN_WIDTH    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

/** Float: Return screen height **/
#define SCREEN_HEIGHT   ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || \
([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? \
[[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

/** Float: Navaigation Bar Height **/
#define NAVIGATION_BAR_DEFAULT_HEIGHT 44.0f


// Device Info
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER)) /** BOOL: Detect if device is an iPhone5 or not **/

#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)

#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)

#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

/** BOOL: Is iOS version is greater than or equal to specified version**/
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

/** BOOL: IS_RETINA **/
#define IS_RETINA_DEVICE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] >= 2)

/** BOOL: Is multi tasking support by device or not **/

#define IS_MULTI_TASKING_SUPPORTED ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported])

// Debugging / Logging
#ifdef DEBUG
#define debug(format, ...) \
CFShow((__bridge void *)[NSString stringWithFormat:@"%s [LINE: %d] ==>> " format,__PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__]);
#else
#define debug(format, ...)
#endif

#define debugBounds(view) debug(@"%@ bounds: %@", view, NSStringFromCGRect([view bounds]))
#define debugFrame(view)  debug(@"%@ frame: %@" , view, NSStringFromCGRect([view frame]))

/**
 
 Date formats:
 ===============
 MMM d, ''yy             Nov 4, '12
 'Week' w 'of 52'        Week 45 of 52
 'Day' D 'of 365'        Day 309 of 365
 m 'minutes past' h      9 minutes past 8
 h:mm a                  8:09 PM
 HH:mm:ss's'             20:09:00s
 HH:mm:ss:SS             20:09:00:00
 h:mm a zz               8:09 PM CST
 h:mm a zzzz             8:09 PM Central Standard Time
 yyyy-MM-dd HH:mm:ss Z	2012-11-04 20:09:00 -0600
 
 **/

#define DATE_FORMAT_YYYY_MM_DD_HH_MM_SS     @"yyyy-MM-dd HH:mm:ss"      //e.g. 1990-07-24 15:23:10
#define DATE_FORMAT_YYYY_MM_DD              @"yyyy-MM-dd"               //e.g. 1990-07-24

#define DATE_FORMAT_DD_MM_YYYY              @"dd-MM-yyyy"               //e.g. 24-07-1990
#define DATE_FORMAT_DD_MMM_YYYY             @"dd-MMM-yyyy"              //e.g. 24-Jul-1990
#define DATE_FORMAT_DD_MM_YYYY_HH_MM_12H    @"dd-MM-yyyy hh:mm a"       //e.g. 24-07-1990 05:20 AM
#define DATE_FORMAT_DD_MM_YYYY_HH_MM_SS     @"dd-MM-yyyy HH:mm:ss"      //e.g. 24-07-1990 15:20
#define DATE_FORMAT_DD_MM_YYYY_HH_MM_SS_12H @"dd-MM-yyyy hh:mm:ss a"    //e.g. 24-07-1990 05:20 AM

#define DATE_FORMAT_MM_DD_YYYY              @"MM-dd-yyyy"               //e.g. 07-24-1990
#define DATE_FORMAT_MMM_DD_YYYY             @"MMM dd, yyyy"             //e.g. Jul 24, 1990
#define DATE_FORMAT_MMMM_DD                 @"MMMM dd"                  //e.g. July 24
#define DATE_FORMAT_MMMM                    @"MMMM"                     //e.g. July, November
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_SS    @"MMM dd, yyyy hh:mm:ss a"  //e.g. Jul 24, 2014 05:20:50 AM
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_12H   @"MMM dd, yyyy hh:mm a"     //e.g. Jul 24, 2014 05:20 AM

#define DATE_FORMAT_HH_MM_SS                @"HH:mm:ss"                 //e.g. 15:20:50

#define DATE_FORMAT_E                       @"E"                        //e.g. Tue
#define DATE_FORMAT_EEEE                    @"EEEE"                     //e.g. Tuesday

#define DATE_FORMAT_QQQ                     @"QQQ"                      //e.g. Q1,Q2,Q3,Q4
#define DATE_FORMAT_QQQQ                    @"QQQQ"                     //e.g. 4th quarter


#endif /* FLMacros_h */
