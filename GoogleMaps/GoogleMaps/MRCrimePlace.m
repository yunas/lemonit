//
//  MRPlaces.m
//  GoogleMaps
//
//  Created by macbookpro on 06/09/2015.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

#import "MRCrimePlace.h"

@implementation MRCrimePlace

- (instancetype)initWithData:(NSDictionary *)dic {
    
    self = [super init];
    
    if (self) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy HH:mm";
        
        _crimeDate = [formatter dateFromString:dic[@"crimeDate"]];
        _crimeDescAr = dic[@"crimeDescAr"];
        _crimeDescEn = dic[@"crimeDescEn"];
        _crimeID = dic[@"crimeID"];
        _crimePriorityType = [dic[@"crimePriorityType"] integerValue];
        _lat = [dic[@"locationX"] doubleValue];
        _lon = [dic[@"locationY"] doubleValue];
    }
    
    return self;
}

+ (NSArray *)getPlacesList:(NSArray *)data {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary *dic in data) {
        MRCrimePlace *place = [[MRCrimePlace alloc] initWithData:dic];
        [array addObject:place];
    }
    return array;
}

@end