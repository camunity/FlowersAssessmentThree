//
//  DivvyStation.m
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "DivvyStation.h"

@implementation DivvyStation


-(instancetype)initWithName:(NSString *)name WithCoordinate:(CLLocationCoordinate2D) coordinate WithBikes:(NSInteger)bikesAvailable{

        self = [super init];
        if (self) {
            self.name = name;
            self.coordinate = coordinate;
            self.bikesAvailable = bikesAvailable;
        }
        return self;
    }

@end
