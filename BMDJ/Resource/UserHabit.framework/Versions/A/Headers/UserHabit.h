//
//  Userhabit.h
//  Userhabit
//
//  Created by DoHyoungKim on 2015. 5. 18..
//  Copyright (c) 2015년 Andbut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for Userhabit.
FOUNDATION_EXPORT double UserHabitVersionNumber;

//! Project version string for Userhabit.s
FOUNDATION_EXPORT const unsigned char UserHabitVersionString[];

#pragma mark - User Information
// In this header, you should import all the public headers of your framework using statements like #import <Userhabit/PublicHeader.h>
typedef NS_ENUM(int, UHUserInfoGender) {
    UHUserInfoGenderUnuse = -1,
    UHUserInfoGenderMale = 1,
    UHUserInfoGenderFemale = 2,
    UHUserInfoGenderUncategorized = 3,
};

@class WKWebView;

typedef NSString *UHUserInformationKey NS_EXTENSIBLE_STRING_ENUM;

extern UHUserInformationKey _Nonnull const UHUserInformationGender;
extern UHUserInformationKey _Nonnull const UHUserInformationType;
extern UHUserInformationKey _Nonnull const UHUserInformationName;
extern UHUserInformationKey _Nonnull const UHUserInformationAge;

#pragma mark - UserHabit
@interface UserHabit : NSObject

+ (UserHabit * _Nonnull)sharedInstance;

/*!
 @brief It starts a session for UserHabit
 
 @discussion
    This method must use the application method in AppDelegate class
 
    And, you must change Product APIKey before this app release to App Store.
 
 @code
 // Objective C
 [UserHabit sessionStart:@"{{API KEY}}"];
 
 // Swift
 UserHabit.sessionStart("{{API KEY}}")
 
 @endcode
 
 @param  key APIKey by UserHabit app setting page
 */
+ (void)sessionStart:(nonnull NSString *)key;

/*!
 @brief It starts a session with an auto tracking option for UserHabit
 
 @discussion
 This method must use the application method in AppDelegate class
 
 And, you must change Product APIKey before this app release to App Store.
 
 If you want to turn off the auto tracking, you must set withAutoTracking prameter to <b>NO</b>.
 And, UserHabit SDK will not collect screens in auto.
 So, You must use setScreen method to collect normal data
 
 @code
 // Objective C
 [UserHabit sessionStart:@"{{API KEY}}" withAutoTracking: YES];
 
 // Swift
 UserHabit.sessionStart("{{API KEY}}", withAutoTracking: true)
 
 @endcode
 
 @param  key APIKey by UserHabit app setting page
 @param  YesOrNo sets auto tracking mode for screens
 */
+ (void)sessionStart:(nonnull NSString *)key withAutoTracking:(BOOL)YesOrNo;

/*!
 @brief Send the session data to the server manually
 
 @discussion
 Typically, the session data will be sent to the server after 10 seconds have elapsed since the app goes into the background.
 
 However, if the app process is forcibly terminated by using exit(0) or another forcibly terminating command, the session may not be terminated gracefully and data collection may fail.
 In this case, you can use -sessionCloseWithUploadData:completeHandler.
 
 When the method is called, the process of terminating the session will be performed. You can also set data transfer on/off using withUploadData. The process takes more than 50ms and takes about 100 ~ 300ms on average.
 After processing the data according to the parameter value, call the completeHandler as a block function. Please write your app exit code in the block function.
 
 @code
 // Objective C
 [UserHabit sessionCloseWithUploadData:YES completeHandler:^{ __USER CODE__ }];
 
 // Swift
 UserHabit.sessionClose(withUploadData: true) { __USER CODE__ }
 
 @endcode
 
 @param  isUpload           select upload session data
 @param  completeHandler    callback block
 */
+ (void)sessionCloseWithUploadData:(BOOL)isUpload completeHandler:(void(^_Nullable)(void))completeHandler;

/*!
 @brief This method sets session delay time by unit of seconds.
 
 @discussion 
 This method changes the session delay time using seconds unit.
 To use it, simply call [UserHabit setSessionDelayTime:5.0];

 @code
 // Objective C
 [UserHabit setSessionDelayTime:5.0];
 
 // Swift
 UserHabit.setSessionDelayTime(5.0)
 
 @endcode
 
 @param  delayInterval APIKey by UserHabit app setting page
 */
+ (void)setSessionDelayTime:(float)delayInterval;

/*!
 @brief This method takes a screenshot called it
 
 @code
 // Objective C
 [UserHabit takeScreenShot:self];
 
 // Swift
 UserHabit.takeScreenShot(self)
 
 @endcode
 
 @param  sender the viewcontroller instance
 */
+ (void)takeScreenShot:(id _Nonnull )sender;

/*!
 @brief This method starts start from user defined a screen.
 
 @code
 // Objective C
 [UserHabit setScreen:ViewController withName: @"{{Custom screen name}}"];
 
 // Swift
 UserHabit.setScreen(ViewController, withName: "{{Custom screen name}}")
 
                                                                                                                                                                       @endcode
 
 @param  viewController the viewcontroller instance
 @param  subViewName user defined screen name
*/
+ (void)setScreen:(UIViewController * _Nonnull)viewController withName:(NSString * _Nonnull)subViewName;

/*!
 @brief Register your scroll view
 
 @code
 // Objective C
 [UserHabit addScrollView:"{{Your Scroll View Name}}" scrollView:"UIScrollView" rootViewController:"UIViewController"];
 
 // Swift
 UserHabit.addScrollView("Your Scroll VIew Name", scrollView: UIScrollView, rootViewController: UIViewController)
 
 @endcode
 
 @param  scrollViewName user defined screen name
 @param  scrollView scroll view
 @param  rootViewController view controller 
 */

+ (void)addScrollView:(NSString * _Nonnull)scrollViewName scrollView:(UIScrollView * _Nonnull)scrollView rootViewController:(UIViewController * _Nonnull)rootViewController;


/*!
 @brief Register your scroll view
 
 @code
 // Objective C
 [UserHabit addWebView:"{{Your Web View}}"];
 
 // Swift
 UserHabit.addWebView("Your Web View")
 
 @endcode
 
 @param  webView analysis web view
 */
+ (void)addWebView:(WKWebView * _Nonnull )webView NS_SWIFT_NAME(addWebView(webview:));



/*!
 @brief This method exclude screens by class names in auto tracking mode
 
 @code
 // Objective C
 [UserHabit excludeClasses:excludeClasses];
 
 // Swift
 UserHabit.excludeClasses(excludeClasses)
 
 @endcode
 
 @param  excludeArray NSString Array to exclude
 */
+ (void)excludeClasses:(NSArray<__kindof NSString *> * _Nonnull)excludeArray;

/*!
 @brief This method use a random deviceid instead of an App UUID

 @discussion
 This method must use before Invoked SessionStart method
 */
+ (void)enableDeviceRandomID;

/*!
 @brief This method is for contents tracking
 @param action Value
 @param contentName Key
 */
+ (void)setContentKey:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;

/*!
 @brief ignore touch event
 @param viewObject set UIView or UIViewController
 */
+ (void)addSecretView:(id _Nonnull)viewObject;

/*!
 @brief ignore touch event
 
 @discussion
 If use secret mode true.
 all touch event ignore
 */

+ (void)secretMode:(BOOL)value;

/*!
 @brief This method sets userInfo (ex: custom id, gender and age)
 */
+ (void)setUserKey:(UHUserInformationKey _Nonnull )key value:(id _Nullable )value;

/*!
 @brief This method sets debug mode
 
 @discussion
 This method shows log messages to the console.
 It works Development Mode and Production Mode.
 So, Use carefully when you release the app to the production.
 
 @param debug if you want debug message set the YES.
 */
+ (void)setDebug:(BOOL)debug;



/*!
 @brief This method use custom options.
 
 @discussion
 Setting custom options.
 
 @code
 // Objective C
 [UserHabit setUserhabitOption:@{UHOptionScreenshotTapticFeedback:@YES}];
 
 // Swift
 UserHabit.setUserhabitOption([UHOptionScreenshotTapticFeedback : true]);
 */

extern NSString * _Nonnull const UHOptionScreenshotTapticFeedback;
extern NSString * _Nonnull const UHOptionScreenTime;
extern NSString * _Nonnull const UHOptionTrackingException;
extern NSString * _Nonnull const UHOptionRootWindow;

+ (void)setUserhabitOption:(NSDictionary * _Nonnull)options;

/*!
 @brief Check the SDK Version
 */
+ (void)version;

@end
