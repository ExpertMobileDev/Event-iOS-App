//
//  DetailViewController.m
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "DetailViewController.h"
#import "LikeEventTableViewController.h"
#import "AppDelegate.h"
#import "EventListViewController.h"

@implementation DetailViewController

#define kRemoveAdsProductIdentifier @"put your product id (the one that we just made in iTunesConnect) in here"

- (void) viewDidLoad {
    [super viewDidLoad];

    self.detailView.layer.cornerRadius = 5;
    self.btnAccess.layer.cornerRadius = 5;
    self.btnDecline.layer.cornerRadius = 5;
    self.purchaseView.layer.cornerRadius = 5;
    

    productIdentifiers = [NSSet setWithObjects:@"com.redhouse.veux.premiumVIPEvents", nil];
    helper = [[IAPHelper alloc] initWithProductIdentifiers:productIdentifiers];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    if([SKPaymentQueue canMakePayments]){
        ////NSLog(@"can make payments");
        [self requestProUpgradeProductData];
    } else{
        ////NSLog(@"cannot make payments");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payments Disabled" message:@"In-App Purchases are disabled on this device." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionFailure:) name:IAPHelperProductPurchasedNotificationFailure object:nil];

    
    PFObject* curEvent = [[self appDelegate] getCurEvent];
    
    PFFile* imgFile = [curEvent objectForKey:@"event_imagefile"];
    NSData* data = [imgFile getData];
    UIImage* event_image = [UIImage imageWithData:data];
    [self.eventImgView setImage:event_image];
    
    NSString* strEventName = [curEvent objectForKey:@"event_name"];
    [self.lblEventName setText:strEventName];
    NSString* strEventDecription = [curEvent objectForKey:@"event_description"];
    [self.lblEventDescription setText:strEventDecription];
    NSString* strPostName = [curEvent objectForKey:@"user_name"];
    [self.lblEventPostName setText:strPostName];
    NSString* strEventDate = [curEvent objectForKey:@"event_date"];
    NSString* strEventTime = [curEvent objectForKey:@"event_time"];
    NSString* strEventDateTime = [strEventDate stringByAppendingString:@" at"];
    strEventDateTime = [strEventDateTime stringByAppendingString:strEventTime];
    [self.lblEventDate setText:strEventDateTime];
    NSString* strEventPlace = [curEvent objectForKey:@"event_Address"];
    [self.lblEventPlace setText:strEventPlace];
    NSString* strEventCost = [curEvent objectForKey:@"event_cost"];
    [self.lblEventCost setText:strEventCost];
    [self.lblRankingNum setText:[curEvent objectForKey:@"event_rank"]];
    
    bVIP = [[curEvent objectForKey:@"event_purchase"] boolValue];
    BOOL bPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"iap"] boolValue];
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    
    if (bVIP == NO || (bVIP == YES && bPurchase == YES) || ([strPostName isEqualToString:userName])) {
        [self.purchaseView setHidden:YES];
        [self.darkImgView setHidden:YES];
    }
    
}

- (IBAction)onBack:(id)sender {
    EventListViewController* eventListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
    [self.navigationController pushViewController:eventListVC animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (IBAction)gotoTableView:(id)sender {
    LikeEventTableViewController* likeEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikeEventTableVC"];
    [self.navigationController pushViewController:likeEventVC animated:YES];
}

- (IBAction)onYes:(id)sender {
    [helper buyProductWithProductIdentifier:@"com.redhouse.veux.premiumVIPEvents"];
}

- (IBAction)onDecline:(id)sender {
    EventListViewController* eventListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
    [self.navigationController pushViewController:eventListVC animated:NO];
    [UIView transitionWithView:self.navigationController.view duration:1.f options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


- (void)requestProUpgradeProductData
{
    NSLog(@"called  productsRequest");
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}


-(void) transactionFailure:(NSNotification *)notification {
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"iap"];
    SKPaymentTransaction * transaction = notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"%@", transaction.error.localizedDescription);
        EventListViewController* eventListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
        [self.navigationController pushViewController:eventListVC animated:NO];
        [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    }
    else if (transaction.error.code == SKErrorPaymentCancelled){
        EventListViewController* eventListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
        [self.navigationController pushViewController:eventListVC animated:NO];
        [UIView transitionWithView:self.navigationController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    }
}

-(void) productPurchased:(NSNotification*) notification {
    [self.purchaseView setHidden:YES];
    [self.darkImgView setHidden:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"iap"];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
}



@end
