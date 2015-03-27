//
//  DivvyPlacemark.h
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DivvyPlacemark : MKPlacemark
@property MKPointAnnotation *pointAnnotation;
@property CLLocation *divvyLocation;
-(instancetype)initWithLocation:(CLLocation*)location;
@end
