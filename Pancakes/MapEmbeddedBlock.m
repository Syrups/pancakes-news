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
    

    // Embedded map
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"leoht.kcag6ani"];
    RMMapView* map = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) andTilesource:tileSource];
    map.delegate = self;
    
    [map setCenterCoordinate:CLLocationCoordinate2DMake(block.latitude.floatValue, block.longitude.floatValue)];
    [map setZoom:4.0f atCoordinate:map.centerCoordinate animated:NO];
//    map.userInteractionEnabled = NO;
    
    RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:map
                                                           coordinate:map.centerCoordinate
                                                             andTitle:block.title];
    
    annotation1.userInfo = @"small";
    
    [map addAnnotation:annotation1];
    
    [self addSubview:map];
    
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = block.title != nil ? block.title : @"Map";

    [self addSubview:title];
    [self bringSubviewToFront:title];
    
    

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        
//        map.scrollEnabled = NO;
//        //    [self addSubview:map];
//        
//        [map setCenterCoordinate:CLLocationCoordinate2DMake([block.latitude floatValue], [block.longitude floatValue]) animated:NO];
//        
//        // Adding a MKMapView on the content is blocking the UI thread while
//        // loading, so we take a snapshot of the map view and displaying the image instead.
//        // (for now, this is the best solution I think...)
//        
//        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
//        options.region = map.region;
//        options.scale = [UIScreen mainScreen].scale;
//        options.size = map.frame.size;
//        
//        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
//        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *image = snapshot.image;
//                UIImageView* imageView = [[UIImageView alloc] initWithFrame:map.frame];
//                imageView.image = image;
//                
//                [self addSubview:imageView];
//                [self sendSubviewToBack:imageView];
//            });
//            
//        }];
//
//    });
   
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker;
    
    if ([annotation.userInfo isEqualToString:@"small"])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"map-marker"]];
    }
    else if ([annotation.userInfo isEqualToString:@"big"])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"map-marker"]];
    }
    
    marker.canShowCallout = YES;
    
    return marker;
}

@end
