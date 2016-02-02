//
//  NTRTwitterClient.h
//  TwitterLoginWithParseExample
//
//  Created by Natasha Murashev on 4/6/14.
//  Copyright (c) 2014 NatashaTheRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACAccount;

@interface NTRTwitterClient : NSObject

+ (void)loginUserWithAccount:(ACAccount *)twitterAccount;
+ (void)loginUserWithTwitterEngine;

@end
