//
//  DivvyDataManager.h
//  CodeChallenge3
//
//  Created by Cameron Flowers on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DivvyDataDelegate <NSObject>

@optional
- (void)getDivvyData:(id)data;

@end

@interface DivvyDataManager : NSObject
@property (nonatomic, assign) id <DivvyDataDelegate> delegate;
@property NSString *masterDataURL;
@property NSDictionary *masterDictionary;
@property NSArray *stationBeanList;
@property NSMutableArray *divvyStations; 

- (void)requestData;
- (instancetype)initWithURL;
@end
