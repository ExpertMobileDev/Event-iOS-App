//
//  EventListViewController.h
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"

@interface EventListViewController : UIViewController<DraggableViewDelegate> {
    NSMutableArray* eventSearchResult;
    int nSelIdx;
    int nIdx;
    UIImage* tempImg;
    NSDate* currentDate;
    
    NSMutableArray* todayLikeEventArray;
    NSMutableArray* tomorrowLikeEventArray;
    NSMutableArray* futureLikeEventArray;
    
    NSMutableArray* eventImgArray;

    NSMutableArray* allEvents;
    NSMutableArray *loadedEvents; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    int nDislikedIdx;
}

@property (strong, nonatomic) IBOutlet DraggableView *eventView;
@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnDislike;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPeople;
@property (strong, nonatomic) IBOutlet UILabel *lblRank;
@property (strong, nonatomic) IBOutlet UILabel *lblEventPostName;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UIButton *btnTriple;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIImageView *groupImgView;
@property (strong, nonatomic) IBOutlet UIImageView *rakingImgView;
- (IBAction)OnPreviousEvent:(id)sender;
- (IBAction)onDislike:(id)sender;
- (IBAction)onLike:(id)sender;
- (IBAction)onDetail:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)gotoTableView:(id)sender;

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end
