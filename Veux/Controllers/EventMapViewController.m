//
//  EventMapViewController.m
//  Veux
//
//  Created by mac on 10/28/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import "EventMapViewController.h"
#import "AppDelegate.h"
#import "AddressAnnotation.h"

@implementation EventMapViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    addAnnotation = [AddressAnnotation alloc];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    lpgr.minimumPressDuration = 1.0;
    [self.mapEventLocationView addGestureRecognizer:lpgr];
    
    self.btnDone.layer.cornerRadius = 5;
    
    [self setMapViewSetting];
}

- (void) setMapViewSetting
{
    currentLocation = [[self appDelegate] getCurrUserLocation];
    
    if (currentLocation != nil) {
        strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        CLLocationCoordinate2D ctrpoint = currentLocation.coordinate;
        addAnnotation = [addAnnotation initWithCoordinate:ctrpoint];
        [self.mapEventLocationView addAnnotation:addAnnotation];
    }
    
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = currentLocation.coordinate.latitude;
    mapCenter.longitude = currentLocation.coordinate.longitude;
    
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.5;
    mapSpan.longitudeDelta = 0.5;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    self.mapEventLocationView.delegate = self;
    self.mapEventLocationView.region = mapRegion;
    self.mapEventLocationView.mapType = MKMapTypeStandard;
    self.mapEventLocationView.showsUserLocation = YES;
}


// ---------------------------------

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapEventLocationView];
    CLLocationCoordinate2D touchCoordinate = [self.mapEventLocationView convertPoint:touchPoint toCoordinateFromView:self.mapEventLocationView];
    NSLog(@"%f, %f", touchCoordinate.latitude, touchCoordinate.longitude);
    addAnnotation = [addAnnotation initWithCoordinate:touchCoordinate];
    [self.mapEventLocationView addAnnotation:addAnnotation];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:touchCoordinate.latitude longitude:touchCoordinate.longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         [self.lblAddress setText:locatedAt];
         
         [[self appDelegate] setEventAddress:locatedAt];
         [[self appDelegate] setCurrentEventLocation:loc];
         [[self appDelegate] setEventLatAndLong:[NSString stringWithFormat:@"%f",touchCoordinate.latitude] andEventLong:[NSString stringWithFormat:@"%f",touchCoordinate.longitude]];
         [[self appDelegate] setAddressFlag:YES];
     }];
}

- (AppDelegate*) appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


- (IBAction)onDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
