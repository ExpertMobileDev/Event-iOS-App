//
//  FindEventViewController.m
//  Veux
//
//  Created by mac on 10/30/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "FindEventViewController.h"
#import "AppDelegate.h"
#import "EventListViewController.h"
#import "MBProgressHUD.h"
#import "LikeEventTableViewController.h"

@implementation FindEventViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.btnNext setEnabled:NO];
    
    self.btnNext.layer.cornerRadius = 5;
    
    tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchEventWith20mile:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.yellowImgView addGestureRecognizer:tripleTap];
    [self.plusImgView addGestureRecognizer:tripleTap];

    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchEventWith15mile:)];
    [doubleTap requireGestureRecognizerToFail:tripleTap];
    doubleTap.numberOfTapsRequired = 2;
    [self.yellowImgView addGestureRecognizer:doubleTap];
    [self.plusImgView addGestureRecognizer:doubleTap];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchEventWith10mile:)];
    [singleTap requireGestureRecognizerToFail:tripleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    singleTap.numberOfTapsRequired = 1;
    [self.yellowImgView addGestureRecognizer:singleTap];
    [self.plusImgView addGestureRecognizer:singleTap];

    
    eventImgArray = [[NSMutableArray alloc] init];
    currentLocation = [[self appDelegate] getCurrUserLocation];
    
    eventNearArray = [[NSMutableArray alloc] init];
    [self searchEventWith10mile:singleTap];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.btnNext setEnabled:NO];
    [eventNearArray removeAllObjects];
    [eventImgArray removeAllObjects];
}

- (void) searchEventWith10mile:(UITapGestureRecognizer*)sender {
    [eventImgArray removeAllObjects];
    [eventNearArray removeAllObjects];
    [self.circleImgView setHidden:NO];
    [self.circleImgView setImage:[UIImage imageNamed:@"1.png"]];
    self.circleImgView.layer.cornerRadius = 50;
    
    [self.circleImgView2 setHidden:YES];
    [self.circleImgView3 setHidden:YES];
    [self.lblMileAway setText:@"+10 miles away"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.0;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    
    [self.circleImgView.layer addAnimation:scaleAnimation forKey:@"scale"];

    PFGeoPoint* user_point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    PFQuery* eventQuery = [PFQuery queryWithClassName:@"Veux_Event"];
    [eventQuery whereKey:@"event_point" nearGeoPoint:user_point withinMiles:10];
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * events, NSError *error) {
        for (PFObject* event in events) {
            NSLog(@"Result-User-Name%@", [event objectForKey:@"user_name"]);
            NSString* string = [event objectForKey:@"event_name"];
            NSLog(@"event name:%@",string);
            [eventNearArray addObject:event];
        }
        [[self appDelegate] setSearchResultViaMiles:eventNearArray];
        if ([eventNearArray count] == 0) {
            [self.lblWarningMessage setText:@"There is no event in 10 miles away."];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    [self.btnNext setEnabled:YES];
                    
                } completion:nil];
                
            }];
        }
        else {
            
            for (PFObject* event in eventNearArray) {
                NSString* string = [event objectForKey:@"event_name"];
                NSLog(@"event name:%@",string);

                PFFile* imgFile = [event objectForKey:@"event_imagefile"];
                NSData* data = [imgFile getData];
                event_image = [UIImage imageWithData:data];
                [eventImgArray addObject:event_image];

            }
            
            
            [self.lblWarningMessage setText:[NSString stringWithFormat:@"There are %d events in 10 miles away.", (int)[eventNearArray count]]];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    [self.btnNext setEnabled:YES];
                } completion:nil];
                
            }];
        }
    }];
    
 }

- (void) searchEventWith15mile:(UITapGestureRecognizer*)sender {
    [eventNearArray removeAllObjects];
    [eventImgArray removeAllObjects];
    [self.lblMileAway setText:@"+15 miles away"];
    
    [self.circleImgView2 setHidden:NO];

    [self.circleImgView setImage:[UIImage imageNamed:@"1.png"]];
    self.circleImgView.layer.cornerRadius = 50;
    [self.circleImgView2 setImage:[UIImage imageNamed:@"2.png"]];
    self.circleImgView2.layer.cornerRadius = 50;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.0;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = 1.0;
    scaleAnimation2.repeatCount = HUGE_VAL;
    scaleAnimation2.autoreverses = YES;
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:0.8];
    
    [self.circleImgView.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.circleImgView2.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    [self.btnNext setEnabled:NO];
    
    PFGeoPoint* user_point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    PFQuery* eventQuery = [PFQuery queryWithClassName:@"Veux_Event"];
    [eventQuery whereKey:@"event_point" nearGeoPoint:user_point withinMiles:15];
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * events, NSError *error) {
        [self.btnNext setEnabled:YES];
        for (PFObject* event in events) {
            NSLog(@"Result-User-Name%@", [event objectForKey:@"user_name"]);
            [eventNearArray addObject:event];
        }
        
        [[self appDelegate] setSearchResultViaMiles:eventNearArray];
        if ([eventNearArray count] == 0) {
            [self.lblWarningMessage setText:@"There is no event in 15 miles away."];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    
                } completion:nil];
            }];

        }
        else {
            for (PFObject* event in eventNearArray) {
                PFFile* imgFile = [event objectForKey:@"event_imagefile"];
                NSData* data = [imgFile getData];
                event_image = [UIImage imageWithData:data];
                [eventImgArray addObject:event_image];
            }
            
            [self.lblWarningMessage setText:[NSString stringWithFormat:@"There are %d events in 15 miles away.", (int)[eventNearArray count]]];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    
                } completion:nil];
                
            }];
        }
    }];
    
}

- (void) searchEventWith20mile:(UITapGestureRecognizer*)sender {
    
    [eventImgArray removeAllObjects];
    [eventNearArray removeAllObjects];
    [self.lblMileAway setText:@"+20 miles away"];
    
    [self.circleImgView2 setHidden:NO];
    [self.circleImgView3 setHidden:NO];
    
    [self.circleImgView setImage:[UIImage imageNamed:@"1.png"]];
    self.circleImgView.layer.cornerRadius = 50;
    [self.circleImgView2 setImage:[UIImage imageNamed:@"2.png"]];
    self.circleImgView2.layer.cornerRadius = 50;
    [self.circleImgView3 setImage:[UIImage imageNamed:@"3.png"]];
    self.circleImgView3.layer.cornerRadius = 50;
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.0;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.8];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.duration = 1.0;
    scaleAnimation2.repeatCount = HUGE_VAL;
    scaleAnimation2.autoreverses = YES;
    scaleAnimation2.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation2.toValue = [NSNumber numberWithFloat:0.8];
    
    CABasicAnimation *scaleAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation3.duration = 1.0;
    scaleAnimation3.repeatCount = HUGE_VAL;
    scaleAnimation3.autoreverses = YES;
    scaleAnimation3.fromValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation3.toValue = [NSNumber numberWithFloat:0.8];

    [self.circleImgView.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.circleImgView2.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.circleImgView3.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    [self.btnNext setEnabled:NO];
    
    PFGeoPoint* user_point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    PFQuery* eventQuery = [PFQuery queryWithClassName:@"Veux_Event"];
    [eventQuery whereKey:@"event_point" nearGeoPoint:user_point withinMiles:20];
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * events, NSError *error) {
        [self.btnNext setEnabled:YES];
        for (PFObject* event in events) {
            NSLog(@"Result-User-Name%@", [event objectForKey:@"user_name"]);
            [eventNearArray addObject:event];
        }
        [[self appDelegate] setSearchResultViaMiles:eventNearArray];
        if ([eventNearArray count] == 0) {
            [self.lblWarningMessage setText:@"There are no event in 20 miles away."];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    
                } completion:nil];
                
            }];
        }
        else {
            for (PFObject* event in eventNearArray) {
                PFFile* imgFile = [event objectForKey:@"event_imagefile"];
                NSData* data = [imgFile getData];
                event_image = [UIImage imageWithData:data];
                [eventImgArray addObject:event_image];
            }

            [self.lblWarningMessage setText:[NSString stringWithFormat:@"There are %d events in 20 miles away.", (int)[eventNearArray count]]];
            [UIView animateWithDuration:2.0f animations:^{
                
                [self.lblWarningMessage setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                
                //fade out
                [UIView animateWithDuration:2.0f animations:^{
                    
                    [self.lblWarningMessage setAlpha:0.0f];
                    
                } completion:nil];
                
            }];
        }
    }];
}


- (void) getLikeEventArray {
    PFQuery* eventQuery = [PFQuery queryWithClassName:@"Veux_Event"];
    [eventQuery whereKey:@"event_like" equalTo:@"YES"];
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * events, NSError *error) {
        [self.btnNext setEnabled:YES];
        for (PFObject* event in events) {
            NSLog(@"Result-User-Name%@", [event objectForKey:@"user_name"]);
            //[eventNearArray addObject:event];
        }
    }];
}


- (IBAction)obBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoLikeTable:(id)sender {
    LikeEventTableViewController* likeEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LikeEventTableVC"];
    [self.navigationController pushViewController:likeEventVC animated:YES];
}

- (IBAction)onNext:(id)sender {
    if ([eventNearArray count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"VEUX" message:@"There are no events in your area(in 10 miles)." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
         return;
    }
    

    [[self appDelegate] setEventImgArray:eventImgArray];
    EventListViewController* eventListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
    [self.navigationController pushViewController:eventListVC animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

@end
