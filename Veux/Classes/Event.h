//
//  Event.h
//  Veux
//
//  Created by mac on 10/21/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (nonatomic, strong) NSString* strUserName;
@property (nonatomic, strong) NSString* strEventType;
@property (nonatomic, strong) NSString* strDate;
@property (nonatomic, strong) NSString* strTime;
@property (nonatomic, strong) NSString* strDateTime;
@property (nonatomic, strong) NSString *strCost;
@property (nonatomic, strong) NSString *strWhere;
@property (nonatomic, strong) NSString *strLat;
@property (nonatomic, strong) NSString *strLong;
@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) NSString* strTickets;
@property (nonatomic, strong) NSString* strContactOrganizer;
@property (nonatomic, strong) NSData* imageData;
@property (nonatomic, strong) NSString* strDescription;
@property (nonatomic, strong) NSString* strLike;
@property (nonatomic, strong) NSString* strError;
@property (nonatomic, strong) NSString* strRankNum;
@property (nonatomic, assign) NSString* strPurchase;

- (BOOL) validateEvent;

@end
