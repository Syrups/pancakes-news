//
//  Utils.h
//  Pancakes
//
//  Created by Leo on 12/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface Utils : NSObject

+ (UIColor*) colorWithHexString:(NSString*)hex;
+ (CGPoint) pointOnCircleWithCenter: (CGPoint) center  withRadius:(float)radius withAngle:(float)angle;
+ (NSURL *) fetchFacebookUserProfilePictureURL : (id<FBGraphUser>) user;

+ (void ) setImageWithFacebook : (id<FBGraphUser>) user imageview:(UIImageView*)imageView blur:(BOOL)blur;
+ (void ) setPlaceHolderImage : (UIImageView*)imageView blur:(BOOL)blur;
@end
