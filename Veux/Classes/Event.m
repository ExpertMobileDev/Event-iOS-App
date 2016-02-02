//
//  Event.m
//  Veux
//
//  Created by mac on 10/21/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize strEventType, strDate, strTime, strCost, strWhere, strName, strLat, strLong;
@synthesize strTickets, strContactOrganizer, strDescription, imageData;

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.strLike = @"NO";
    self.strError = @"NONE";
    self.strRankNum = @"0";
    self.strPurchase = @"NO";
    return self;
}

- (BOOL) validateEvent {
    BOOL bValidate = YES;
    if ([strEventType isEqualToString:@""] || strEventType == nil) {
        bValidate = NO;
        self.strError = @"event type";
        return bValidate;
    }
    if ([strDate isEqualToString:@""] || strDate == nil) {
        bValidate = NO;
        self.strError = @"event date";
        return bValidate;
    }
    if ([strTime isEqualToString:@""] || strTime == nil) {
        bValidate = NO;
        self.strError = @"event time";
        return bValidate;
    }

    if ([strWhere isEqualToString:@""] || strWhere == nil) {
        bValidate = NO;
        self.strError = @"event place";
        return bValidate;
    }
    if ([strName isEqualToString:@""] || strName == nil) {
        bValidate = NO;
        self.strError = @"event name";
        return bValidate;
    }
    if ([strTickets isEqualToString:@""] || strTickets == nil) {
        bValidate = NO;
        self.strError = @"event ticket";
        return bValidate;
    }
    if ([strContactOrganizer isEqualToString:@""] || strContactOrganizer == nil) {
        bValidate = NO;
        self.strError = @"event contact organizer";
        return bValidate;
    }
    if ([strCost isEqualToString:@""] || strCost == nil) {
        bValidate = NO;
        self.strError = @"event cost";
        return bValidate;
    }
    if (imageData == nil) {
        bValidate = NO;
        self.strError = @"event image";
        return bValidate;
    }
    return bValidate;
}

@end
