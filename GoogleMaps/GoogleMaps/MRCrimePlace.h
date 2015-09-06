//
//  MRPlaces.h
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCrimePlace : NSObject
@property (nonatomic, strong) NSDate *crimeDate;
@property (nonatomic, strong) NSString *crimeDescAr;
@property (nonatomic, strong) NSString *crimeDescEn;
@property (nonatomic, strong) NSString *crimeID;
@property (nonatomic, assign) NSInteger crimePriorityType;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;

+ (NSArray *)getPlacesList:(NSArray *)data;
- (instancetype)initWithData:(NSDictionary *)dic;

@end
