//
//  FindEventViewController.h
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FindEventViewController : UIViewController {
    CLLocation *currentLocation;
    NSMutableArray* eventNearArray;
    UIImage* event_image;
    NSMutableArray* eventImgArray;
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UITapGestureRecognizer *tripleTap;
}


@property (strong, nonatomic) IBOutlet UILabel *lblWarningMessage;
@property (strong, nonatomic) IBOutlet UIImageView *circleImgView2;
@property (strong, nonatomic) IBOutlet UIImageView *circleImgView3;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIImageView *circleImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblMileAway;
@property (strong, nonatomic) IBOutlet UIImageView *plusImgView;
@property (strong, nonatomic) IBOutlet UIImageView *yellowImgView;
- (IBAction)obBack:(id)sender;
- (IBAction)gotoLikeTable:(id)sender;

- (IBAction)onNext:(id)sender;

@end
