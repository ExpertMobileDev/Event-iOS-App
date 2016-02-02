//
//  AppDelegate.h
//  Veux
//
//  Created by mac on 10/10/15.
//  Copyright (c) 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import <Parse/Parse.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    NSString* m_strUserID;
    Event* selEvent;
    NSString *curUserName;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *strUserLatitude, *strUserLongitude;
    
    NSString *curEventAddress;
    CLLocation *currentEventLocation;
    NSString *strEventLatitude, *strEventLongitude;
    
    NSMutableArray* searchResultViaMiles;
    
    int nSelectedIdx;
    
    BOOL bSetAddress;
    
    NSMutableArray* m_todayLikeEventArray;
    NSMutableArray* m_tomorrowLikeEventArray;
    NSMutableArray* m_futureLikeEventArray;
    
    NSMutableArray* m_eventImgArray;
    
    UIImage* eventImage;
    PFObject* curEvent;
}

@property (strong, nonatomic) UIWindow *window;

-(void)setUserId:(NSString*) strUserId;
-(NSString*)getUserId;
-(NSDate*)getLocalDateAndTime;
-(Event*) getSelEvent;
-(void) setSelEvent:(Event*) event;
-(NSString*) getUserName;
-(void) setUserName:(NSString*) user;

- (void) setUserLatAndLong:(NSString*) _strLat andUserLong:(NSString*) _strLat;
- (NSString*) getUserLatitute;
- (NSString*) getUserLongitude;
- (void) setCurrentUserLocation:(CLLocation*) currUserLocation;
- (CLLocation*) getCurrUserLocation;

- (void) setEventLatAndLong:(NSString*) _strLat andEventLong:(NSString*) _strLat;
- (NSString*) getEventLatitute;
- (NSString*) getEventLongitude;
- (void) setCurrentEventLocation:(CLLocation*) currEventLocation;
- (CLLocation*) getCurrEventLocation;
- (void) setEventAddress:(NSString*) eventAddress;
- (NSString*) getEventAddress;

- (void) setAddressFlag:(BOOL) bFlag;
- (BOOL) getAddressFlag;

- (void) setSearchResultViaMiles:(NSMutableArray*) resultArray;
- (NSMutableArray*) getSearchResultViaMiles;

- (void) setSelectedIdx:(int) nIdx;
- (int) getSelectedIdx;

- (void) setLikeTodayEvent:(NSMutableArray*) todayLikeEventArray;
- (NSMutableArray*) getTodayLikeEventArry;

- (void) setLikeTomorrowEvent:(NSMutableArray*) tomorrowLikeEventArray;
- (NSMutableArray*) getTomorrowLikeEventArry;

- (void) setLikeFutureEvent:(NSMutableArray*) futureLikeEventArray;
- (NSMutableArray*) getFutureLikeEventArry;

- (void) setEventImage:(UIImage*) imageView;
- (UIImage*) getEventImage;

- (void) setCurEvent:(PFObject*) event;
- (PFObject*) getCurEvent;

- (void) setEventImgArray:(NSMutableArray*) eventImgArray;
- (NSMutableArray*) getEventImgArray;

@end

