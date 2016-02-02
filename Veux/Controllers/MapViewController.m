//
//  MapViewController.m
//
//  Copyright (c) 2015 Spark. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"


@interface MapViewController ()
{
    GMSCameraPosition *_mapCamera;
    GMSMarker *_userMarker;
    NSMutableArray* _garageMarkers;
    NSArray* _placesArray;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchView.hidden = YES;
    self.searchBar.delegate = self;
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.placesTable.delegate = self;
    self.placesTable.dataSource = self;
    self.mapView.delegate = self;
//    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(revealToggle:)];
    [self.tapRecognizerView addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
    self.tapRecognizerView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onbtnSearchClicked:(id)sender {
    self.searchButton.hidden = YES;
    self.searchView.hidden = NO;
}

- (void) autoComplete:(NSString*)input {
    GMSPlacesClient* _placesClient = [[GMSPlacesClient alloc] init];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    
    [[GMSPlacesClient sharedClient] autocompleteQuery:input
                                               bounds:nil
                                               filter:nil
                                             callback:^(NSArray *results, NSError *error) {
                                                 _placesArray = results;
                                                 [self.placesTable reloadData];
                                                 if (error != nil) {
                                                     NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                                     return;
                                                 }
                                                 
                                             }];
    
}

#pragma mark - GMSMapViewDelegate
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    if (marker != _userMarker) {
        int index = (int)[_garageMarkers indexOfObject:marker];
        NSDictionary* garageInfo = [self.garagesArray objectAtIndex:index];
    }
    
    _mapView.selectedMarker = marker;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.3] forKey:kCATransactionAnimationDuration];
    _mapCamera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                             longitude:marker.position.longitude
                                                  zoom:self.mapView.camera.zoom];
    [self.mapView animateToCameraPosition:_mapCamera];
    [CATransaction commit];
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    int index = (int)[_garageMarkers indexOfObject:marker];
    NSDictionary* garageInfo = [self.garagesArray objectAtIndex:index];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"search text %@", searchText);
    if (searchText.length == 0) {
        [self.searchBar setShowsCancelButton:YES animated:YES];
    } else {
        [self.searchBar setShowsCancelButton:NO animated:YES];
    }

    [self autoComplete:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"SearchBar cancel button clicked");
    [self.searchBar setShowsCancelButton:NO animated:NO];
    self.searchView.hidden = YES;
    self.searchButton.hidden = NO;
    _placesArray = nil;
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_placesArray != nil) {
        return _placesArray.count;
    }
    return 0;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceTableCell"];
    GMSAutocompletePrediction* place = [_placesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = place.attributedFullText.string;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchButton.hidden = NO;
    self.searchView.hidden = YES;
    GMSAutocompletePrediction* place = [_placesArray objectAtIndex:indexPath.row];
    NSString* address = place.attributedFullText.string;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
            _mapCamera = [GMSCameraPosition cameraWithLatitude:aPlacemark.location.coordinate.latitude
                                                     longitude:aPlacemark.location.coordinate.longitude
                                                          zoom:14];
            [self.mapView setCamera:_mapCamera];
        }
    }];

}


@end
