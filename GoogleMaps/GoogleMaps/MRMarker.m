//
//  MRMarker.m
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import "MRMarker.h"
#import "MRCrimePlace.h"

@implementation MRMarkerList

- (instancetype)initWithCrimePlaces:(NSArray *)places inMap:(GMSMapView *)map {
    
    self = [super init];
    
    if (self) {
        
        [self markersList:places map:map];
        
        _currentLocationMovementMarker = [[MRMarker alloc] initWihPlace:places[0]];
        _currentLocationMovementMarker.map = map;
        _currentLocationMovementMarker.icon = [UIImage imageNamed:@"aeroplane"];
        _currentLocationMovementMarker.userData = [[CoordsList alloc] initWithPath:[self pathForPlaces]];
    }
    return self;
}

- (void)markersList:(NSArray *)places map:(GMSMapView *)map {
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:places.count];

    for (MRCrimePlace *place in places) {
        
        MRMarker *marker = [[MRMarker alloc] initWihPlace:place];
        marker.map = map;
        [data addObject:marker];
    }
    
    self.markers = data;
}

- (GMSPath *)pathForPlaces {
    
    GMSMutablePath *path = [GMSMutablePath path];

    for (MRMarker *marker in _markers) {
        [path addCoordinate:marker.position];
    }
    return path;
}

- (void)animateCurrentPositionMarker {
    
//    [self changeColourOfMarker:0 isDestination:NO];
    
    MRMarker *marker = _currentLocationMovementMarker;
    
    CoordsList *coords = marker.userData;
    CLLocationCoordinate2D coord = [coords next];
    CLLocationCoordinate2D previous = marker.position;
    
    marker.lastReportedLocation = previous;
    
    CLLocationDirection heading = GMSGeometryHeading(previous, coord);
    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
    
    // Use CATransaction to set a custom duration for this animation. By default, changes to the
    // position are already animated, but with a very short default duration. When the animation is
    // complete, trigger another animation step.
    
    double duration = distance / (5 * 1000);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:(duration)];  // custom duration, 5km/sec
    
    __weak MRMarkerList *weakSelf = self;
    [CATransaction setCompletionBlock:^{
        
        NSUInteger position = coords.target;
        
        NSLog(@"pos: %lu", (unsigned long)position);
        
        if ([self reachedAtPOI:position]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kObjectRechedPOINotification object:_currentLocationMovementMarker];
            [self changeColourOfMarker:position isDestination:YES];
            _currentLocationMovementMarker.isMoving = NO;
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kObjectReachedCrimePlaceNotification object:_currentLocationMovementMarker];

            [self changeColourOfMarker:position isDestination:NO];

//            BOOL proceed = weakSelf.shouldMoveToNextCrimeScene(_currentLocationMovementMarker);
//            
//            if (proceed) {
//                [weakSelf animateCurrentPositionMarker];
//            }
        }
    }];
    
    marker.position = coord;
    marker.isMoving = YES;
    
    [CATransaction commit];
    
    
    MRMarker *newCrimePlace = _markers[coords.target];
    [NSTimer scheduledTimerWithTimeInterval:duration-1 target:self selector:@selector(willReachToCrime:) userInfo:newCrimePlace.crimePlace repeats:NO];
    

    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
    if (marker.flat) {
        marker.rotation = heading;
    }
}

- (void)willReachToCrime:(NSTimer *)timer {
    
    MRCrimePlace *crimePlace = [timer userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kObjectWillMoveNotification object:crimePlace];
}

- (BOOL )reachedAtPOI:(NSUInteger)position  {
    
    BOOL reached = NO;
    
    CLLocationCoordinate2D poiPosition = CLLocationCoordinate2DMake(self.POI.lat, self.POI.lon);
    CLLocationCoordinate2D currentPosition = _currentLocationMovementMarker.position;
    
    CLLocationDistance distance = GMSGeometryDistance(poiPosition, currentPosition);
    
    if (distance == 0) {
        reached = YES;
    }
    
    if (_locationMovementBlock) {
        _locationMovementBlock(position, currentPosition, 0, distance);
    }
    
    return reached;
}

- (void)changeColourOfMarker:(NSUInteger)position isDestination:(BOOL)destination {
    
    MRMarker *marker = _markers[position];
    
    if (destination) marker.markerColor = [UIColor orangeColor];
    else marker.markerColor = [UIColor yellowColor];
}

@end



@implementation MRMarker

- (instancetype)initWihPlace:(MRCrimePlace *)place {
    
    self = [super init];
    
    if (self) {
        self.title = place.crimeDescAr;
        self.snippet = place.crimeDescEn;
        self.position = CLLocationCoordinate2DMake(place.lat, place.lon);
        self.infoWindowAnchor = CGPointMake(0.5, 0.5);
        self.crimePlace = place;
        self.tappable = YES;
        self.markerColor = [UIColor redColor];
    }
    return self;
}


- (void)setMarkerColor:(UIColor *)markerColor {
    
    _markerColor = markerColor;
    self.icon = [GMSMarker markerImageWithColor:_markerColor];
}
@end


@implementation CoordsList

- (id)initWithPath:(GMSPath *)path {
    if ((self = [super init])) {
        _path = [path copy];
        _target = 0;
    }
    return self;
}

- (CLLocationCoordinate2D)next {
    ++_target;
    if (_target == [_path count]) {
        _target = 0;
    }
    return [_path coordinateAtIndex:_target];
}

@end