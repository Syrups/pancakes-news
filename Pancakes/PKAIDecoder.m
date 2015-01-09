//
//  PKAIDecoder.m
//  Pancakes
//
//  Created by Glenn Sonna on 10/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@import UIKit;
#import "PKAIDecoder.h"
#import "PKAIDecoder.h"


@implementation PKAIDecoder


- (UIImage *) buildUIImageWithBase64: (NSString *)base64String{
    
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage* image = [UIImage imageWithData:data];
    
    return image;
}

+ (UIImage *) decodeImageFromString: (NSString *)base64String{
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage* image = [UIImage imageWithData:data];
    
    return image;
}

+ (NSArray *) decodeImageFromFile: (NSString *)file{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:file ofType:@"pkai"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSArray *bas64Images = [content componentsSeparatedByString:@"===PANCAKES==="];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSString *base64String in bas64Images) {
        
        if(base64String != nil && base64String.length > 3){
          
            NSArray* words = [base64String componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            
            NSData* data = [[NSData alloc] initWithBase64EncodedString:nospacestring options:0];
     

            if(data != nil ){
                UIImage* image = [UIImage imageWithData:data];
                [images addObject:image];
                
            }
        }
    }
    
    return  images;
}

+ (void) builAnimatedImageIn:(UIImageView *) imageView  fromFile:(NSString *)file{
    
    NSArray *images = [PKAIDecoder decodeImageFromFile:file];
    imageView.animationImages = images;
    imageView.animationDuration = 1.5f;
    [imageView setTintColor:[UIColor blackColor]];
    [imageView startAnimating];
}

+(void)updateAnimatedImageTintInButton: (UIButton *) button withColor:(UIColor*)color withAnimation:(BOOL)animated{
    
    if(animated){
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button.imageView stopAnimating];
            [button.imageView setTintColor:color];
        }completion:^(BOOL finished) {
            [button.imageView startAnimating];
        }];
    }else{
        [PKAIDecoder updateAnimatedImageTintInButton:button withColor:color];
    }
}

+(void)updateAnimatedImageTintInButton: (UIButton *) button withColor:(UIColor*)color  {
    
    [button.imageView stopAnimating];
    [button.imageView setTintColor:color];
    [button.imageView startAnimating];
}

+ (void) builAnimatedImageInButton:(UIButton *) button  fromFile:(NSString *)file withColor:(UIColor*)color {
    
    NSArray *images = [PKAIDecoder decodeImageFromFile:file];
    
    if (images.count == 0) {
        NSLog(@"PKAIDecoder : wrong filename (no .pkai file found with such name : %@)", file);
        return;
    }
    
    if (color != nil) {
        NSMutableArray* imgs = @[].mutableCopy;
        for (UIImage* img in images) {
            UIImage* newImg = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [imgs addObject:newImg];
        }
        
        images = imgs.copy;
       
    }
    
  
    [button setImage:[images objectAtIndex:images.count-1] forState:UIControlStateNormal];
   
    [button.imageView setAnimationImages:[images copy]];
    [button.imageView setAnimationDuration:1.3f];
    [button.imageView setAnimationRepeatCount:1];
    
    [button.imageView stopAnimating];
    [button.imageView setTintColor:color];
    [button.imageView setNeedsDisplay];
    
    [UIView setAnimationDelegate:self];
    
    //[button.imageView startAnimating];
    
//
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    animation.calculationMode = kCAAnimationDiscrete;
//    animation.duration = images.count / 24.0; // 24 frames per second
//    animation.values = images;
//    animation.repeatCount = 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    [button.imageView.layer addAnimation:animation forKey:@"animation"];
}


@end
