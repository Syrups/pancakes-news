//
//  Utils.m
//  Pancakes
//
//  Created by Leo on 12/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Utils.h"
#import <FacebookSDK/FacebookSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import "UIImage+StackBlur.h"
#import "FXBlurView.h"

@implementation Utils

+ (UIColor*) colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (CGPoint) pointOnCircleWithCenter: (CGPoint) center  withRadius:(float)radius withAngle:(float)angle {
    
    CGFloat x = center.x + radius * cos(angle);
    CGFloat y = center.y + radius * sin(angle);
    
    return CGPointMake(x, y);
}

+ (NSURL *) fetchFacebookUserProfilePictureURL : (id<FBGraphUser>) user{
    NSString *imageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=350&height=350", user.objectID];
    return [NSURL URLWithString:imageUrl];

}

+ (void ) setImageWithFacebook : (id<FBGraphUser>) user imageview:(UIImageView*)imageView blur:(BOOL)blur{
    
    NSLog(@"%@", user.objectID);
    [imageView sd_setImageWithURL:[Utils fetchFacebookUserProfilePictureURL:user]
                 placeholderImage:[UIImage imageNamed:@"default_place-folder.jpg"]
                          options:SDWebImageRefreshCached
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if(image && blur){
                                
                                UIImage *blurImage = [image blurredImageWithRadius:30.0f iterations:5 tintColor:[UIColor clearColor]];
                                imageView.image = blurImage;
                            }
                        }
     
     
     ];
}


+ (void ) setPlaceHolderImage : (UIImageView*)imageView blur:(BOOL)blur{
    
    UIImage *baseImage = [UIImage imageNamed:@"default_place-folder.jpg"];
    
    if(blur){
        UIImage *baseImage = imageView.image;
        UIImage *blurImage = [baseImage blurredImageWithRadius:30.0f iterations:5 tintColor:[UIColor clearColor]];
        imageView.image = blurImage;
    }else{
        imageView.image = baseImage;
    }
}


@end
