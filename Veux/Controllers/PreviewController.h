//
//  PreviewController.h
//  Veux
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface PreviewController : UIViewController<UIGestureRecognizerDelegate> {
    Event* event_preview;
    CGFloat lastScale;
    CGFloat _firstX, _firstY;
    UIImage* eventImage;
    CAShapeLayer* _marque;
}

@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblEventType;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEventCost;
@property (strong, nonatomic) IBOutlet UILabel *lblEventPlace;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblTickets;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnPost;
@property (strong, nonatomic) IBOutlet UIView *purchaseView;
@property (strong, nonatomic) IBOutlet UIButton *btnYES;
@property (strong, nonatomic) IBOutlet UIButton *btnNo;
@property (strong, nonatomic) IBOutlet UIImageView *darkImgView;
- (IBAction)onYes:(id)sender;
- (IBAction)onDecline:(id)sender;


- (IBAction)onPost:(id)sender;
- (IBAction)onBack:(id)sender;
- (void) setPreviewEvent:(Event*) event;

@end
