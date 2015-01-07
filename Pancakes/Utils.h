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

+ (UIView*) addDropShadowToView: (UIView *)view ;
+ (UIImage *)imageByCroppingImage:(UIImage *)chosenImage toSize:(CGSize)size;
@end

/*
@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
*/