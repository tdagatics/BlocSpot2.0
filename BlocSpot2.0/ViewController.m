//
//  ViewController.m
//  BlocSpot2.0
//
//  Created by Anthony Dagati on 11/12/14.
//  Copyright (c) 2014 Black Rail Capital. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.364506;
    zoomLocation.longitude = -71.057899;
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000, 10000);
    [_mapView setRegion:viewRegion animated:YES];
    _mapView.showsUserLocation = YES;

    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make the controller the delegate for the map view
    self.mapView.delegate = self;
    
    // Ensure you can see the user's location in the map view
    [self.mapView setShowsUserLocation:YES];
    
    // Instantiate a location object
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    // Make this controller the delegate for the location manager
    [locationManager setDelegate:self];
    
    // Set parameters for the location object
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (IBAction)searchButtonPressed:(id)sender {
    
    [self.searchTextField resignFirstResponder];
    NSString *searchString = self.searchTextField.text;
    NSLog(@"Just checking: %@", searchString);
    // Use the search string to build the URL query and get data from Google
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *item in response.mapItems) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = item.name;
            annotation.coordinate = item.placemark.coordinate;
            annotation.subtitle = [NSString stringWithFormat:@"%@, %@ %@",
                                   item.placemark.addressDictionary[@"Street"],
                                   item.placemark.addressDictionary[@"State"],
                                   item.placemark.addressDictionary[@"ZIP"]];
            [_mapView addAnnotation:annotation];
        }
    }];
}

#pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
