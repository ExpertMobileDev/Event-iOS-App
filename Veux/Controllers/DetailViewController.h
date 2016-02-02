//
//  DetailViewController.h
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"

@interface DetailViewController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate> {
    BOOL bVIP;
    IAPHelper* helper;
    NSSet *productIdentifiers;
}

@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEventPlace;
@property (strong, nonatomic) IBOutlet UILabel *lblEventCost;
@property (strong, nonatomic) IBOutlet UILabel *lblEventPostName;
@property (strong, nonatomic) IBOutlet UILabel *lblRankingNum;
@property (strong, nonatomic) IBOutlet UILabel *lblGroupNum;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *purchaseView;
@property (strong, nonatomic) IBOutlet UIButton *btnAccess;
@property (strong, nonatomic) IBOutlet UIButton *btnDecline;
@property (strong, nonatomic) IBOutlet UIImageView *darkImgView;

- (IBAction)onBack:(id)sender;
- (IBAction)gotoTableView:(id)sender;
- (IBAction)onYes:(id)sender;
- (IBAction)onDecline:(id)sender;

@end
