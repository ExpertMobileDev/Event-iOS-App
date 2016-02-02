//
//  PreviewController.m
//  Veux
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "PreviewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "HomeViewController.h"

@implementation PreviewController

- (void) viewDidLoad {
    [super viewDidLoad];
    event_preview = [[self appDelegate] getSelEvent];
    
    [self.lblEventType setText:event_preview.strEventType];
    [self.lblEventDate setText:event_preview.strDate];
    [self.lblEventTime setText:event_preview.strTime];
    [self.lblEventCost setText:event_preview.strCost];
    [self.lblEventPlace setText:event_preview.strWhere];
    [self.lblEventName setText:event_preview.strName];
    [self.lblTickets setText:event_preview.strTickets];
    [self.lblContact setText:event_preview.strContactOrganizer];
    
    self.btnYES.layer.cornerRadius = 5;
    self.btnNo.layer.cornerRadius = 5;
    self.purchaseView.layer.cornerRadius = 5;
    
    eventImage = [UIImage imageWithData:event_preview.imageData];
    [self.eventImgView setImage:eventImage];
    
    [self.btnPost setEnabled:YES];
    [self.purchaseView setHidden:YES];
    [self.darkImgView setHidden:YES];
}

- (IBAction)onYes:(id)sender {
    event_preview.strPurchase = @"YES";
    [self postEvent];
}

- (IBAction)onDecline:(id)sender {
    event_preview.strPurchase = @"NO";
    [self postEvent];
}

- (IBAction)onPost:(id)sender {
    [self.btnPost setEnabled:NO];
    NSString* userName = [[self appDelegate] getUserName];
    if (!userName) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:@"User name is nil!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.purchaseView setHidden:NO];
    [self.darkImgView setHidden:NO];
    [self.btnBack setEnabled:NO];
    [self.btnPost setEnabled:NO];
    [self.view bringSubviewToFront:self.purchaseView];
}

- (void) postEvent {
    PFGeoPoint *event_point = [PFGeoPoint geoPointWithLatitude:[event_preview.strLat doubleValue] longitude:[event_preview.strLong doubleValue]];
    
    PFObject *event = [PFObject objectWithClassName:@"Veux_Event"];
    [event setObject:[[self appDelegate] getUserName] forKey:@"user_name"];
    [event setObject:event_preview.strEventType forKey:@"event_type"];
    [event setObject:event_preview.strDate forKey:@"event_date"];
    [event setObject:event_preview.strTime forKey:@"event_time"];
    [event setObject:event_preview.strDateTime forKey:@"event_datetime"];
    [event setObject:event_preview.strCost forKey:@"event_cost"];
    [event setObject:event_point forKey:@"event_point"];
    [event setObject:event_preview.strWhere forKey:@"event_Address"];
    [event setObject:event_preview.strName forKey:@"event_name"];
    [event setObject:event_preview.strTickets forKey:@"event_tickets"];
    [event setObject:event_preview.strContactOrganizer forKey:@"event_contact"];
    [event setObject:event_preview.strDescription forKey:@"event_description"];
    [event setObject:event_preview.strLike forKey:@"event_like"];
    [event setObject:event_preview.strRankNum forKey:@"event_rank"];
    [event setObject:event_preview.strPurchase forKey:@"event_purchase"];
    
    NSData* imageData = UIImageJPEGRepresentation(self.eventImgView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", event_preview.strName];
    PFFile* imageFile = [PFFile fileWithName:filename data:imageData];
    [event setObject:imageFile forKey:@"event_imagefile"];
    
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    // Upload recipe to Parse
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
            HomeViewController* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
            [self.navigationController pushViewController:homeVC animated:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.btnPost setEnabled:YES];
        }
        
    }];
    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setPreviewEvent:(Event*) event{
    event_preview = event;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


@end
