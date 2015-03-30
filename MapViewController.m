//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DivvyPlacemark.h"

float const CHLatitude = 41.8468;
float const CHLongitude = -87.6847;

@interface MapViewController () <MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *divvyStationAnnotation;
@property NSMutableString *alertMessage;
@property DivvyPlacemark *divvyStationPlacemark;
@property MKMapItem *destination;
@property CLLocation *divvyLocation;
@property MKPlacemark *divvyMKPlacemark;
@property NSArray *distance; 
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;

    [self displayUserLocation];
    self.divvyStationAnnotation = [MKPointAnnotation new];
    self.divvyStationAnnotation.title = self.divvyStation.name;
    self.divvyStationAnnotation.coordinate = self.divvyStation.coordinate;
    [self.mapView addAnnotation:self.divvyStationAnnotation];
    self.divvyMKPlacemark = [[MKPlacemark alloc]
                        initWithCoordinate:self.divvyStation.coordinate
                        addressDictionary:nil];
    [self centerOnStation];

}

-(void)displayUserLocation{
    self.mapView.showsUserLocation = YES;
}


-(void)addAnnotation:(CLPlacemark *)placemark{
    MKPointAnnotation *divvyMKPA = [[MKPointAnnotation alloc] init];
    divvyMKPA.coordinate = self.divvyStation.coordinate;
    divvyMKPA.title = self.divvyStation.name;
    divvyMKPA.subtitle = [NSString stringWithFormat:@"%li,",self.divvyStation.bikesAvailable];
    [self.mapView addAnnotation:divvyMKPA];
}

-(void)setDivvyStationLocation{
    MKMapItem *temp = [[MKMapItem alloc] initWithPlacemark:self.divvyStationPlacemark];
    self.destination = temp;
}



-(void)centerOnStation{

    CLLocationCoordinate2D centerCoordinate = self.divvyStationAnnotation.coordinate;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.05;
    coordinateSpan.longitudeDelta = 0.05;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"Tapped!");
    [self requestDirections];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    if (![annotation isEqual:mapView.userLocation]) {
        pin.image = [UIImage imageNamed:@"bikeImage"];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    }
    else{
        return nil;
    }
}


-(void)requestDirections{
    self.alertMessage = [NSMutableString new];
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:self.divvyMKPlacemark];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;

    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route = response.routes.firstObject;

        NSMutableString *routeString = [NSMutableString new];
        int counter = 1;

        for (MKRouteStep *step in route.steps) {

            [routeString appendFormat:@"%d: %@ in %.0f meters \n", counter, step.instructions, step.distance];
            counter++;

        }

        self.alertMessage = routeString;
        [self showAlert];
    }];
    
}



-(void)showAlert{
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Directions"
                                                       message:self.alertMessage
                                                      delegate:self
                                             cancelButtonTitle:@"Dismiss"
                                             otherButtonTitles: nil];
        [alert show];
    }

}


@end
