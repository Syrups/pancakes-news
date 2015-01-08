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
                                
                                UIVisualEffect *blurEffect;
                                blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                                
                                UIVisualEffectView *visualEffectView;
                                visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                                
                                visualEffectView.frame = imageView.bounds;
                                visualEffectView.alpha = 0.5;
                                [imageView addSubview:visualEffectView];
                            }
                        }
     
     
     ];
}


+ (void ) setPlaceHolderImage : (UIImageView*)imageView blur:(BOOL)blur{
    
    UIImage *baseImage = [UIImage imageNamed:@"default_place-folder.jpg"];
    
    if(blur){
        UIImage *baseImage = imageView.image;
        
        imageView.image = baseImage;
    }else{
        imageView.image = baseImage;
    }
}


+ (UIView*) addDropShadowToView: (UIView *)view {
    
    UIView* backView = [[UIView alloc] initWithFrame:view.bounds];
    backView.backgroundColor = [UIColor clearColor];
    backView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:backView.bounds];
    
    [backView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [backView.layer setShadowOffset:CGSizeMake(5, 0)];
    [backView.layer setShadowRadius:20.f];
    [backView.layer setShadowOpacity:1];
    
    backView.clipsToBounds = NO;
    backView.layer.masksToBounds = NO;
    
    backView.layer.shadowPath = path.CGPath;
    backView.layer.shouldRasterize = YES;
    backView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview insertSubview:backView belowSubview:view];
    
    //Size constraint
    [view.superview addConstraint:[NSLayoutConstraint
                              constraintWithItem:backView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0.0]];
    
    [view.superview addConstraint:[NSLayoutConstraint
                                       constraintWithItem:backView
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:view
                                       attribute:NSLayoutAttributeHeight
                                       multiplier:1
                                       constant:0.0]];
    
    //Position constraint
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [view.superview addConstraint:xCenterConstraint];
    
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:backView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [view.superview addConstraint:yCenterConstraint];
    
    return backView;
}

+ (UIImage *)imageByCroppingImage:(UIImage *)chosenImage toSize:(CGSize)size
{
    CGFloat imageWidth  = chosenImage.size.width;
    CGFloat imageHeight = chosenImage.size.height;
    
    CGRect cropRect;
    
    if ( imageWidth < imageHeight) {
        // Potrait mode
        cropRect = CGRectMake (0.0, (imageHeight - imageWidth) / 2.0, imageWidth, imageWidth);
    } else {
        // Landscape mode
        cropRect = CGRectMake ((imageWidth - imageHeight) / 2.0, 0.0, imageHeight, imageHeight);
    }
    
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect ([chosenImage CGImage], cropRect);
    
    // Create new cropped UIImage
    UIImage * croppedImage = [UIImage imageWithCGImage: imageRef];
    
    CGImageRelease (imageRef);
    
    return croppedImage;
}


@end
