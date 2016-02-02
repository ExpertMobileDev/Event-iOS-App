//
//  LikeTableCell.h
//  Veux
//
//  Created by mac on 08/11/15.
//  Copyright © 2015 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblRankNum;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

- (void) drawCell:(NSString*) strUserName andRank:(NSString*) strRankNum andDate:(NSString*) strDate;
- (void) imageLoad:(UIImage *)backImg_;

@end
