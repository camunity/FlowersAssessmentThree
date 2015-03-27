//
//  DivvyPlacemark.m
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "DivvyPlacemark.h"

@implementation DivvyPlacemark

-(instancetype)initWithLocation:(CLLocation*)location{
    self = [super init];
    if (self) {
        self.divvyLocation = location;
    }

    return self;
}


@end
