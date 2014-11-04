//
//  MapEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 04/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MapEmbeddedBlock.h"
#import "Configuration.h"

@implementation MapEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    MKMapView* map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    // Embedded map
    map.scrollEnabled = NO;
//    [self addSubview:map];
    
    [map setCenterCoordinate:CLLocationCoordinate2DMake([block.latitude floatValue], [block.longitude floatValue]) animated:NO];
    
    // Adding a MKMapView on the content is blocking the UI thread while
    // loading, so we take a snapshot of the map view and displaying the image instead.
    // (for now, this is the best solution I think...)
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = map.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = map.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        UIImage *image = snapshot.image;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:map.frame];
        imageView.image = image;
        
        [self addSubview:imageView];
        
        // Embedded block title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
        title.textColor = kOrangeColor;
        title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
        title.textAlignment = NSTextAlignmentRight;
        title.text = block.title;
        [self addSubview:title];
    }];
    

   
}

@end
