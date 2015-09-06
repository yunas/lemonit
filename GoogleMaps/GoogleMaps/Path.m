//
//  Path.m
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import "Path.h"
#import "NSValue+CLLocationCoordinate2D.h"

@implementation Path

- (instancetype)initWithPaths:(NSDictionary *)data {
    
    self = [super init];
    
    if (self) {
     
        _startPoint = CLLocationCoordinate2DMake(24.979396, 55.143040);
        _endPoint = CLLocationCoordinate2DMake(24.989968, 55.145293);
        
        _routes = [self getRoute:data[@"steps"]];
        _pathForRoute = [self getPath];
    }
    
    return self;
}

- (NSArray *)getRoute:(NSArray *)data {
    
    NSMutableArray *route = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *step in data) {
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([step[@"start_location"][@"lat"] doubleValue], [step[@"start_location"][@"lng"] doubleValue]);
        [route addObject:[NSValue valueWithCLLocationCoordinate2D:coord]];
    }
    
    return route;
}

- (GMSPath *)getPath {
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (NSValue *marker in _routes) {
        [path addCoordinate:marker.CLLocationCoordinate2DValue];
    }
    return path;
}


@end
