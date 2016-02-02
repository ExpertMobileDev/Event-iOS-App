//
//  LikeTableCell.m
//  Veux
//
//  Created by mac on 08/11/15.
//  Copyright © 2015 Robert. All rights reserved.
//

#import "LikeTableCell.h"

@implementation LikeTableCell

- (void) drawCell:(NSString*) strUserName andRank:(NSString*) strRankNum andDate:(NSString*) strDate {
    [self.lblUserName setText:strUserName];
    [self.lblRankNum setText:strRankNum];
    [self.lblDate setText:strDate];
}

- (void) imageLoad:(UIImage *)backImg_ {
    [self.eventImgView setImage:backImg_];
}
@end
