//
//  Path.h
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface Path : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D startPoint;
@property (nonatomic, assign) CLLocationCoordinate2D endPoint;
@property (nonatomic, strong, readonly) NSArray *routes;
@property (nonatomic, strong, readonly) GMSPath *pathForRoute;

- (instancetype)initWithPaths:(NSDictionary *)data;

@end
