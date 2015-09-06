//
//  MRMarker.h
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@class MRCrimePlace;
@class MRMarker;

typedef BOOL(^ShouldMoveToNextCrimeScene)(MRMarker *marker);
typedef void(^LocationMovement)(NSInteger index, CLLocationCoordinate2D newcoordinate, CLLocationDirection heading, CLLocationDistance distance);

@interface MRMarkerList : NSObject
@property (nonatomic, strong) NSArray *markers;
@property (nonatomic, strong) MRMarker *currentLocationMovementMarker;
@property (nonatomic, strong, readonly) GMSPath *pathForPlaces;
@property (nonatomic, copy) LocationMovement locationMovementBlock;
@property (nonatomic, strong) MRCrimePlace *POI;
@property (nonatomic, copy) ShouldMoveToNextCrimeScene shouldMoveToNextCrimeScene;

- (instancetype)initWithCrimePlaces:(NSArray *)places inMap:(GMSMapView *)map;
- (void)animateCurrentPositionMarker;
@end


#define kObjectReachedCrimePlaceNotification			@"Object Reached Crime Place Notification"
#define kObjectWillMoveNotification			@"Object Will Move Notification"
#define kObjectRechedEndOfPathNotification	@"Object Reached End of Path Notification"
#define kObjectRechedPOINotification        @"Object Reached POI of Path Notification"


@interface MRMarker : GMSMarker
@property (nonatomic, strong) MRCrimePlace *crimePlace;
- (instancetype)initWihPlace:(MRCrimePlace *)place;
@property (nonatomic, strong) UIColor *markerColor;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) CLLocationCoordinate2D lastReportedLocation;

@end


// To move on map
@interface CoordsList : NSObject
@property(nonatomic, readonly, copy) GMSPath *path;
@property(nonatomic, readonly) NSUInteger target;
- (id)initWithPath:(GMSPath *)path;
- (CLLocationCoordinate2D)next;

@end
