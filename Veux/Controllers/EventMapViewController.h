//
//  EventMapViewController.h
//  Veux
//
//  Created by mac on 10/28/15.
//  Copyright © 2015 Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"

@interface EventMapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    NSString* strLatitude, *strLongitude;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    AddressAnnotation *addAnnotation;
}
- (IBAction)onDone:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet MKMapView *mapEventLocationView;
@end
