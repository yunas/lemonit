//
//  ViewController.m
//  GoogleMaps
//
//  Created by macbookpro on 05/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import "ViewController.h"
#import "MRCrimePlace.h"
#import "AJNotificationView.h"
#import "MRMarker.h"
#import "Path.h"

@import GoogleMaps;

typedef void (^DistanceCompletionBlock)(NSArray *routes, NSError *error);
#define walking @"kWalking"
#define automovile @"kAutomovile"

@interface ViewController () <GMSMapViewDelegate>

@end

@implementation ViewController {
    GMSMapView *mapView_;
    UIView *_contentView;
    MRMarkerList *list;
    Path *pathObj;
}

- (void)loadView {
    
    // Create a GMSCameraPosition that tells the map to display the
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(25.1625747, 55.2331551);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:position zoom:10];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    mapView_.mapType = kGMSTypeNormal;
    self.view = mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Crimes" ofType:@"plist"];
    NSArray *places = [NSDictionary dictionaryWithContentsOfFile:path][@"trafficcrimes"];
    
    NSArray *crimePlaces = [MRCrimePlace getPlacesList:places];
    
    list = [[MRMarkerList alloc] initWithCrimePlaces:crimePlaces inMap:mapView_];
    list.POI = crimePlaces[3];
    
    list.locationMovementBlock = (^(NSInteger index, CLLocationCoordinate2D newcoordinate, CLLocationDirection heading, CLLocationDistance distance){
        
        NSLog(@"direction: %f", distance);        
    });

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(POIReached:) name:kObjectRechedPOINotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachedAtCrimePlace:) name:kObjectReachedCrimePlaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willReachedAtCrimePlace:) name:kObjectWillMoveNotification object:nil];
    
//    [self getGoogelMapDirectionWithLat:24.898780 lngUser:55.069733 latDest:25.081755 lngDest:55.317613 transporType:automovile onCompletionBlock:^(NSArray *routes, NSError *error) {
//        
//        NSLog(@"Route: %@", routes);
//        
//        pathObj = [[Path alloc] initWithPaths:routes[0]];
//        
//        [self drawPathOnMap];
//        list.currentLocationMovementMarker.userData = [[CoordsList alloc] initWithPath:[pathObj pathForRoute]];
//        list.currentLocationMovementMarker.position = [pathObj startPoint];
//        
//        [list animateCurrentPositionMarker];
//    }];
    
    [self drawPathOnMap];

}

- (void)reachedAtCrimePlace:(NSNotification *)notification {
    
    GMSMarker *marker = [notification object];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:marker.title message:[NSString stringWithFormat:@"We have an active crime at %@",marker.snippet] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [list animateCurrentPositionMarker];
    }];
    
    [alert addAction:done];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)willReachedAtCrimePlace:(NSNotification *)notification {
    
//    MRCrimePlace *crimePlace = [notification object];
}

- (void)POIReached:(NSNotification *)notification {
    
    GMSMarker *marker = [notification object];
    
    [AJNotificationView hideCurrentNotificationView];
    [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeOrange title:[NSString stringWithFormat:@"%@ police station reached.",marker.title] hideAfter:2.5];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [list animateCurrentPositionMarker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawPathOnMap {
    
    GMSPolyline *poly = [GMSPolyline polylineWithPath:[list pathForPlaces]];
    poly.strokeWidth = 8;
    poly.geodesic = YES;
    poly.strokeColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.8];
    poly.map = mapView_;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//
//    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aeroplane"]];
//}

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker {
    
}


#pragma mark - Add Markers

-(void) getGoogelMapDirectionWithLat:(float)latUser
                             lngUser:(float)lngUser
                             latDest:(float)latDest
                             lngDest:(float)lngDest
                        transporType:(NSString *)transportType
                   onCompletionBlock:(DistanceCompletionBlock)onCompletion {
    
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=(%f,%f)&destination=(%f,%f)&key=AIzaSyCmTZPUaKIuep0AqMkVbUpDaO_AnYAr0Cc",latUser, lngUser, latDest, lngDest];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error = nil;
    NSArray *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error][@"routes"][0][@"legs"];
    onCompletion(response, nil);
    
    
    //https://maps.googleapis.com/maps/api/directions/json?origin=(24.898780,55.069733)&destination=(25.081755,55.317613)&key=AIzaSyCmTZPUaKIuep0AqMkVbUpDaO_AnYAr0Cc
}

@end
