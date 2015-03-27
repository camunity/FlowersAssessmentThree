//
//  DivvyDataManager.m
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "DivvyDataManager.h"
#import "DivvyStation.h"

@implementation DivvyDataManager

- (instancetype)initWithURL{
    self = [super init];
    if (self) {
        self.masterDataURL = @"http://www.divvybikes.com/stations/json/";
    }

    return self;
}

- (void)requestData:(CLLocation *)location {

    self.divvyStations = [NSMutableArray new];

    NSString *urlText = self.masterDataURL;
    NSURL *url = [NSURL URLWithString:urlText];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

    self.masterDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&connectionError];
                               NSLog(@"Data Received. Beginning To Process");

                               self.stationBeanList = [self.masterDictionary objectForKey:@"stationBeanList"];
                               for(NSDictionary *dict in self.stationBeanList){

                                   NSString *name = dict[@"stationName"];
                                   NSString *latitude = dict[@"latitude"];
                                   NSString *longitude = dict[@"longitude"];
                                   NSString *bikesAvailable = dict[@"availableBikes"];

                                   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                                   CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                                   CLLocationDistance distance = [location distanceFromLocation:loc];

                                DivvyStation *divvyStation = [[DivvyStation alloc] initWithName:name WithCoordinate:coordinate WithBikes:bikesAvailable.integerValue];
                                   divvyStation.distanceFromUser = distance;
                                   [self.divvyStations addObject:divvyStation];
                               }
                               NSLog(@"%li", self.divvyStations.count);
                               NSSortDescriptor *sort;
                               sort = [[NSSortDescriptor alloc]initWithKey:@"distanceFromUser" ascending:YES];
                               NSArray *sortArray = [NSArray arrayWithObject:sort];
                               NSArray *sortedArray;
                               sortedArray = [self.divvyStations sortedArrayUsingDescriptors:sortArray];
                               [self.delegate getDivvyData:sortedArray];
                           }];
    
}




@end
