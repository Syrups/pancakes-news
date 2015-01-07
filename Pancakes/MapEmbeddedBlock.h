//
//  MapEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 04/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DefinitionEmbeddedBlock.h"
#import <Mapbox-iOS-SDK/Mapbox.h>

@interface MapEmbeddedBlock : DefinitionEmbeddedBlock <RMMapViewDelegate>

@property (strong, nonatomic) UILabel* title;

@end
