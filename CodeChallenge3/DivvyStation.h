//
//  DivvyStation.h
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DivvyStation : NSObject

//properties
@property NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property NSInteger bikesAvailable;

//methods
-(instancetype)initWithName:(NSString *)name WithCoordinate:(CLLocationCoordinate2D) coordinate WithBikes:(NSInteger)bikesAvailable;
@end
