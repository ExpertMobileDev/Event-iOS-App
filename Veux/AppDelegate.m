//
//  AppDelegate.m
//  Veux
//
//  Created by mac on 10/10/15.
//  Copyright (c) 2015 Jonas. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseTwitterUtils/PFTwitterUtils.h>
#import "AppConstant.h"
#import <Parse/PFUser.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
//@synthesize nSelWorkSiteIdx, workSiteArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // CGRect rect = [[UIScreen mainScreen] bounds];
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    m_strUserID = Identifier;
    
    [PFUser enableAutomaticUser];
    [Parse setApplicationId:kFBApplicationID clientKey:kFBClientKey];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    [PFTwitterUtils initializeWithConsumerKey:TwitterConsumerKey consumerSecret:TwitterConsumerSecret];
    
    [self setMapViewSetting];
    bSetAddress = NO;
    
    m_todayLikeEventArray = [[NSMutableArray alloc] init];
    m_tomorrowLikeEventArray = [[NSMutableArray alloc] init];
    m_futureLikeEventArray = [[NSMutableArray alloc] init];
    
    m_eventImgArray = [[NSMutableArray alloc] init];


    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                           didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (NSDate*) getLocalDateAndTime {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* localDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return localDate;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setUserId:(NSString*) strUserId {
    m_strUserID = strUserId;
}

-(NSString*)getUserId {
    return m_strUserID;
}

-(Event*) getSelEvent {
    return selEvent;
}
-(void) setSelEvent:(Event*) event {
    selEvent = event;
}

-(NSString*) getUserName {
    return curUserName;
}
-(void) setUserName:(NSString*) user {
    curUserName = user;
}

#pragma mark -- MapKitFramework--
- (void) setMapViewSetting
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER){
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
    
    [locationManager startUpdatingLocation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token  id  is  : %@",deviceToken);
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        strUserLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        strUserLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        [self setCurrentUserLocation:currentLocation];
        [self setUserLatAndLong:strUserLatitude andUserLong:strUserLongitude];
    }
}

- (void) setUserLatAndLong:(NSString*) _strLat andUserLong:(NSString*) _strLong {
    strUserLatitude = _strLat;
    strUserLongitude = _strLong;
}
- (NSString*) getUserLatitute {
    return strUserLatitude;
}

-(NSString*) getUserLongitude {
    return strUserLongitude;
}

- (void) setCurrentUserLocation:(CLLocation*) currLocation
{
    currentLocation = currLocation;
}

- (CLLocation*) getCurrUserLocation
{
    return currentLocation;
}

#pragma mark--event location--
- (void) setEventLatAndLong:(NSString*) _strLat andEventLong:(NSString*) _strLong {
    strEventLatitude = _strLat;
    strEventLongitude = _strLong;
}
- (NSString*) getEventLatitute {
    return strEventLatitude;
}

-(NSString*) getEventLongitude {
    return strEventLongitude;
}

- (void) setCurrentEventLocation:(CLLocation*) currLocation
{
    currentEventLocation = currLocation;
}

- (CLLocation*) getCurrEventLocation
{
    return currentEventLocation;
}

- (void) setEventAddress:(NSString*) eventAddress {
    curEventAddress = eventAddress;
}

- (NSString*) getEventAddress {
    return curEventAddress;
}

- (void) setAddressFlag:(BOOL) bFlag {
    bSetAddress = bFlag;
}

- (BOOL) getAddressFlag {
    return bSetAddress;
}

- (void) setSearchResultViaMiles:(NSMutableArray*) resultArray {
    searchResultViaMiles = resultArray;
}

- (NSMutableArray*) getSearchResultViaMiles {
    return searchResultViaMiles;
}

- (void) setSelectedIdx:(int) nIdx {
    nSelectedIdx = nIdx;
}

- (int) getSelectedIdx {
    return nSelectedIdx;
}

- (void) setLikeTodayEvent:(NSMutableArray*) todayLikeEventArray {
    m_todayLikeEventArray = todayLikeEventArray;
}

- (NSMutableArray*) getTodayLikeEventArry {
    return m_todayLikeEventArray;
}

- (void) setLikeTomorrowEvent:(NSMutableArray*) tomorrowLikeEventArray {
    m_tomorrowLikeEventArray = tomorrowLikeEventArray;
}

- (NSMutableArray*) getTomorrowLikeEventArry {
    return m_tomorrowLikeEventArray;
}

- (void) setLikeFutureEvent:(NSMutableArray*) futureLikeEventArray {
    m_futureLikeEventArray = futureLikeEventArray;
}

- (NSMutableArray*) getFutureLikeEventArry {
    return m_futureLikeEventArray;
}

- (void) setEventImage:(UIImage*) image {
    eventImage = image;
}

- (UIImage*) getEventImage {
    return eventImage;
}

- (void) setCurEvent:(PFObject*) event {
    curEvent = event;
}
- (PFObject*) getCurEvent {
    return curEvent;
}

- (void) setEventImgArray:(NSMutableArray*) eventImgArray {
    m_eventImgArray = eventImgArray;
}

- (NSMutableArray*) getEventImgArray {
    return m_eventImgArray;
}

@end
