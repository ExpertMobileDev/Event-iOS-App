//
//  SessionManager.h
//  Tadaa
//
//  Created by Yosemite on 5/12/15.
//  Copyright (c) 2015 Thomas Taussi. All rights reserved.
//
#import <Foundation/Foundation.h>

@class TadaaUser;

@interface SessionManager : NSObject

@property (nonatomic, retain) TadaaUser *userInfo;
@property (nonatomic, retain) NSMutableArray *circleArray;
@property (nonatomic, retain) NSMutableDictionary *friendStatusMap;

@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic) BOOL isInvitedFriend;

+ (instancetype) currentSession;

- (NSDictionary*) refreshCircleStatus:(NSArray*)circles;

@end
