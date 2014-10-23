//
//  MapBlockCell.m
//  Pancakes
//
//  Created by Leo on 22/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MapBlockCell.h"

@implementation MapBlockCell

- (void)layoutWithBlock:(Block *)block {
    if (block.latitude != nil && block.longitude != nil) {
        CLLocationDegrees lat = [block.latitude floatValue];
        CLLocationDegrees lng = [block.longitude floatValue];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lng)];
        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(30.0f, 30.0f))];
    }
}

@end
