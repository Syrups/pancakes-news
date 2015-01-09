//
//  PKAIDecoder.h
//  Pancakes
//
//  Created by Glenn Sonna on 10/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PKAIDecoder : NSObject

+ (UIImage *) decodeImageFromString: (NSString *)string;
+ (NSArray *) decodeImageFromFile: (NSString *)file;

+ (void) builAnimatedImageIn:(UIImageView *) imageView  fromFile:(NSString *)file;
+ (void) builAnimatedImageInButton:(UIButton *) button  fromFile:(NSString *)file withColor:(UIColor*)color;
+ (void)updateAnimatedImageTintInButton: (UIButton *) button withColor:(UIColor*)color ;
+ (void)updateAnimatedImageTintInButton: (UIButton *) button withColor:(UIColor*)color withAnimation:(BOOL)animated;
@end
