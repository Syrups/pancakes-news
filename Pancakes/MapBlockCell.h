//
//  MapBlockCell.h
//  Pancakes
//
//  Created by Leo on 22/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "GenericBlockCell.h"
#import <MapKit/MapKit.h>

@interface MapBlockCell : GenericBlockCell

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
