//
//  LikeEventTableViewController.h
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"


@interface LikeEventTableViewController : UIViewController<UIGestureRecognizerDelegate> {
    NSMutableArray* todayLikeEventArray;
    NSMutableArray* tomorrowLikeEventArray;
    NSMutableArray* futureLikeEventArray;
    
    NSMutableArray* selectEventArray;
    NSMutableArray* eventImgArray;
    
    int nStateIdx;
    CGFloat cellHeight;
}

@property (strong, nonatomic) IBOutlet UIImageView *todayTabImgView;
@property (strong, nonatomic) IBOutlet UIImageView *tomorrowTabImgView;
@property (strong, nonatomic) IBOutlet UIImageView *futureTabImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblToday;
@property (strong, nonatomic) IBOutlet UILabel *lblTomorrow;
@property (strong, nonatomic) IBOutlet UILabel *lblFuture;
@property (strong, nonatomic) IBOutlet UITableView *likeTableView;
@property (strong, nonatomic) IBOutlet UIView *futureView;
@property (strong, nonatomic) IBOutlet UIView *tomorrowView;
@property (strong, nonatomic) IBOutlet UIView *todayView;
- (IBAction)onBack:(id)sender;

@end
