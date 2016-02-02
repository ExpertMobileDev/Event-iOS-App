//
//  SessionManager.m
//  Tadaa
//
//  Created by Yosemite on 5/12/15.
//  Copyright (c) 2015 Thomas Taussi. All rights reserved.
//

#import "SessionManager.h"
#import "TadaaUser.h"
#import "UserCircle.h"

@implementation SessionManager

static SessionManager *sharedSession;

+ (instancetype) currentSession {
    if (sharedSession == nil) {
        sharedSession = [[SessionManager alloc] init];
        sharedSession.circleArray = [[NSMutableArray alloc] init];
        sharedSession.friendStatusMap = [[NSMutableDictionary alloc] init];
        
        sharedSession.isInvitedFriend = [[NSUserDefaults standardUserDefaults] objectForKey:INVITE_FRIEND_FLAG] != nil;
    }
    
    return sharedSession;
}

- (void)setIsInvitedFriend:(BOOL)isInvitedFriend {
    _isInvitedFriend = isInvitedFriend;
    if (isInvitedFriend) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:INVITE_FRIEND_FLAG];
    }
}

- (void)setUserInfo:(TadaaUser *)userInfo {
    _userInfo = userInfo;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.facebookId forKey:TADAA_LOGIN_SESSION];
}

- (NSDictionary*) refreshCircleStatus:(NSArray*)circles {
    NSInteger unReadMsgCount = 0;
    NSInteger newInviteCount = 0;
    NSInteger inviteMsgCount = 0;
    
    for (NSDictionary *dic in circles) {
        UserCircle *circle = [[UserCircle alloc] initWithDictionary:dic];
        if ([circle.ownerId isEqualToString:self.userInfo.userId]) {
            unReadMsgCount += circle.ownerUnread;
        } else {
            inviteMsgCount += circle.inviterUnread;
            if ([circle.status isEqualToString:CIRCLE_STATUS_INVITED]) {
                newInviteCount++;
            }
        }
        
        for (UserCircle *myCircle in self.circleArray) {
            if ([myCircle.circleId isEqualToString:circle.circleId]) {
                myCircle.ownerUnread = circle.ownerUnread;
                myCircle.status = circle.status;
                break;
            }
        }
    }
    
    return @{@"unread":[NSNumber numberWithInteger:(unReadMsgCount + newInviteCount)],
             @"i_unread":[NSNumber numberWithInteger:inviteMsgCount],
             @"new_invites":[NSNumber numberWithInteger:newInviteCount]};
}

@end
