//
//  MapViewController.h
//
//  Copyright (c) 2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

//@import GoogleMaps;

@interface MapViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, GMSMapViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIView* tapRecognizerView;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;
@property (strong, nonatomic) IBOutlet UIView* searchView;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) IBOutlet UITableView* placesTable;
@property (strong, nonatomic) IBOutlet GMSMapView* mapView;
@property (strong, nonatomic) IBOutlet UIButton* sideBarButton;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSArray *garagesArray;
@property (nonatomic, strong) CLLocation *userLocation;



- (IBAction)onbtnMenuClicked:(id)sender;
- (IBAction)onbtnSearchClicked:(id)sender;

@end
